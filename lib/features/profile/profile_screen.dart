import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../app/app_colors.dart';
import '../../core/models/user_profile.dart';
import '../../core/stores/auth_store.dart';
import '../../core/stores/user_profile_store.dart';
import 'widgets/avatar_upload_modal.dart';

/// Profile screen with simple editing and persistence.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profileStore,
    required this.authStore,
  });

  final UserProfileStore profileStore;
  final AuthStore authStore;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _skillsController;
  late String _avatar;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.profileStore.profile;
    _nameController = TextEditingController(text: profile.name);
    _bioController = TextEditingController(text: profile.bio);
    _skillsController = TextEditingController(text: profile.skills.join(', '));
    _avatar = profile.avatar;
    
    // Listen to profile changes to update avatar if changed elsewhere
    widget.profileStore.addListener(_onProfileChanged);
  }
  
  void _onProfileChanged() {
    if (mounted) {
      setState(() {
        _avatar = widget.profileStore.profile.avatar;
        _nameController.text = widget.profileStore.profile.name;
        _bioController.text = widget.profileStore.profile.bio;
        _skillsController.text = widget.profileStore.profile.skills.join(', ');
      });
    }
  }

  @override
  void dispose() {
    widget.profileStore.removeListener(_onProfileChanged);
    _nameController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final skills = _skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final profile = UserProfile(
      name: _nameController.text.trim().isEmpty
          ? 'You'
          : _nameController.text.trim(),
      bio: _bioController.text.trim().isEmpty
          ? 'Describe how you like to study.'
          : _bioController.text.trim(),
      skills: skills,
      avatar: _avatar,
    );

    await widget.profileStore.update(profile);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved locally')));
    }
  }

  Future<void> _showAvatarUploadModal() async {
    showDialog(
      context: context,
      builder: (context) => AvatarUploadModal(
        currentAvatar: _avatar,
        onImageSelected: (dynamic imageFile) async {
          // Save image to local storage
          try {
            String avatarPath;
            
            if (kIsWeb) {
              // For web: convert XFile to base64 and store in SharedPreferences
              final bytes = await imageFile.readAsBytes();
              final base64Image = base64Encode(bytes);
              avatarPath = 'data:image/jpeg;base64,$base64Image';
            } else {
              // For mobile/desktop: save File to file system
              final file = imageFile as File;
              final directory = await getApplicationDocumentsDirectory();
              final imagePath = '${directory.path}/profile_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
              final savedFile = await file.copy(imagePath);
              avatarPath = savedFile.path;
            }
            
            setState(() {
              _avatar = avatarPath;
            });
            
            // Auto-save the avatar immediately after upload
            final currentProfile = widget.profileStore.profile;
            final updatedProfile = UserProfile(
              name: currentProfile.name,
              bio: currentProfile.bio,
              skills: currentProfile.skills,
              avatar: avatarPath,
            );
            await widget.profileStore.update(updatedProfile);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile picture updated successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving image: $e')),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (_avatar.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceColor,
        ),
        child: const Icon(
          Icons.person,
          size: 40,
          color: AppColors.textTertiary,
        ),
      );
    }

    // Check if it's a base64 data URI (web)
    if (_avatar.startsWith('data:image')) {
      final base64String = _avatar.split(',')[1];
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    // Check if it's a network URL
    if (_avatar.startsWith('http')) {
      return Image.network(
        _avatar,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    // Check if it's a file path (mobile/desktop)
    if (!kIsWeb && (_avatar.startsWith('/') || _avatar.contains(Platform.pathSeparator))) {
      return Image.file(
        File(_avatar),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }

    // Fallback to asset
    return Image.asset(
      _avatar,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceColor,
      ),
      child: const Icon(
        Icons.person,
        size: 40,
        color: AppColors.textTertiary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _showAvatarUploadModal,
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.outlineVariant,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _buildAvatarImage(),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBlue,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Your Study Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bioController,
            decoration: const InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _skillsController,
            decoration: const InputDecoration(
              labelText: 'Skills (comma separated)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Preview skills:',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _skillsController,
            builder: (context, _) {
              final skills = _skillsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              if (skills.isEmpty) {
                return const Text(
                  'Add some skills to see dynamic chips here.',
                  style: TextStyle(color: Colors.black54),
                );
              }
              return Wrap(
                spacing: 8,
                runSpacing: -4,
                children: skills
                    .map(
                      (s) => Chip(
                        label: Text(s),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_saving ? 'Saving...' : 'Save profile'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await widget.authStore.logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

