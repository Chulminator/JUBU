import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/recipe_model.dart';
import '../services/mock_recipe_service.dart';

/// Form to log a new recipe / cook diary entry into in-memory mock storage.
class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _category = TextEditingController(text: '반찬');
  final TextEditingController _cookTime = TextEditingController(text: '20');
  final TextEditingController _imageUrl = TextEditingController();
  final TextEditingController _recommendationTag =
      TextEditingController(text: 'microwave only!');
  final TextEditingController _cookNote = TextEditingController();

  double _satisfactionScore = 5.0;
  final List<_IngredientDraft> _ingredients = <_IngredientDraft>[
    _IngredientDraft(),
  ];
  final List<_StepDraft> _steps = <_StepDraft>[_StepDraft()];

  static const String _fallbackImage =
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80';

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _category.dispose();
    _cookTime.dispose();
    _imageUrl.dispose();
    _recommendationTag.dispose();
    _cookNote.dispose();
    for (final row in _ingredients) {
      row.dispose();
    }
    for (final row in _steps) {
      row.dispose();
    }
    super.dispose();
  }

  InputDecoration _field(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.cardBackground,
      labelStyle: AppTextStyles.bodySmall,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ingredients = <Ingredient>[];
    for (final row in _ingredients) {
      final name = row.name.text.trim();
      if (name.isEmpty) {
        continue;
      }
      ingredients.add(
        Ingredient(
          name: name,
          amount: double.tryParse(row.amount.text.trim()) ?? 0,
          unit: row.unit.text.trim().isEmpty ? 'g' : row.unit.text.trim(),
          substitutions: row.substitutions.text
              .split(',')
              .map((String s) => s.trim())
              .where((String s) => s.isNotEmpty)
              .toList(),
          storeTip: row.storeTip.text.trim().isEmpty
              ? null
              : row.storeTip.text.trim(),
        ),
      );
    }

    final steps = <RecipeStep>[];
    var stepNumber = 1;
    for (final row in _steps) {
      final instruction = row.instruction.text.trim();
      if (instruction.isEmpty) {
        continue;
      }
      final timerRaw = row.timerMinutes.text.trim();
      steps.add(
        RecipeStep(
          stepNumber: stepNumber,
          instruction: instruction,
          timerMinutes: timerRaw.isEmpty ? null : int.tryParse(timerRaw),
        ),
      );
      stepNumber += 1;
    }

    if (ingredients.isEmpty || steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('재료와 조리 단계를 각각 1개 이상 입력하세요.')),
      );
      return;
    }

    final note = _cookNote.text.trim();
    final image = _imageUrl.text.trim();
    final tag = _recommendationTag.text.trim();

    final recipe = RecipeModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim(),
      description: _description.text.trim(),
      authorId: MockRecipeService.currentUserId,
      authorName: '나',
      imageUrl: image.isEmpty ? _fallbackImage : image,
      category: _category.text.trim().isEmpty ? '반찬' : _category.text.trim(),
      cookingTimeMinutes: int.tryParse(_cookTime.text.trim()) ?? 0,
      ingredients: ingredients,
      steps: steps,
      satisfactionScore: _satisfactionScore,
      recommendationTag: tag.isEmpty ? 'microwave only!' : tag,
      cookNote: note.isEmpty ? null : note,
      createdAt: DateTime.now(),
    );

    MockRecipeService.addRecipe(recipe);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('새 레시피 / 요리 일지'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: <Widget>[
            Text('기본 정보', style: AppTextStyles.subtitle),
            const SizedBox(height: 10),
            TextFormField(
              controller: _title,
              style: AppTextStyles.body,
              decoration: _field('제목'),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? '제목을 입력하세요' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _description,
              style: AppTextStyles.body,
              maxLines: 3,
              decoration: _field('설명'),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? '설명을 입력하세요' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _category,
              style: AppTextStyles.body,
              decoration: _field('카테고리', hint: '반찬, 면, 국, Fusion…'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cookTime,
              style: AppTextStyles.body,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: _field('조리 시간 (분)'),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? '조리 시간을 입력하세요' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _imageUrl,
              style: AppTextStyles.body,
              decoration: _field(
                '대표 이미지 URL (선택)',
                hint: '비워 두면 기본 사진을 씁니다',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Text('재료', style: AppTextStyles.subtitle),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _ingredients.add(_IngredientDraft()));
                  },
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: Text(
                    '재료 추가',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            ...List<Widget>.generate(_ingredients.length, (int i) {
              return _IngredientCard(
                index: i,
                draft: _ingredients[i],
                decoration: _field,
                canRemove: _ingredients.length > 1,
                onRemove: () {
                  setState(() {
                    _ingredients[i].dispose();
                    _ingredients.removeAt(i);
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text('조리 단계', style: AppTextStyles.subtitle),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _steps.add(_StepDraft()));
                  },
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: Text(
                    '단계 추가',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            ...List<Widget>.generate(_steps.length, (int i) {
              return _StepCard(
                stepNumber: i + 1,
                draft: _steps[i],
                decoration: _field,
                canRemove: _steps.length > 1,
                onRemove: () {
                  setState(() {
                    _steps[i].dispose();
                    _steps.removeAt(i);
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            Text('요리 평가 / 다이어리', style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Text(
              '만족도 ${_satisfactionScore.toStringAsFixed(1)} / 5.0',
              style: AppTextStyles.body,
            ),
            Slider(
              value: _satisfactionScore,
              min: 0,
              max: 5,
              divisions: 10,
              activeColor: AppColors.swapHighlight,
              label: _satisfactionScore.toStringAsFixed(1),
              onChanged: (double v) {
                setState(() => _satisfactionScore = v);
              },
            ),
            TextFormField(
              controller: _recommendationTag,
              style: AppTextStyles.body,
              decoration: _field(
                '추천 태그',
                hint: "microwave only! / 친구들에게 추천!",
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cookNote,
              style: AppTextStyles.body,
              maxLines: 3,
              decoration: _field('실전 메모 (선택)', hint: '간장을 반 스푼 줄일 것'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '저장하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientDraft {
  final TextEditingController name = TextEditingController();
  final TextEditingController amount = TextEditingController(text: '1');
  final TextEditingController unit = TextEditingController(text: 'g');
  final TextEditingController substitutions = TextEditingController();
  final TextEditingController storeTip = TextEditingController();

  void dispose() {
    name.dispose();
    amount.dispose();
    unit.dispose();
    substitutions.dispose();
    storeTip.dispose();
  }
}

class _StepDraft {
  final TextEditingController instruction = TextEditingController();
  final TextEditingController timerMinutes = TextEditingController();

  void dispose() {
    instruction.dispose();
    timerMinutes.dispose();
  }
}

class _IngredientCard extends StatelessWidget {
  const _IngredientCard({
    required this.index,
    required this.draft,
    required this.decoration,
    required this.canRemove,
    required this.onRemove,
  });

  final int index;
  final _IngredientDraft draft;
  final InputDecoration Function(String label, {String? hint}) decoration;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('재료 ${index + 1}', style: AppTextStyles.bodySmall),
              const Spacer(),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onRemove,
                ),
            ],
          ),
          TextFormField(
            controller: draft.name,
            style: AppTextStyles.body,
            decoration: decoration('재료명'),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: draft.amount,
                  style: AppTextStyles.body,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: decoration('양'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: draft.unit,
                  style: AppTextStyles.body,
                  decoration: decoration('단위', hint: 'g / ml / tbsp'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: draft.substitutions,
            style: AppTextStyles.body,
            decoration: decoration(
              '현지 대체재 (쉼표로 구분, 선택)',
              hint: 'Cayenne, Paprika',
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: draft.storeTip,
            style: AppTextStyles.body,
            decoration: decoration(
              '마트 코너 팁 (선택)',
              hint: "Trader Joe's Spice aisle",
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.stepNumber,
    required this.draft,
    required this.decoration,
    required this.canRemove,
    required this.onRemove,
  });

  final int stepNumber;
  final _StepDraft draft;
  final InputDecoration Function(String label, {String? hint}) decoration;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceMuted),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Step $stepNumber', style: AppTextStyles.bodySmall),
              const Spacer(),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onRemove,
                ),
            ],
          ),
          TextFormField(
            controller: draft.instruction,
            style: AppTextStyles.body,
            maxLines: 3,
            decoration: decoration('조리 지침'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: draft.timerMinutes,
            style: AppTextStyles.body,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: decoration('타이머 (분, 선택)'),
          ),
        ],
      ),
    );
  }
}
