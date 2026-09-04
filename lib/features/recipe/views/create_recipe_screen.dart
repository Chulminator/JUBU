import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _cookTime = TextEditingController();
  final TextEditingController _recommendationTags =
      TextEditingController(text: 'microwave only!');
  final TextEditingController _cookNote = TextEditingController();

  String? _coverImagePath;
  double _satisfactionScore = 5.0;
  bool _showCookDiary = false;

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
    _recommendationTags.dispose();
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

  Future<void> _pickCoverImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _coverImagePath = file.path);
    }
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
          storeTip: row.storeTipExpanded && row.storeTip.text.trim().isNotEmpty
              ? row.storeTip.text.trim()
              : null,
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
          imagePath: row.imagePath,
        ),
      );
      stepNumber += 1;
    }

    if (ingredients.isEmpty || steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one ingredient and one step.'),
        ),
      );
      return;
    }

    final note = _cookNote.text.trim();
    final tags = _recommendationTags.text
        .split(',')
        .map((String s) => s.trim())
        .where((String s) => s.isNotEmpty)
        .toList();

    final recipe = RecipeModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim(),
      description: _description.text.trim(),
      authorId: MockRecipeService.currentUserId,
      authorName: 'Me',
      imageUrl: _coverImagePath ?? _fallbackImage,
      category: _category.text.trim().isEmpty ? 'Korean' : _category.text.trim(),
      cookingTimeMinutes: int.tryParse(_cookTime.text.trim()) ?? 0,
      ingredients: ingredients,
      steps: steps,
      satisfactionScore: _satisfactionScore,
      recommendationTags:
          tags.isEmpty ? const <String>['microwave only!'] : tags,
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
        title: const Text('New recipe / cook log'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: <Widget>[
            Text('Basics', style: AppTextStyles.subtitle),
            const SizedBox(height: 10),
            TextFormField(
              controller: _title,
              style: AppTextStyles.body,
              decoration: _field('Title'),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _description,
              style: AppTextStyles.body,
              maxLines: 3,
              decoration: _field('Description'),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a description' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _category,
              style: AppTextStyles.body,
              decoration: _field(
                'Category',
                hint: 'e.g. Korean, Vegan, Quick Meal',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cookTime,
              style: AppTextStyles.body,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: _field('Cook time (minutes)'),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter cook time' : null,
            ),
            const SizedBox(height: 12),
            Text('Cover photo', style: AppTextStyles.bodySmall),
            const SizedBox(height: 6),
            InkWell(
              onTap: _pickCoverImage,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceMuted),
                ),
                clipBehavior: Clip.antiAlias,
                child: _coverImagePath == null
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.photo_library_outlined,
                                color: AppColors.textSecondary),
                            SizedBox(height: 6),
                            Text('Pick from gallery',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      )
                    : Image.file(
                        File(_coverImagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text('Ingredients', style: AppTextStyles.subtitle),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _ingredients.add(_IngredientDraft()));
                  },
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: Text(
                    'Add ingredient',
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
                onChanged: () => setState(() {}),
                onRemove: () {
                  setState(() {
                    _ingredients[i].dispose();
                    _ingredients.removeAt(i);
                  });
                },
              );
            }),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text('Steps', style: AppTextStyles.subtitle),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _steps.add(_StepDraft()));
                  },
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: Text(
                    'Add step',
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
                picker: _picker,
                onChanged: () => setState(() {}),
                onRemove: () {
                  setState(() {
                    _steps[i].dispose();
                    _steps.removeAt(i);
                  });
                },
              );
            }),
            const SizedBox(height: 8),
            ExpansionTile(
              initiallyExpanded: _showCookDiary,
              onExpansionChanged: (bool open) {
                setState(() => _showCookDiary = open);
              },
              tilePadding: EdgeInsets.zero,
              title: Text(
                'Cook diary (optional)',
                style: AppTextStyles.subtitle,
              ),
              children: <Widget>[
                Text(
                  'Satisfaction ${_satisfactionScore.toStringAsFixed(1)} / 5.0',
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
                  controller: _recommendationTags,
                  style: AppTextStyles.body,
                  decoration: _field(
                    'Tags (comma-separated, multiple OK)',
                    hint: 'microwave only!, Must try!, Quick',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cookNote,
                  style: AppTextStyles.body,
                  maxLines: 3,
                  decoration: _field(
                    'Cook note (optional)',
                    hint: 'Use half a spoon less soy next time',
                  ),
                ),
                const SizedBox(height: 8),
              ],
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
                  'Save',
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
  final TextEditingController storeTip = TextEditingController();
  bool storeTipExpanded = false;

  void dispose() {
    name.dispose();
    amount.dispose();
    unit.dispose();
    storeTip.dispose();
  }
}

class _StepDraft {
  final TextEditingController instruction = TextEditingController();
  final TextEditingController timerMinutes = TextEditingController();
  String? imagePath;
  bool extrasExpanded = false;

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
    required this.onChanged,
  });

  final int index;
  final _IngredientDraft draft;
  final InputDecoration Function(String label, {String? hint}) decoration;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

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
              Text('Ingredient ${index + 1}', style: AppTextStyles.bodySmall),
              const Spacer(),
              if (canRemove)
                IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onRemove,
                ),
            ],
          ),
          TextFormField(
            controller: draft.name,
            style: AppTextStyles.body,
            decoration: decoration('Name'),
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
                  decoration: decoration('Amount'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: draft.unit,
                  style: AppTextStyles.body,
                  decoration: decoration('Unit', hint: 'g / ml / tbsp'),
                ),
              ),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: draft.storeTipExpanded,
            onExpansionChanged: (bool open) {
              draft.storeTipExpanded = open;
              onChanged();
            },
            tilePadding: EdgeInsets.zero,
            title: Text('Store tip (optional)', style: AppTextStyles.bodySmall),
            children: <Widget>[
              TextFormField(
                controller: draft.storeTip,
                style: AppTextStyles.body,
                decoration: decoration(
                  'Aisle tip',
                  hint: "Trader Joe's Spice aisle",
                ),
              ),
            ],
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
    required this.onChanged,
    required this.picker,
  });

  final int stepNumber;
  final _StepDraft draft;
  final InputDecoration Function(String label, {String? hint}) decoration;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final ImagePicker picker;

  Future<void> _pickPhoto() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      draft.imagePath = file.path;
      onChanged();
    }
  }

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
                  icon:
                      const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onRemove,
                ),
            ],
          ),
          TextFormField(
            controller: draft.instruction,
            style: AppTextStyles.body,
            maxLines: 3,
            decoration: decoration('Instruction'),
          ),
          ExpansionTile(
            initiallyExpanded: draft.extrasExpanded,
            onExpansionChanged: (bool open) {
              draft.extrasExpanded = open;
              onChanged();
            },
            tilePadding: EdgeInsets.zero,
            title: Text(
              'Timer & photo (optional)',
              style: AppTextStyles.bodySmall,
            ),
            children: <Widget>[
              TextFormField(
                controller: draft.timerMinutes,
                style: AppTextStyles.body,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: decoration('Timer (minutes)'),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _pickPhoto,
                  icon: const Icon(Icons.photo_outlined),
                  label: Text(
                    draft.imagePath == null
                        ? 'Add step photo'
                        : 'Change step photo',
                  ),
                ),
              ),
              if (draft.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(draft.imagePath!),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
