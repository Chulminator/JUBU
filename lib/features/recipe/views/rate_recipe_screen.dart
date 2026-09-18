import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/recipe_model.dart';
import '../services/mock_recipe_service.dart';

/// Star rating + optional short comment (~20 words) after cooking.
///
/// Defaults to 0 stars. Submit with 0 + empty comment keeps the recipe in
/// the awaiting-rating queue instead of saving a rating.
class RateRecipeScreen extends StatefulWidget {
  const RateRecipeScreen({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<RateRecipeScreen> createState() => _RateRecipeScreenState();
}

class _RateRecipeScreenState extends State<RateRecipeScreen> {
  double _score = 0;
  final TextEditingController _comment = TextEditingController();

  static const int maxWords = 20;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  int get _wordCount {
    final String t = _comment.text.trim();
    if (t.isEmpty) {
      return 0;
    }
    return t.split(RegExp(r'\s+')).where((String w) => w.isNotEmpty).length;
  }

  void _submit() {
    if (_wordCount > maxWords) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment max is 20 words.')),
      );
      return;
    }

    final String comment = _comment.text.trim();
    // Skip rating: stay in awaiting queue.
    if (_score <= 0 && comment.isEmpty) {
      MockRecipeService.addPendingRating(widget.recipe.id);
      Navigator.of(context).pop(false);
      return;
    }

    MockRecipeService.submitPendingRating(
      widget.recipe.id,
      _score,
      comment: comment,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Rate this cook'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: <Widget>[
          Text(widget.recipe.title, style: AppTextStyles.title),
          const SizedBox(height: 6),
          Text(
            'How did this cook go?',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Leave 0 stars and no comment to rate later in Settings.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(5, (int i) {
              final bool filled = _score >= i + 1;
              final bool half = !filled && _score >= i + 0.5;
              return IconButton(
                onPressed: () {
                  final double tapped = (i + 1).toDouble();
                  setState(() {
                    // Tap the current filled star again to clear to 0.
                    _score = (_score == tapped) ? 0 : tapped;
                  });
                },
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
            _score.toStringAsFixed(1),
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle,
          ),
          Slider(
            value: _score,
            min: 0,
            max: 5,
            divisions: 10,
            activeColor: AppColors.swapHighlight,
            onChanged: (double v) => setState(() => _score = v),
          ),
          const SizedBox(height: 12),
          Text(
            'Comment (optional, max $maxWords words)',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comment,
            maxLines: 4,
            style: AppTextStyles.body,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'A short note about this cook…',
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              counterText: '$_wordCount / $maxWords words',
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
