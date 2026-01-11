import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/app_colors.dart';

class AvatarUploadModal extends StatelessWidget {
  const AvatarUploadModal({
    super.key,
    required this.currentAvatar,
    required this.onImageSelected,
  });

  final String? currentAvatar;
  final Function(dynamic) onImageSelected; // File on mobile, XFile on web

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        if (context.mounted) {
          Navigator.of(context).pop();
          // On web, pass XFile directly; on mobile/desktop, convert to File
          if (kIsWeb) {
            onImageSelected(pickedFile);
          } else {
            onImageSelected(File(pickedFile.path));
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Change Profile Photo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 24),
            
            // Current avatar preview
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.outlineVariant,
                  width: 2,
                ),
              ),
                child: ClipOval(
                  child: _buildAvatarImage(context),
                ),
            ),
            
            const SizedBox(height: 24),
            
            // Upload options
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(context, ImageSource.gallery),
                icon: const Icon(Icons.photo_library_rounded),
                label: const Text('Choose from Gallery'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(context, ImageSource.camera),
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Take Photo'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarImage(BuildContext context) {
    if (currentAvatar == null || currentAvatar!.isEmpty) {
      return _buildPlaceholder();
    }
    
    // Check if it's a base64 data URI (web)
    if (currentAvatar!.startsWith('data:image')) {
      try {
        final base64String = currentAvatar!.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        );
      } catch (e) {
        return _buildPlaceholder();
      }
    }
    
    // Check if it's a network URL
    if (currentAvatar!.startsWith('http')) {
      return Image.network(
        currentAvatar!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }
    
    // Check if it's a file path (mobile/desktop only, not web)
    if (!kIsWeb && (currentAvatar!.startsWith('/') || currentAvatar!.contains(Platform.pathSeparator))) {
      return Image.file(
        File(currentAvatar!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }
    
    // Fallback to asset
    return Image.asset(
      currentAvatar!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceColor,
      ),
      child: const Icon(
        Icons.person,
        size: 60,
        color: AppColors.textTertiary,
      ),
    );
  }
}
