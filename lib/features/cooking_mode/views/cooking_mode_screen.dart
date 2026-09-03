import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../recipe/models/recipe_model.dart';

/// Hands-free cooking mode: large type, swipeable steps, per-step timer.
class CookingModeScreen extends StatefulWidget {
  const CookingModeScreen({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _timerRunning = false;
  int? _timerStepIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _syncTimerForStep(0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<RecipeStep> get _steps => widget.recipe.steps;

  void _syncTimerForStep(int index) {
    _timer?.cancel();
    _timerRunning = false;
    _timerStepIndex = index;
    final minutes = _steps[index].timerMinutes;
    _remainingSeconds = (minutes ?? 0) * 60;
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _syncTimerForStep(index);
    });
  }

  void _goToPage(int index) {
    if (index < 0 || index >= _steps.length) {
      return;
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _toggleTimer() {
    final minutes = _steps[_currentIndex].timerMinutes;
    if (minutes == null) {
      return;
    }

    if (_timerRunning) {
      _timer?.cancel();
      setState(() => _timerRunning = false);
      return;
    }

    if (_remainingSeconds <= 0) {
      _remainingSeconds = minutes * 60;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (_remainingSeconds <= 1) {
        t.cancel();
        setState(() {
          _remainingSeconds = 0;
          _timerRunning = false;
        });
        return;
      }
      setState(() => _remainingSeconds -= 1);
    });
    setState(() => _timerRunning = true);
  }

  void _resetTimer() {
    final minutes = _steps[_currentIndex].timerMinutes;
    if (minutes == null) {
      return;
    }
    _timer?.cancel();
    setState(() {
      _timerRunning = false;
      _remainingSeconds = minutes * 60;
      _timerStepIndex = _currentIndex;
    });
  }

  Future<void> _onComplete() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('요리 완료!'),
          content: Text(
            '${widget.recipe.title}\n수고하셨습니다. 맛있게 드세요!',
            style: AppTextStyles.body,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _formatCountdown(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final total = _steps.length;
    final isLast = _currentIndex >= total - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.recipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.onPrimary,
                fontSize: 16,
              ),
            ),
            Text(
              'Step ${_currentIndex + 1} / $total',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: '닫기',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: total,
              onPageChanged: _onPageChanged,
              itemBuilder: (BuildContext context, int index) {
                final pageStep = _steps[index];
                final showTimer = pageStep.timerMinutes != null;
                final seconds = (index == _timerStepIndex)
                    ? _remainingSeconds
                    : (pageStep.timerMinutes ?? 0) * 60;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Step ${pageStep.stepNumber}',
                          style: AppTextStyles.subtitle.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              pageStep.instruction,
                              style: AppTextStyles.cookingMode,
                            ),
                          ),
                        ),
                        if (showTimer) ...<Widget>[
                          const SizedBox(height: 16),
                          Text(
                            _formatCountdown(seconds),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.cookingMode.copyWith(
                              fontSize: 48,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (index == _currentIndex)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ElevatedButton.icon(
                                  onPressed: showTimer ? _toggleTimer : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  icon: Icon(
                                    _timerRunning
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  label: Text(
                                    _timerRunning ? '일시정지' : '시작',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: showTimer ? _resetTimer : null,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('리셋'),
                                ),
                              ],
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _currentIndex == 0
                          ? null
                          : () => _goToPage(_currentIndex - 1),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('이전 단계'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLast
                          ? _onComplete
                          : () => _goToPage(_currentIndex + 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(isLast ? '요리 완료' : '다음 단계'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
