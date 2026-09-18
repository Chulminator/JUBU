import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Celebration screen when a title badge is unlocked.
class TitleBadgeUnlockScreen extends StatelessWidget {
  const TitleBadgeUnlockScreen({super.key, required this.badgeName});

  final String badgeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(flex: 2),
              const Icon(
                Icons.emoji_events_outlined,
                size: 72,
                color: AppColors.swapHighlight,
              ),
              const SizedBox(height: 20),
              Text(
                'Title unlocked!',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 12),
              Text(
                'You earned a new title badge.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.swapHighlightLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.swapHighlight),
                ),
                child: Text(
                  badgeName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.secondary,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Equip it anytime in Settings → Title badge.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Nice!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
