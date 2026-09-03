import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/unit_converter.dart';
import '../../cooking_mode/views/cooking_mode_screen.dart';
import '../models/recipe_model.dart';

/// Read-only recipe detail. Ingredient amounts always pass through UnitConverter
/// using the user's unit preference (placeholder until UserModel is wired).
class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  /// User unit preference. Default Metric; later read from UserModel.preferImperial.
  bool isImperial = false;

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Recipe'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isImperial ? Icons.straighten : Icons.science_outlined,
            ),
            tooltip: isImperial ? 'Imperial (tap to Metric)' : 'Metric (tap to Imperial)',
            onPressed: () {
              setState(() => isImperial = !isImperial);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ----- hero image -----
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return ColoredBox(
                    color: AppColors.surfaceMuted,
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 48),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // ----- title -----
                  Text(recipe.title, style: AppTextStyles.title),
                  const SizedBox(height: 6),

                  // ----- meta row -----
                  Row(
                    children: <Widget>[
                      const Icon(Icons.timer_outlined,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.cookingTimeMinutes} min',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.person_outline,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        recipe.authorName,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),

                  // ----- author title badge -----
                  if (recipe.authorTitle != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
                  ],

                  const SizedBox(height: 20),

                  // ----- cook note card -----
                  _CookNoteCard(recipe: recipe),

                  const SizedBox(height: 20),

                  // ----- ingredients (auto unit via UnitConverter) -----
                  Text('Ingredients', style: AppTextStyles.subtitle),
                  const SizedBox(height: 10),
                  ...recipe.ingredients.map(
                    (Ingredient ing) => _IngredientTile(
                      ingredient: ing,
                      isImperial: isImperial,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ----- steps -----
                  Text('Steps', style: AppTextStyles.subtitle),
                  const SizedBox(height: 10),
                  ...recipe.steps.map(
                    (step) => _StepRow(
                      stepNumber: step.stepNumber,
                      instruction: step.instruction,
                      timerMinutes: step.timerMinutes,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ----- bottom action bar -----
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CookingModeScreen(recipe: widget.recipe),
                  ),
                );
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
                '요리 모드 시작',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cook Note card
// ---------------------------------------------------------------------------

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
          // satisfaction stars + score
          Row(
            children: <Widget>[
              ...List<Widget>.generate(5, (i) {
                if (i < fullStars) {
                  return const Icon(Icons.star_rounded,
                      color: AppColors.swapHighlight, size: 20);
                } else if (i == fullStars && hasHalf) {
                  return const Icon(Icons.star_half_rounded,
                      color: AppColors.swapHighlight, size: 20);
                } else {
                  return const Icon(Icons.star_outline_rounded,
                      color: AppColors.swapHighlight, size: 20);
                }
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

          // recommendation tag chip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              recipe.recommendationTag,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // cook note memo (optional)
          if (recipe.cookNote != null) ...<Widget>[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('"', style: TextStyle(fontSize: 28, height: 1)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    recipe.cookNote!,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ingredient tile
// ---------------------------------------------------------------------------

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

    final hasSubstitutions = ingredient.substitutions.isNotEmpty;
    final storeTip = ingredient.storeTip;
    final hasStoreTip = storeTip != null && storeTip.isNotEmpty;

    final tipLines = <String>[];
    if (hasSubstitutions) {
      tipLines.add('Substitutes: ${ingredient.substitutions.join(' / ')}');
    }
    if (hasStoreTip) {
      tipLines.add('Store tip: $storeTip');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(ingredient.name, style: AppTextStyles.body),
              ),
              const SizedBox(width: 8),
              Text(
                '$amountText ${display.unit}',
                style:
                    AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (tipLines.isNotEmpty) ...<Widget>[
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.swapHighlightLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '💡 ${tipLines.join('\n')}',
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Always routes through [UnitConverter] based on [isImperial].
  /// Spoon units (tbsp/tsp) keep their amount and label.
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

    final converted = UnitConverter.convert(
      amount: ingredient.amount,
      fromUnit: from,
      toUnit: to,
    );
    return (amount: converted, unit: to);
  }
}

// ---------------------------------------------------------------------------
// Step row
// ---------------------------------------------------------------------------

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.stepNumber,
    required this.instruction,
    required this.timerMinutes,
  });

  final int stepNumber;
  final String instruction;
  final int? timerMinutes;

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
            // step number badge — left-aligned, same baseline as text
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
                    Row(
                      children: <Widget>[
                        const Icon(Icons.timer_outlined,
                            size: 14, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '$timerMinutes min',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
