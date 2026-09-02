/// A single recipe ingredient, including local swap hints.
class Ingredient {
  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
    this.substitutions = const <String>[],
    this.storeTip,
  });

  /// Display name (e.g. gochugaru).
  final String name;

  /// Quantity for [unit] at the recipe's base serving size.
  final double amount;

  /// Unit label such as g, ml, oz, tbsp, or cup.
  final String unit;

  /// Local grocery substitutes (e.g. cayenne + paprika).
  final List<String> substitutions;

  /// Optional aisle or store hint (e.g. Trader Joe's spice aisle).
  final String? storeTip;
}

/// One cooking instruction, optionally with a timer.
class RecipeStep {
  const RecipeStep({
    required this.stepNumber,
    required this.instruction,
    this.timerMinutes,
  });

  /// 1-based order in the cooking flow.
  final int stepNumber;

  /// What the cook should do in this step.
  final String instruction;

  /// Optional timer length in minutes.
  final int? timerMinutes;
}

/// A recipe card/detail payload used across JUBU features.
class RecipeModel {
  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    required this.imageUrl,
    required this.category,
    required this.baseServings,
    required this.cookingTimeMinutes,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
    this.authorTitle,
    this.parentRecipeId,
    this.remixCount = 0,
  });

  final String id;
  final String title;
  final String description;
  final String authorName;

  /// Equipped gamification title shown next to the author name.
  final String? authorTitle;

  final String imageUrl;
  final String category;

  /// Serving count the [ingredients] amounts were written for.
  final int baseServings;

  final int cookingTimeMinutes;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  /// Original recipe id when this entry is a remix/fork; null if original.
  final String? parentRecipeId;

  /// How many remixes have been created from this recipe.
  final int remixCount;

  final DateTime createdAt;
}
