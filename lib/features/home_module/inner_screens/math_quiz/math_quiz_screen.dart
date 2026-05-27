import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/home_module/inner_screens/math_quiz/provider/math_quiz_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:daily_cash/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MathQuizScreen extends StatelessWidget {
  const MathQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => MathQuizProvider(), child: const _MathQuizContent());
  }
}

class _MathQuizContent extends StatefulWidget {
  const _MathQuizContent();

  @override
  State<_MathQuizContent> createState() => _MathQuizContentState();
}

class _MathQuizContentState extends State<_MathQuizContent> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'math_quiz_screen');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MathQuizProvider>();
    final themeColors = context.themeColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        NavigationHelper().handleBackPress(context);
      },
      child: Scaffold(
        backgroundColor: themeColors.backgroundColor,
        appBar: CommonAppBar(title: 'Math Quiz', actions: [_buildCoinBadge(context)]),
        body: SafeArea(
          child: provider.sessionComplete
              ? _buildSessionSummary(context, provider)
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.w20),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress indicator
                              _buildProgress(context, provider),
                              SizedBox(height: AppSize.h24),

                              // Quiz card
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: themeColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(AppSize.r20 + 1.5),
                                    ),
                                    padding: const EdgeInsets.all(1.5),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(AppSize.w20, AppSize.h50, AppSize.w20, AppSize.w20),
                                      decoration: BoxDecoration(
                                        color: themeColors.surfaceColor,
                                        borderRadius: BorderRadius.circular(AppSize.r20),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildEquationBox(context, provider),
                                          SizedBox(height: AppSize.h24),
                                          _buildOptionsGrid(context, provider),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(top: -AppSize.h35, child: _buildBrainBadge(context)),
                                ],
                              ),

                              SizedBox(height: AppSize.h50),

                              GradientButton(
                                text: 'Check Answer',
                                onPressed: provider.selectedIndex == null || provider.isAnswerChecked
                                    ? () {
                                        'Please select an option'.showInfoAlert();
                                      }
                                    : () {
                                        final isCorrect = provider.checkAnswer();
                                        AnalyticsManager.instance.logEvent(
                                          name: 'quiz_answer_checked',
                                          parameters: {'is_correct': isCorrect},
                                        );
                                        _showResultDialog(context, isCorrect, provider);
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSize.h20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildProgress(BuildContext context, MathQuizProvider provider) {
    return Row(
      children: [
        Text(
          'Question ${provider.questionDisplay} / ${MathQuizProvider.totalQuestions}',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.themeTextColors.descriptionColor,
            fontSize: AppSize.sp14,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Assets.icons.coins.svg(width: AppSize.w16, height: AppSize.h16),
            SizedBox(width: AppSize.w4),
            Text(
              '+${provider.sessionCoins}',
              strutStyle: StrutStyle(fontSize: AppSize.sp14, height: 1.1, forceStrutHeight: true),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.themeTextColors.greenTextColor,
                fontSize: AppSize.sp14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionSummary(BuildContext context, MathQuizProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.w24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.coins.svg(width: AppSize.w80, height: AppSize.h80),
            SizedBox(height: AppSize.h24),
            Text(
              'Quiz Complete!',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppSize.sp24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSize.h12),
            Text(
              'You earned ${provider.sessionCoins} coins',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.themeTextColors.greenTextColor,
                fontSize: AppSize.sp18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSize.h8),
            // Live coin balance
            StreamBuilder(
              stream: Injector.instance<AppDB>().userListenable(),
              builder: (context, _) {
                final coins = Injector.instance<AppDB>().userModel?.coin.toInt() ?? 0;
                return Text(
                  'Total balance: $coins coins',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontSize: AppSize.sp14,
                  ),
                );
              },
            ),
            SizedBox(height: AppSize.h40),
            GradientButton(
              text: 'Play Again',
              onPressed: () {
                AnalyticsManager.instance.logEvent(name: 'quiz_reset');
                provider.resetSession();
              },
            ),
            SizedBox(height: AppSize.h16),
            TextButton(
              onPressed: () => NavigationHelper().handleBackPress(context),
              child: Text(
                'Back to Home',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.themeTextColors.descriptionColor,
                  fontSize: AppSize.sp16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinBadge(BuildContext context) {
    return StreamBuilder(
      stream: Injector.instance<AppDB>().userListenable(),
      builder: (context, _) {
        final coins = Injector.instance<AppDB>().userModel?.coin.toInt() ?? 0;
        return Container(
          margin: EdgeInsets.only(right: AppSize.w10),
          padding: EdgeInsets.symmetric(horizontal: AppSize.w12, vertical: AppSize.h6),
          decoration: BoxDecoration(
            color: context.themeColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppSize.r12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.coins.svg(height: AppSize.h20, width: AppSize.w20),
              SizedBox(width: AppSize.w6),
              Text(
                '$coins',
                strutStyle: StrutStyle(fontSize: AppSize.sp20, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppSize.sp20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBrainBadge(BuildContext context) {
    return Container(
      height: AppSize.h70,
      width: AppSize.h70,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B3D),
        borderRadius: BorderRadius.circular(AppSize.r20),
        border: Border.all(color: Colors.white12),
      ),
      padding: EdgeInsets.all(AppSize.h16),
      child: Center(
        child: Assets.icons.quizMaster.svg(width: AppSize.w40, height: AppSize.h40),
      ),
    );
  }

  Widget _buildEquationBox(BuildContext context, MathQuizProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSize.h24),
      decoration: BoxDecoration(
        gradient: context.themeColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSize.r14),
      ),
      alignment: Alignment.center,
      child: Text(
        provider.equation,
        style: context.textTheme.headlineMedium?.copyWith(
          color: context.themeTextColors.textColor,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context, MathQuizProvider provider) {
    return Wrap(
      spacing: AppSize.w12,
      runSpacing: AppSize.h12,
      alignment: WrapAlignment.center,
      children: List.generate(provider.options.length, (index) {
        final isSelected = provider.selectedIndex == index;
        return GestureDetector(
          onTap: () => provider.selectOption(index),
          child: Container(
            width: AppSize.w60,
            height: AppSize.h60,
            decoration: BoxDecoration(
              gradient: isSelected ? context.themeColors.primaryGradient : null,
              color: isSelected ? null : context.themeColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSize.r12 + 1),
            ),
            padding: EdgeInsets.all(AppSize.w1),
            child: Container(
              decoration: BoxDecoration(
                color: context.themeColors.surfaceColor,
                borderRadius: BorderRadius.circular(AppSize.r12),
              ),
              alignment: Alignment.center,
              child: Text(
                provider.options[index].toString(),
                strutStyle: StrutStyle(fontSize: AppSize.sp20, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppSize.sp20,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showResultDialog(BuildContext context, bool isCorrect, MathQuizProvider provider) {
    final isLast = provider.questionDisplay == MathQuizProvider.totalQuestions;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.themeColors.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isCorrect ? 'Correct! +${RemoteConfigService.instance.quizPerQuestionReward} coins' : 'Wrong Answer',
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: AppSize.sp18,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isCorrect ? 'Great job! Keep going.' : 'The answer was ${provider.correctAnswer}.',
              style: context.textTheme.bodyLarge?.copyWith(fontSize: AppSize.sp16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            // if (isLast)
            //   AdDisclaimerText(show: RewardAdService.isMathQuizAdEnabled),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              if (isLast) {
                final earnedCoins = await RewardAdService.showMathQuiz(
                  context,
                  defaultCoins: provider.sessionCoins,
                );
                if (earnedCoins == null) {
                  // User cancelled the ad — re-show the result dialog
                  // so they can try again without losing their answer state
                  if (context.mounted) {
                    _showResultDialog(context, isCorrect, provider);
                  }
                  return;
                }
                AnalyticsManager.instance.logEvent(
                  name: 'quiz_session_complete',
                  parameters: {'coins_earned': earnedCoins},
                );
                provider.advanceQuestion(earnedCoins: earnedCoins);
              } else {
                provider.advanceQuestion();
              }
            },
            child: Text(
              isLast ? 'See Results' : 'Next Question',
              strutStyle: StrutStyle(fontSize: AppSize.sp16, height: 1.1, forceStrutHeight: true),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppSize.sp16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
