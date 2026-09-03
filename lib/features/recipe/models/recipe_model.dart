/// A single recipe ingredient, including local swap hints.
class Ingredient {
  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
    this.substitutions = const <String>[],
    this.storeTip,
  });

  final String name;
  final double amount;
  final String unit;
  final List<String> substitutions;
  final String? storeTip;
}

/// One cooking instruction, optionally with a timer.
class RecipeStep {
  RecipeStep({
    required this.stepNumber,
    required this.instruction,
    this.timerMinutes,
  });

  final int stepNumber;
  final String instruction;
  final int? timerMinutes;
}

/// Recipe diary entry with cook measures (aligned with PROJECT_SPEC §5).
class RecipeModel {
  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    this.authorTitle,
    required this.imageUrl,
    required this.category,
    required this.cookingTimeMinutes,
    required this.ingredients,
    required this.steps,
    this.satisfactionScore = 5.0,
    this.recommendationTag = 'microwave only!',
    this.cookNote,
    this.parentRecipeId,
    this.remixCount = 0,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final String? authorTitle;
  final String imageUrl;
  final String category;
  final int cookingTimeMinutes;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  /// Author's satisfaction rating out of 5.0.
  final double satisfactionScore;

  /// Short recommendation label shown as a chip.
  final String recommendationTag;

  /// Optional real-cook tip memo from the author.
  final String? cookNote;

  /// Original recipe id when this entry is a remix/fork; null if original.
  final String? parentRecipeId;

  final int remixCount;
  final DateTime createdAt;
}
