import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/recipe_model.dart';
import '../services/mock_recipe_service.dart';
import 'create_recipe_screen.dart';
import 'recipe_detail_screen.dart';

/// Triple-tab home: Explore / Friends / My Log + FAB to create a recipe.
class RecipeFeedScreen extends StatefulWidget {
  const RecipeFeedScreen({super.key});

  @override
  State<RecipeFeedScreen> createState() => _RecipeFeedScreenState();
}

class _RecipeFeedScreenState extends State<RecipeFeedScreen> {
  Future<void> _openCreateRecipe() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CreateRecipeScreen(),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipes = MockRecipeService.getRecipes();
    final myRecipes = MockRecipeService.getMyRecipes();

    return DefaultTabController(
      length: 3,
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
            unselectedLabelColor: const Color(0xCCFFFFFF),
            indicatorColor: AppColors.onPrimary,
            tabs: const <Widget>[
              Tab(text: 'Explore'),
              Tab(text: 'Friends'),
              Tab(text: 'My Log'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _ExploreGrid(recipes: recipes),
            _FriendsList(recipes: recipes),
            _MyLogGrid(recipes: myRecipes),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openCreateRecipe,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          tooltip: '새 레시피 작성',
          child: const Icon(Icons.add),
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
        return _RecipeGridCard(recipe: recipe);
      },
    );
  }
}

/// Instagram-style grid of recipes authored by the current user.
class _MyLogGrid extends StatelessWidget {
  const _MyLogGrid({required this.recipes});

  final List<RecipeModel> recipes;

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '아직 기록한 요리가 없습니다.\n우측 아래 + 버튼으로 추가해 보세요.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('My Cook Log', style: AppTextStyles.subtitle),
              const SizedBox(height: 4),
              Text(
                '${recipes.length}개의 요리 기록',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              return _RecipeGridCard(recipe: recipes[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _RecipeGridCard extends StatelessWidget {
  const _RecipeGridCard({required this.recipe});

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
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
                  Row(
                    children: <Widget>[
                      Text(
                        '${recipe.cookingTimeMinutes} min',
                        style: AppTextStyles.bodySmall,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.swapHighlight,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        recipe.satisfactionScore.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.swapHighlight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
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
                        const SizedBox(height: 6),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.swapHighlight,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              recipe.satisfactionScore.toStringAsFixed(1),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.swapHighlight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryLight,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  recipe.recommendationTag,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(recipe.description, style: AppTextStyles.body),
                        if (recipe.cookNote != null) ...<Widget>[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '"${recipe.cookNote}"',
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        ],
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
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return ColoredBox(
          color: AppColors.surfaceMuted,
          child: Icon(Icons.restaurant, color: AppColors.textSecondary),
        );
      },
    );
  }
}
