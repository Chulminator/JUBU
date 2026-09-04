import '../models/recipe_model.dart';

/// In-memory sample recipes and pending rating queue (pre-Firebase).
class MockRecipeService {
  MockRecipeService._();

  /// Mock uid for the signed-in user (My Log tests).
  static const String currentUserId = 'current_user_me';

  static final List<String> _pendingRatingIds = <String>[];

  /// Returns all hard-coded recipes. No network or Firebase calls.
  static List<RecipeModel> getRecipes() =>
      List<RecipeModel>.unmodifiable(_recipes);

  /// Recipes written by the current mock user (My Log / diary).
  static List<RecipeModel> getMyRecipes() => List<RecipeModel>.unmodifiable(
        _recipes.where((RecipeModel r) => r.authorId == currentUserId),
      );

  /// Recipes waiting for the cooker's star rating after Cooking Mode.
  static List<RecipeModel> getPendingRatings() {
    final result = <RecipeModel>[];
    for (final id in _pendingRatingIds) {
      for (final recipe in _recipes) {
        if (recipe.id == id) {
          result.add(recipe);
          break;
        }
      }
    }
    return List<RecipeModel>.unmodifiable(result);
  }

  /// Queues a recipe for rating after cooking finishes.
  static void addPendingRating(String recipeId) {
    if (!_pendingRatingIds.contains(recipeId)) {
      _pendingRatingIds.add(recipeId);
    }
  }

  /// Saves the cooker's rating and clears the pending flag.
  static void submitPendingRating(String recipeId, double score) {
    for (final recipe in _recipes) {
      if (recipe.id == recipeId) {
        recipe.satisfactionScore = score;
        break;
      }
    }
    _pendingRatingIds.remove(recipeId);
  }

  /// Inserts a new recipe at the front of the in-memory list.
  static void addRecipe(RecipeModel recipe) {
    _recipes.insert(0, recipe);
  }

  static final List<RecipeModel> _recipes = <RecipeModel>[
    RecipeModel(
      id: 'mock-spicy-tofu-jorim',
      title: 'Spicy Braised Tofu',
      description: 'Pan-seared tofu simmered in soy–chili sauce.',
      authorId: currentUserId,
      authorName: 'Chulmin',
      authorTitle: 'K-Banchan Craftsman',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
      category: 'Korean',
      cookingTimeMinutes: 20,
      ingredients: <Ingredient>[
        Ingredient(name: 'Tofu', amount: 400, unit: 'g'),
        Ingredient(name: 'Soy sauce', amount: 2, unit: 'tbsp'),
        Ingredient(name: 'Water', amount: 120, unit: 'ml'),
        Ingredient(
          name: 'Gochugaru',
          amount: 1,
          unit: 'tbsp',
          storeTip: "Trader Joe's Spice aisle",
        ),
        Ingredient(name: 'Sugar', amount: 1, unit: 'tsp'),
        Ingredient(name: 'Minced garlic', amount: 1, unit: 'tsp'),
        Ingredient(name: 'Cooking oil', amount: 1, unit: 'tbsp'),
      ],
      steps: <RecipeStep>[
        RecipeStep(
          stepNumber: 1,
          instruction: 'Cut tofu into bite-size pieces and sear until golden.',
        ),
        RecipeStep(
          stepNumber: 2,
          instruction: 'Pour in soy sauce, water, gochugaru, sugar, and garlic.',
        ),
        RecipeStep(
          stepNumber: 3,
          instruction: 'Simmer on medium-low until the sauce thickens.',
          timerMinutes: 5,
        ),
      ],
      satisfactionScore: 4.5,
      recommendationTags: <String>['Rice thief guaranteed!', 'Weeknight banchan'],
      cookNote:
          'Next time use half a spoon less soy. Pat tofu dry for a better sear.',
      createdAt: DateTime(2026, 8, 12),
    ),
    RecipeModel(
      id: 'mock-kimchi-bacon-pasta',
      title: 'Kimchi Bacon Pasta',
      description: 'Creamy pasta tossed with sour kimchi and crispy bacon.',
      authorId: 'user_emily',
      authorName: 'Emily',
      authorTitle: 'Fusion Alchemist',
      imageUrl:
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&w=800&q=80',
      category: 'Fusion',
      cookingTimeMinutes: 25,
      ingredients: <Ingredient>[
        Ingredient(name: 'Pasta', amount: 200, unit: 'g'),
        Ingredient(name: 'Bacon', amount: 150, unit: 'g'),
        Ingredient(name: 'Sour kimchi', amount: 150, unit: 'g'),
        Ingredient(
          name: 'Heavy cream',
          amount: 120,
          unit: 'ml',
          storeTip: 'Dairy aisle at most US grocery stores',
        ),
        Ingredient(name: 'Olive oil', amount: 1, unit: 'tbsp'),
        Ingredient(name: 'Minced garlic', amount: 2, unit: 'tsp'),
        Ingredient(name: 'Parmesan', amount: 20, unit: 'g'),
      ],
      steps: <RecipeStep>[
        RecipeStep(
          stepNumber: 1,
          instruction: 'Boil pasta 1 minute under package time, then drain.',
        ),
        RecipeStep(
          stepNumber: 2,
          instruction: 'Crisp the bacon in olive oil.',
        ),
        RecipeStep(
          stepNumber: 3,
          instruction: 'Stir-fry kimchi and garlic, then add cream.',
        ),
        RecipeStep(
          stepNumber: 4,
          instruction: 'Toss with pasta and finish with parmesan.',
        ),
      ],
      remixCount: 2,
      satisfactionScore: 4.8,
      recommendationTags: <String>['Must share with friends!', 'Fusion'],
      cookNote: 'Older kimchi tastes deeper. Milk + butter works if cream is out.',
      createdAt: DateTime(2026, 8, 20),
    ),
    RecipeModel(
      id: 'mock-beef-miyeokguk',
      title: 'Beef Seaweed Soup',
      description: 'Clear soup of soaked seaweed and beef in sesame oil.',
      authorId: 'user_alex',
      authorName: 'Alex',
      imageUrl:
          'https://images.unsplash.com/photo-1547592166-23acba624cda?auto=format&fit=crop&w=800&q=80',
      category: 'Korean',
      cookingTimeMinutes: 40,
      ingredients: <Ingredient>[
        Ingredient(name: 'Dried seaweed', amount: 20, unit: 'g'),
        Ingredient(name: 'Beef', amount: 200, unit: 'g'),
        Ingredient(name: 'Sesame oil', amount: 1, unit: 'tbsp'),
        Ingredient(
          name: 'Soup soy sauce',
          amount: 2,
          unit: 'tbsp',
          storeTip: 'Whole Foods Asian section',
        ),
        Ingredient(name: 'Water', amount: 1200, unit: 'ml'),
        Ingredient(name: 'Minced garlic', amount: 1, unit: 'tsp'),
      ],
      steps: <RecipeStep>[
        RecipeStep(
          stepNumber: 1,
          instruction: 'Soak dried seaweed, squeeze dry, and cut bite-size.',
        ),
        RecipeStep(
          stepNumber: 2,
          instruction: 'Sauté beef and seaweed in sesame oil.',
        ),
        RecipeStep(
          stepNumber: 3,
          instruction: 'Add water, soup soy, and garlic; simmer.',
          timerMinutes: 20,
        ),
      ],
      satisfactionScore: 4.2,
      recommendationTags: <String>['Easy weeknight bowl'],
      createdAt: DateTime(2026, 9, 1),
    ),
  ];
}
