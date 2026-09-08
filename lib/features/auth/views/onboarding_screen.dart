import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../recipe/views/recipe_feed_screen.dart';
import '../providers/user_provider.dart';

/// Onboarding / profile preferences: nickname, units, cuisines.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.fromSettings = false});

  /// When true, Save pops back to the feed instead of replacing the stack.
  final bool fromSettings;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<String> _cuisineOptions = <String>[
    'Korean',
    'Fusion',
    'Western',
    'Quick Meal',
    'Japanese',
    'Chinese',
    'Vegan',
    'Vegetarian',
  ];

  late final TextEditingController _nickname;
  late bool _preferImperial;
  late Set<String> _selectedCuisines;
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _nickname = TextEditingController();
    _preferImperial = false;
    _selectedCuisines = <String>{'Korean'};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefsLoaded) {
      return;
    }
    _prefsLoaded = true;
    final user = context.read<UserProvider>().currentUser;
    _nickname.text = user.displayName;
    _preferImperial = user.preferImperial;
    _selectedCuisines = user.preferredCuisines.toSet();
    if (_selectedCuisines.isEmpty) {
      _selectedCuisines.add('Korean');
    }
  }

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nickname.text.trim();
    context.read<UserProvider>().updatePreferences(
          displayName: name.isEmpty ? '나' : name,
          preferImperial: _preferImperial,
          preferredCuisines: _selectedCuisines.toList(),
        );

    if (widget.fromSettings) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const RecipeFeedScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text(widget.fromSettings ? 'Profile settings' : 'Welcome to JUBU'),
        automaticallyImplyLeading: widget.fromSettings,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: <Widget>[
          Text('Nickname', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          TextField(
            controller: _nickname,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Your display name',
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Measurement units', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          Text(
            'Recipes will convert ingredients to your preferred units.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _UnitCard(
                  selected: !_preferImperial,
                  title: 'Metric',
                  subtitle: 'g, ml\n(Korea / global)',
                  onTap: () => setState(() => _preferImperial = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _UnitCard(
                  selected: _preferImperial,
                  title: 'Imperial',
                  subtitle: 'oz, cup\n(US local)',
                  onTap: () => setState(() => _preferImperial = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Preferred cuisines', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cuisineOptions.map((String cuisine) {
              final selected = _selectedCuisines.contains(cuisine);
              return FilterChip(
                label: Text(cuisine),
                selected: selected,
                selectedColor: AppColors.secondaryLight,
                checkmarkColor: AppColors.secondary,
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      _selectedCuisines.add(cuisine);
                    } else {
                      _selectedCuisines.remove(cuisine);
                      if (_selectedCuisines.isEmpty) {
                        _selectedCuisines.add('Korean');
                      }
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
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
              child: Text(
                widget.fromSettings ? 'Save' : 'Start JUBU',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.secondaryLight : AppColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.secondary : AppColors.surfaceMuted,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: AppTextStyles.subtitle.copyWith(
                  color: selected ? AppColors.secondary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
