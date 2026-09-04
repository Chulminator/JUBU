import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/recipe_model.dart';
import '../services/mock_recipe_service.dart';
import 'create_recipe_screen.dart';
import 'recipe_detail_screen.dart';

/// Triple-tab home: Explore / Friends / My Log + FAB.
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
    final pending = MockRecipeService.getPendingRatings();

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
            _RecipeOnlyMetaGrid(recipes: recipes),
            _RecipeOnlyMetaList(recipes: recipes),
            _MyLogView(
              recipes: myRecipes,
              pending: pending,
              onRated: () => setState(() {}),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openCreateRecipe,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          tooltip: 'New recipe',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// Feed card: photo, title, rating, tags, author, author title.
class _RecipeMetaCard extends StatelessWidget {
  const _RecipeMetaCard({required this.recipe, this.wide = false});

  final RecipeModel recipe;
  final bool wide;

  Widget _cover() {
    final url = recipe.imageUrl;
    if (!url.startsWith('http')) {
      final file = File(url);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover, width: double.infinity);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: wide ? 160 : 110,
              width: double.infinity,
              child: _cover(),
            ),
            Padding(
              padding: EdgeInsets.all(wide ? 14 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.swapHighlight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.satisfactionScore.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.swapHighlight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: recipe.recommendationTags.map((String tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tag,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (recipe.authorTitle != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      recipe.authorTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeOnlyMetaGrid extends StatelessWidget {
  const _RecipeOnlyMetaGrid({required this.recipes});

  final List<RecipeModel> recipes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return _RecipeMetaCard(recipe: recipes[index]);
      },
    );
  }
}

class _RecipeOnlyMetaList extends StatelessWidget {
  const _RecipeOnlyMetaList({required this.recipes});

  final List<RecipeModel> recipes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
            height: 280,
            child: _RecipeMetaCard(recipe: recipes[index], wide: true),
          ),
        );
      },
    );
  }
}

class _MyLogView extends StatelessWidget {
  const _MyLogView({
    required this.recipes,
    required this.pending,
    required this.onRated,
  });

  final List<RecipeModel> recipes;
  final List<RecipeModel> pending;
  final VoidCallback onRated;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        if (pending.isNotEmpty) ...<Widget>[
          Text('Awaiting your rating', style: AppTextStyles.subtitle),
          const SizedBox(height: 4),
          Text(
            'Finished Cooking Mode — tap to rate.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 8),
          ...pending.map(
            (RecipeModel r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: AppColors.swapHighlightLight,
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  leading: const Icon(
                    Icons.star_outline,
                    color: AppColors.swapHighlight,
                  ),
                  title: Text(r.title, style: AppTextStyles.body),
                  subtitle: const Text('Pending rating'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RecipeDetailScreen(recipe: r),
                      ),
                    );
                    onRated();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text('My Cook Log', style: AppTextStyles.subtitle),
        const SizedBox(height: 4),
        Text(
          '${recipes.length} cook log${recipes.length == 1 ? '' : 's'}',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 12),
        if (recipes.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No cook logs yet.\nTap + to add one.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              return _RecipeMetaCard(recipe: recipes[index]);
            },
          ),
      ],
    );
  }
}
