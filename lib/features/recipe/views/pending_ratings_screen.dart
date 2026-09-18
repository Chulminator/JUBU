import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/recipe_model.dart';
import '../services/mock_recipe_service.dart';
import 'rate_recipe_screen.dart';

/// List of recipes waiting for a post-cook rating (opened from Settings).
class PendingRatingsScreen extends StatefulWidget {
  const PendingRatingsScreen({super.key});

  @override
  State<PendingRatingsScreen> createState() => _PendingRatingsScreenState();
}

class _PendingRatingsScreenState extends State<PendingRatingsScreen> {
  Future<void> _openRate(RecipeModel recipe) async {
    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => RateRecipeScreen(recipe: recipe),
      ),
    );
    if (saved == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<RecipeModel> pending = MockRecipeService.getPendingRatings();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Awaiting your rating'),
      ),
      body: pending.isEmpty
          ? Center(
              child: Text(
                'Nothing waiting.\nFinish Cooking Mode to add items here.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pending.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 8),
              itemBuilder: (BuildContext context, int index) {
                final RecipeModel r = pending[index];
                return Material(
                  color: AppColors.swapHighlightLight,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    leading: const Icon(
                      Icons.star_outline,
                      color: AppColors.swapHighlight,
                    ),
                    title: Text(r.title, style: AppTextStyles.body),
                    subtitle: const Text('Tap to rate & comment'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openRate(r),
                  ),
                );
              },
            ),
    );
  }
}
