import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../core/stores/match_store.dart';

/// Matches page showing saved students.
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key, required this.matchStore});

  final MatchStore matchStore;

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  void initState() {
    super.initState();
    widget.matchStore.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.matchStore.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final matches = widget.matchStore.matches;

    if (matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite_border, size: 56, color: Colors.pinkAccent),
            SizedBox(height: 12),
            Text(
              'No matches yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Swipe right on students you\'d like to study with and they\'ll appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final student = matches[index];
        return Dismissible(
          key: ValueKey(student.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => widget.matchStore.removeMatch(student.id),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: _buildStudentAvatar(student),
              title: Text(student.name),
              subtitle: Wrap(
                spacing: 4,
                children: student.skills
                    .take(3)
                    .map(
                      (e) => Chip(
                        label: Text(e, style: const TextStyle(fontSize: 11)),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(student.rating.toStringAsFixed(1)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStudentAvatar(dynamic student) {
    ImageProvider? imageProvider;
    
    if (student.avatarUrl != null && student.avatarUrl!.isNotEmpty) {
      imageProvider = NetworkImage(student.avatarUrl!);
    } else if (student.avatar.isNotEmpty) {
      // Check if it's a base64 data URI (web)
      if (student.avatar.startsWith('data:image')) {
        final base64String = student.avatar.split(',')[1];
        final bytes = base64Decode(base64String);
        imageProvider = MemoryImage(bytes);
      } else if (student.avatar.startsWith('http')) {
        imageProvider = NetworkImage(student.avatar);
      } else if (!kIsWeb && (student.avatar.startsWith('/') || student.avatar.contains(Platform.pathSeparator))) {
        imageProvider = FileImage(File(student.avatar));
      } else {
        imageProvider = AssetImage(student.avatar);
      }
    }

    if (imageProvider == null) {
      return CircleAvatar(
        backgroundColor: AppColors.surfaceColor,
        child: const Icon(
          Icons.person,
          color: AppColors.textTertiary,
        ),
      );
    }

    return CircleAvatar(
      backgroundImage: imageProvider,
      onBackgroundImageError: (_, __) {},
      // No child icon - only show the uploaded image
    );
  }
}

