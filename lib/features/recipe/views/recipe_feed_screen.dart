import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/recipe_model.dart';
import '../services/mock_recipe_service.dart';

/// Dual-tab home feed: Explore (2-column grid) and Friends (wide cards).
class RecipeFeedScreen extends StatelessWidget {
  const RecipeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = MockRecipeService.getRecipes();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          title: Text(
            'JUBU',
            style: AppTextStyles.title.copyWith(color: AppColors.onPrimary),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              tooltip: 'Search',
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
              tooltip: 'Notifications',
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.onPrimary,
            unselectedLabelColor: Color(0xCCFFFFFF),
            indicatorColor: AppColors.onPrimary,
            tabs: const <Widget>[
              Tab(text: 'Explore'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _ExploreGrid(recipes: recipes),
            _FriendsList(recipes: recipes),
          ],
        ),
      ),
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  const _ExploreGrid({required this.recipes});

  final List<RecipeModel> recipes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final recipe = recipes[index];
        return Material(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _RecipeImage(url: recipe.imageUrl),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        recipe.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${recipe.cookingTimeMinutes} min',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FriendsList extends StatelessWidget {
  const _FriendsList({required this.recipes});

  final List<RecipeModel> recipes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final recipe = recipes[index];
        final tip = _firstStoreTip(recipe);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: _RecipeImage(url: recipe.imageUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          recipe.authorName,
                          style: AppTextStyles.subtitle,
                        ),
                        if (recipe.authorTitle != null) ...<Widget>[
                          const SizedBox(height: 2),
                          Text(
                            recipe.authorTitle!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(recipe.description, style: AppTextStyles.body),
                        if (tip != null) ...<Widget>[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.swapHighlightLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tip,
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String? _firstStoreTip(RecipeModel recipe) {
    for (final ingredient in recipe.ingredients) {
      if (ingredient.storeTip != null && ingredient.storeTip!.isNotEmpty) {
        return ingredient.storeTip;
      }
    }
    return null;
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return ColoredBox(
          color: AppColors.surfaceMuted,
          child: Icon(Icons.restaurant, color: AppColors.textSecondary),
        );
      },
    );
  }
}
