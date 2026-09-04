import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/unit_converter.dart';
import '../../cooking_mode/views/cooking_mode_screen.dart';
import '../models/recipe_model.dart';
import '../services/mock_recipe_service.dart';

/// Vertical recipe detail: overview, ingredients, steps, optional rating.
class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  /// User unit preference placeholder until UserModel is wired.
  bool isImperial = false;
  double _pendingScore = 5.0;

  @override
  void initState() {
    super.initState();
    _pendingScore = widget.recipe.satisfactionScore;
  }

  bool get _isPendingRating => MockRecipeService.getPendingRatings()
      .any((RecipeModel r) => r.id == widget.recipe.id);

  Widget _coverImage() {
    final url = widget.recipe.imageUrl;
    if (url.startsWith('/') || url.contains(':\\') || !url.startsWith('http')) {
      final file = File(url);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover, width: double.infinity);
      }
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
          ColoredBox(
        color: AppColors.surfaceMuted,
        child: const Center(child: Icon(Icons.restaurant, size: 48)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text(recipe.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isImperial ? Icons.straighten : Icons.science_outlined,
            ),
            tooltip: isImperial
                ? 'Imperial (tap for Metric)'
                : 'Metric (tap for Imperial)',
            onPressed: () {
              setState(() => isImperial = !isImperial);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: _coverImage(),
            ),
          ),
          const SizedBox(height: 12),
          Text(recipe.title, style: AppTextStyles.title),
          const SizedBox(height: 6),
          Text(
            '${recipe.cookingTimeMinutes} min · ${recipe.category}',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 8),
          Text('by ${recipe.authorName}', style: AppTextStyles.bodySmall),
          if (recipe.authorTitle != null) ...<Widget>[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.swapHighlightLight,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  recipe.authorTitle!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          _CookNoteCard(recipe: recipe),
          const SizedBox(height: 12),
          Text(recipe.description, style: AppTextStyles.body),
          const SizedBox(height: 24),
          Text('Ingredients', style: AppTextStyles.subtitle),
          const SizedBox(height: 10),
          ...recipe.ingredients.map(
            (Ingredient ing) => _IngredientTile(
              ingredient: ing,
              isImperial: isImperial,
            ),
          ),
          const SizedBox(height: 16),
          Text('Steps', style: AppTextStyles.subtitle),
          const SizedBox(height: 10),
          ...recipe.steps.map(
            (RecipeStep step) => _StepRow(
              stepNumber: step.stepNumber,
              instruction: step.instruction,
              timerMinutes: step.timerMinutes,
              imagePath: step.imagePath,
            ),
          ),
          if (_isPendingRating) ...<Widget>[
            const SizedBox(height: 24),
            Text('Rate this cook', style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Text(
              'You finished Cooking Mode. Leave a star rating for your My Log.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(5, (int i) {
                final filled = _pendingScore >= i + 1;
                final half = !filled && _pendingScore >= i + 0.5;
                return IconButton(
                  onPressed: () =>
                      setState(() => _pendingScore = (i + 1).toDouble()),
                  icon: Icon(
                    half
                        ? Icons.star_half_rounded
                        : filled
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                    color: AppColors.swapHighlight,
                    size: 36,
                  ),
                );
              }),
            ),
            Text(
              _pendingScore.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            Slider(
              value: _pendingScore,
              min: 0,
              max: 5,
              divisions: 10,
              activeColor: AppColors.swapHighlight,
              onChanged: (double v) => setState(() => _pendingScore = v),
            ),
            ElevatedButton(
              onPressed: () {
                MockRecipeService.submitPendingRating(
                  recipe.id,
                  _pendingScore,
                );
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thanks for rating!')),
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit rating'),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CookingModeScreen(recipe: recipe),
                  ),
                );
                if (mounted) {
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start cooking mode',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CookNoteCard extends StatelessWidget {
  const _CookNoteCard({required this.recipe});

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    final score = recipe.satisfactionScore;
    final fullStars = score.floor();
    final hasHalf = (score - fullStars) >= 0.5;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ...List<Widget>.generate(5, (int i) {
                if (i < fullStars) {
                  return const Icon(Icons.star_rounded,
                      color: AppColors.swapHighlight, size: 20);
                } else if (i == fullStars && hasHalf) {
                  return const Icon(Icons.star_half_rounded,
                      color: AppColors.swapHighlight, size: 20);
                }
                return const Icon(Icons.star_outline_rounded,
                    color: AppColors.swapHighlight, size: 20);
              }),
              const SizedBox(width: 6),
              Text(
                score.toStringAsFixed(1),
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 16,
                  color: AppColors.swapHighlight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: recipe.recommendationTags.map((String tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tag,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          if (recipe.cookNote != null) ...<Widget>[
            const SizedBox(height: 10),
            Text('"${recipe.cookNote}"', style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  const _IngredientTile({
    required this.ingredient,
    required this.isImperial,
  });

  final Ingredient ingredient;
  final bool isImperial;

  @override
  Widget build(BuildContext context) {
    final display = _displayAmountAndUnit();
    final amountText = UnitConverter.formatAmount(display.amount);
    final tip = ingredient.storeTip;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(ingredient.name, style: AppTextStyles.body),
              ),
              Text(
                '$amountText ${display.unit}',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (tip != null && tip.isNotEmpty) ...<Widget>[
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.swapHighlightLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('💡 $tip', style: AppTextStyles.bodySmall),
            ),
          ],
        ],
      ),
    );
  }

  ({double amount, String unit}) _displayAmountAndUnit() {
    final from = ingredient.unit.toLowerCase();
    var to = from;
    if (isImperial) {
      if (from == 'g') {
        to = 'oz';
      } else if (from == 'ml') {
        to = 'cup';
      }
    } else {
      if (from == 'oz') {
        to = 'g';
      } else if (from == 'cup') {
        to = 'ml';
      }
    }
    return (
      amount: UnitConverter.convert(
        amount: ingredient.amount,
        fromUnit: from,
        toUnit: to,
      ),
      unit: to,
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.stepNumber,
    required this.instruction,
    required this.timerMinutes,
    required this.imagePath,
  });

  final int stepNumber;
  final String instruction;
  final int? timerMinutes;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(instruction, style: AppTextStyles.body),
                  if (timerMinutes != null) ...<Widget>[
                    const SizedBox(height: 6),
                    Text(
                      'Timer: $timerMinutes min',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (imagePath != null) ...<Widget>[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePath!),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) =>
                            const SizedBox.shrink(),
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
