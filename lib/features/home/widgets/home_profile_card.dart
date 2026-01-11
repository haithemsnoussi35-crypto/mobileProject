import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../core/stores/user_profile_store.dart';

class HomeProfileCard extends StatefulWidget {
  const HomeProfileCard({super.key, required this.profileStore});

  final UserProfileStore profileStore;

  @override
  State<HomeProfileCard> createState() => _HomeProfileCardState();
}

class _HomeProfileCardState extends State<HomeProfileCard> {
  @override
  void initState() {
    super.initState();
    widget.profileStore.addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    widget.profileStore.removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onProfileChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profileStore.profile;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(widget.profileStore.profile.avatar),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: p.skills
                        .take(4)
                        .map(
                          (s) => Chip(
                            label: Text(s),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String avatar) {
    if (avatar.isEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundColor: AppColors.surfaceColor,
        child: const Icon(
          Icons.person,
          color: AppColors.textTertiary,
        ),
      );
    }

    final imageProvider = _getAvatarImageProvider(avatar);
    if (imageProvider == null) {
      return CircleAvatar(
        radius: 28,
        backgroundColor: AppColors.surfaceColor,
        child: const Icon(
          Icons.person,
          color: AppColors.textTertiary,
        ),
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundImage: imageProvider,
      onBackgroundImageError: (_, __) {},
      // No child icon - only show the uploaded image
    );
  }

  ImageProvider? _getAvatarImageProvider(String avatar) {
    if (avatar.isEmpty) return null;
    
    // Check if it's a base64 data URI (web)
    if (avatar.startsWith('data:image')) {
      final base64String = avatar.split(',')[1];
      final bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    }
    
    // Check if it's a network URL
    if (avatar.startsWith('http')) {
      return NetworkImage(avatar);
    }
    
    // Check if it's a file path (mobile/desktop only, not web)
    if (!kIsWeb && (avatar.startsWith('/') || avatar.contains(Platform.pathSeparator))) {
      return FileImage(File(avatar));
    }
    
    // Fallback to asset
    return AssetImage(avatar);
  }
}

