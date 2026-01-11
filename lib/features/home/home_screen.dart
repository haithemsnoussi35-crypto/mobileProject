import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../core/stores/match_store.dart';
import '../../core/stores/user_profile_store.dart';
import 'widgets/home_profile_card.dart';
import 'widgets/home_stats_card.dart';
import 'widgets/tip_chip.dart';
import 'widgets/studymatch_logo.dart';

/// Home screen with quick summary.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.profileStore,
    required this.matchStore,
  });

  final UserProfileStore profileStore;
  final MatchStore matchStore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and title row
          Row(
            children: [
              const StudyMatchLogo(size: 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Study',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Match',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryPink,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find your perfect study partner',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          HomeProfileCard(profileStore: profileStore),
          const SizedBox(height: 16),
          HomeStatsCard(matchCount: matchStore.matches.length),
          const SizedBox(height: 32),
          Text(
            'Quick Tips',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const TipChip(
            text: 'Swipe right when you\'d like to study together.',
          ),
          const SizedBox(height: 6),
          const TipChip(
            text: 'Use skills to quickly see who fits your needs.',
          ),
          const SizedBox(height: 6),
          const TipChip(text: 'Update your profile so others understand you.'),
        ],
      ),
    );
  }
}




