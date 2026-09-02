import '../models/recipe_model.dart';

/// In-memory sample recipes for UI work before Firebase is wired up.
class MockRecipeService {
  MockRecipeService._();

  /// Returns three hard-coded recipes. No network or Firebase calls.
  static List<RecipeModel> getRecipes() => List<RecipeModel>.unmodifiable(_recipes);

  static final List<RecipeModel> _recipes = <RecipeModel>[
    RecipeModel(
      id: 'mock-spicy-tofu-jorim',
      title: '매콤 두부조림',
      description: '노릇하게 구운 두부를 간장·고춧가루 양념에 졸인 기본 밑반찬.',
      authorName: '철민',
      authorTitle: 'K-반찬 장인',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
      category: '반찬',
      baseServings: 2,
      cookingTimeMinutes: 20,
      ingredients: const <Ingredient>[
        Ingredient(name: '두부', amount: 400, unit: 'g'),
        Ingredient(name: '진간장', amount: 2, unit: 'tbsp'),
        Ingredient(name: '물', amount: 120, unit: 'ml'),
        Ingredient(
          name: '고춧가루',
          amount: 1,
          unit: 'tbsp',
          substitutions: <String>[
            'Cayenne powder + Paprika',
            'Crushed red pepper',
          ],
          storeTip: "Trader Joe's Spice aisle",
        ),
        Ingredient(name: '설탕', amount: 1, unit: 'tsp'),
        Ingredient(name: '다진 마늘', amount: 1, unit: 'tsp'),
        Ingredient(name: '식용유', amount: 1, unit: 'tbsp'),
      ],
      steps: const <RecipeStep>[
        RecipeStep(
          stepNumber: 1,
          instruction: '두부를 한입 크기로 썰어 팬에 노릇하게 굽는다.',
        ),
        RecipeStep(
          stepNumber: 2,
          instruction: '진간장, 물, 고춧가루, 설탕, 마늘을 섞은 양념장을 붓는다.',
        ),
        RecipeStep(
          stepNumber: 3,
          instruction: '중약불에서 양념이 배도록 졸인다.',
          timerMinutes: 5,
        ),
      ],
      createdAt: DateTime(2026, 8, 12),
    ),
    RecipeModel(
      id: 'mock-kimchi-bacon-pasta',
      title: '김치 베이컨 파스타',
      description: '신김치와 베이컨을 볶아 크림 소스에 버무린 퓨전 면 요리.',
      authorName: 'Emily',
      authorTitle: '퓨전 연금술사',
      imageUrl:
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&w=800&q=80',
      category: '면',
      baseServings: 2,
      cookingTimeMinutes: 25,
      ingredients: const <Ingredient>[
        Ingredient(name: '파스타면', amount: 200, unit: 'g'),
        Ingredient(name: '베이컨', amount: 150, unit: 'g'),
        Ingredient(name: '신김치', amount: 150, unit: 'g'),
        Ingredient(
          name: '생크림',
          amount: 120,
          unit: 'ml',
          substitutions: <String>[
            'Heavy Cream',
            'Whole Milk + Butter',
          ],
          storeTip: '일반 미국 마트 Dairy 코너',
        ),
        Ingredient(name: '올리브오일', amount: 1, unit: 'tbsp'),
        Ingredient(name: '다진 마늘', amount: 2, unit: 'tsp'),
        Ingredient(name: '파마산 치즈', amount: 20, unit: 'g'),
      ],
      steps: const <RecipeStep>[
        RecipeStep(
          stepNumber: 1,
          instruction: '소금 넣은 물에 파스타면을 포장 시간보다 1분 덜 삶아 건진다.',
        ),
        RecipeStep(
          stepNumber: 2,
          instruction: '팬에 올리브오일을 두르고 베이컨을 바삭하게 볶는다.',
        ),
        RecipeStep(
          stepNumber: 3,
          instruction: '신김치와 마늘을 넣고 볶다가 생크림을 부어 소스를 만든다.',
        ),
        RecipeStep(
          stepNumber: 4,
          instruction: '면을 넣어 버무리고 파마산 치즈를 뿌려 마무리한다.',
        ),
      ],
      remixCount: 2,
      createdAt: DateTime(2026, 8, 20),
    ),
    RecipeModel(
      id: 'mock-beef-miyeokguk',
      title: '소고기 미역국',
      description: '불린 미역과 소고기를 참기름에 볶아 끓인 맑은 국.',
      authorName: 'Alex',
      imageUrl:
          'https://images.unsplash.com/photo-1547592166-23acba624cda?auto=format&fit=crop&w=800&q=80',
      category: '국',
      baseServings: 4,
      cookingTimeMinutes: 40,
      ingredients: const <Ingredient>[
        Ingredient(name: '마른 미역', amount: 20, unit: 'g'),
        Ingredient(name: '소고기', amount: 200, unit: 'g'),
        Ingredient(name: '참기름', amount: 1, unit: 'tbsp'),
        Ingredient(
          name: '국간장',
          amount: 2,
          unit: 'tbsp',
          substitutions: <String>[
            'Fish Sauce (피시소스) + 간장 약간',
          ],
          storeTip: 'Whole Foods 아시안 섹션',
        ),
        Ingredient(name: '물', amount: 1200, unit: 'ml'),
        Ingredient(name: '다진 마늘', amount: 1, unit: 'tsp'),
      ],
      steps: const <RecipeStep>[
        RecipeStep(
          stepNumber: 1,
          instruction: '마른 미역을 찬물에 불린 뒤 물기를 짜고 한입 크기로 자른다.',
        ),
        RecipeStep(
          stepNumber: 2,
          instruction: '냄비에 참기름을 두르고 소고기와 미역을 볶는다.',
        ),
        RecipeStep(
          stepNumber: 3,
          instruction: '물을 붓고 국간장·마늘을 넣어 끓인다.',
          timerMinutes: 20,
        ),
      ],
      createdAt: DateTime(2026, 9, 1),
    ),
  ];
}
