import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/user_provider.dart';
import '../../auth/views/login_screen.dart';
import '../../auth/views/onboarding_screen.dart';
import '../../auth/views/title_badge_unlock_screen.dart';
import '../../cooking_mode/views/cooking_mode_screen.dart';
import '../../recipe/models/recipe_model.dart';
import '../../recipe/services/mock_recipe_service.dart';
import '../../recipe/views/create_recipe_screen.dart';
import '../../recipe/views/pending_ratings_screen.dart';
import '../../recipe/views/rate_recipe_screen.dart';
import '../../recipe/views/recipe_detail_screen.dart';
import '../../recipe/views/recipe_feed_screen.dart';

/// Dev-only hub to jump between screens while iterating UI.
class DebugHubScreen extends StatelessWidget {
  const DebugHubScreen({super.key});

  RecipeModel get _sample => MockRecipeService.getRecipes().first;

  Future<void> _push(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Debug screens'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text('Navigation', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          _tile(
            context,
            'Recipe Feed',
            Icons.home_outlined,
            () => _push(context, const RecipeFeedScreen()),
          ),
          _tile(
            context,
            'Recipe Detail (sample)',
            Icons.menu_book_outlined,
            () => _push(context, RecipeDetailScreen(recipe: _sample)),
          ),
          _tile(
            context,
            'Create Recipe',
            Icons.add_circle_outline,
            () => _push(context, const CreateRecipeScreen()),
          ),
          _tile(
            context,
            'Cooking Mode (sample)',
            Icons.soup_kitchen_outlined,
            () => _push(context, CookingModeScreen(recipe: _sample)),
          ),
          _tile(
            context,
            'Pending Ratings',
            Icons.star_outline,
            () => _push(context, const PendingRatingsScreen()),
          ),
          _tile(
            context,
            'Rate Recipe (sample)',
            Icons.rate_review_outlined,
            () => _push(context, RateRecipeScreen(recipe: _sample)),
          ),
          _tile(
            context,
            'Login',
            Icons.login,
            () => _push(context, const LoginScreen()),
          ),
          _tile(
            context,
            'Onboarding',
            Icons.badge_outlined,
            () => _push(context, const OnboardingScreen()),
          ),
          const SizedBox(height: 20),
          Text('Quick actions', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          _tile(
            context,
            'Unlock title badge (demo)',
            Icons.emoji_events_outlined,
            () async {
              const String badge = 'Midnight Fryer';
              final bool isNew =
                  context.read<UserProvider>().unlockTitleBadge(badge);
              if (!context.mounted) {
                return;
              }
              await _push(
                context,
                TitleBadgeUnlockScreen(
                  badgeName: isNew ? badge : '$badge (already had)',
                ),
              );
            },
          ),
          _tile(
            context,
            'Queue sample for pending rating',
            Icons.playlist_add_check,
            () {
              MockRecipeService.addPendingRating(_sample.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Queued: ${_sample.title}')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.secondary),
        title: Text(label, style: AppTextStyles.body),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
