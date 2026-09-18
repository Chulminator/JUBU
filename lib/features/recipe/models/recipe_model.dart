/// A single recipe ingredient with optional store aisle tip.
class Ingredient {
  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
    this.storeTip,
  });

  final String name;
  final double amount;
  final String unit;

  /// Optional aisle / store tip (e.g. Trader Joe's spice aisle).
  final String? storeTip;
}

/// One cooking instruction, optionally with a timer and photo.
class RecipeStep {
  RecipeStep({
    required this.stepNumber,
    required this.instruction,
    this.timerMinutes,
    this.imagePath,
  });

  final int stepNumber;
  final String instruction;
  final int? timerMinutes;

  /// Local gallery file path for an optional step photo.
  final String? imagePath;
}

/// Recipe diary entry with cook measures (aligned with PROJECT_SPEC §5).
class RecipeModel {
  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.username,
    this.authorTitle,
    required this.imageUrl,
    required this.category,
    required this.cookingTimeMinutes,
    required this.ingredients,
    required this.steps,
    this.satisfactionScore = 5.0,
    this.hashtags = const <String>['microwave only!'],
    this.cookNote,
    this.ratingComment,
    this.parentRecipeId,
    this.remixCount = 0,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String authorId;

  /// Public handle shown on posts and profiles.
  final String username;
  final String? authorTitle;
  final String imageUrl;
  final String category;
  final int cookingTimeMinutes;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  /// Community / cook satisfaction rating out of 5.0.
  double satisfactionScore;

  /// Hashtags shown as `#tag` text (no chip UI on the feed).
  final List<String> hashtags;

  /// Optional real-cook tip memo from the author.
  final String? cookNote;

  /// Optional short comment (~20 words) left when rating after cooking.
  String? ratingComment;

  final String? parentRecipeId;
  final int remixCount;
  final DateTime createdAt;

  /// Formats tags as `#foo #bar` (space between tags; no spaces inside a tag).
  String get hashtagsLine {
    return hashtags
        .map((String t) {
          final String clean = t
              .trim()
              .replaceFirst(RegExp(r'^#+'), '')
              .replaceAll(RegExp(r'\s+'), '');
          return clean.isEmpty ? '' : '#$clean';
        })
        .where((String s) => s.isNotEmpty)
        .join(' ');
  }
}
