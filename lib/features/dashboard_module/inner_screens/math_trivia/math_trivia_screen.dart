import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/math_trivia/provider/math_trivia_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MathTriviaScreen extends StatelessWidget {
  const MathTriviaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => MathTriviaProvider(), child: const _MathTriviaContent());
  }
}

class _MathTriviaContent extends StatefulWidget {
  const _MathTriviaContent();

  @override
  State<_MathTriviaContent> createState() => _MathTriviaContentState();
}

class _MathTriviaContentState extends State<_MathTriviaContent> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'math_quiz_screen');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MathTriviaProvider>();
    final themeColors = context.themeColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        RoutingHelper().handleBackPress(context);
      },
      child: Scaffold(
        backgroundColor: themeColors.backgroundColor,
        appBar: SharedAppBar(title: 'Math Quiz', actions: [_buildCoinBadge(context)]),
        body: SafeArea(
          child: provider.sessionComplete
              ? _buildSessionSummary(context, provider)
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress indicator
                              _buildProgress(context, provider),
                              SizedBox(height: AppDimens.h24),

                              // Quiz card
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: themeColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(AppDimens.r20 + 1.5),
                                    ),
                                    padding: const EdgeInsets.all(1.5),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(AppDimens.w20, AppDimens.h50, AppDimens.w20, AppDimens.w20),
                                      decoration: BoxDecoration(
                                        color: themeColors.surfaceColor,
                                        borderRadius: BorderRadius.circular(AppDimens.r20),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildEquationBox(context, provider),
                                          SizedBox(height: AppDimens.h24),
                                          _buildOptionsGrid(context, provider),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(top: -AppDimens.h35, child: _buildBrainBadge(context)),
                                ],
                              ),

                              SizedBox(height: AppDimens.h50),

                              GradientActionButton(
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
                      SizedBox(height: AppDimens.h20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildProgress(BuildContext context, MathTriviaProvider provider) {
    return Row(
      children: [
        Text(
          'Question ${provider.questionDisplay} / ${MathTriviaProvider.totalQuestions}',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.themeTextColors.descriptionColor,
            fontSize: AppDimens.sp14,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Assets.icons.tokens.svg(width: AppDimens.w16, height: AppDimens.h16),
            SizedBox(width: AppDimens.w4),
            Text(
              '+${provider.sessionCoins}',
              strutStyle: StrutStyle(fontSize: AppDimens.sp14, height: 1.1, forceStrutHeight: true),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.themeTextColors.greenTextColor,
                fontSize: AppDimens.sp14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionSummary(BuildContext context, MathTriviaProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.w24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.tokens.svg(width: AppDimens.w80, height: AppDimens.h80),
            SizedBox(height: AppDimens.h24),
            Text(
              'Quiz Complete!',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppDimens.sp24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppDimens.h12),
            Text(
              'You earned ${provider.sessionCoins} coins',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.themeTextColors.greenTextColor,
                fontSize: AppDimens.sp18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppDimens.h8),
            // Live coin balance
            StreamBuilder(
              stream: Injector.instance<AppDB>().userListenable(),
              builder: (context, _) {
                final coins = Injector.instance<AppDB>().userModel?.coin.toInt() ?? 0;
                return Text(
                  'Total balance: $coins coins',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontSize: AppDimens.sp14,
                  ),
                );
              },
            ),
            SizedBox(height: AppDimens.h40),
            GradientActionButton(
              text: 'Play Again',
              onPressed: () {
                AnalyticsManager.instance.logEvent(name: 'quiz_reset');
                provider.resetSession();
              },
            ),
            SizedBox(height: AppDimens.h16),
            TextButton(
              onPressed: () => RoutingHelper().handleBackPress(context),
              child: Text(
                'Back to Home',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.themeTextColors.descriptionColor,
                  fontSize: AppDimens.sp16,
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
          margin: EdgeInsets.only(right: AppDimens.w10),
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w12, vertical: AppDimens.h6),
          decoration: BoxDecoration(
            color: context.themeColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppDimens.r12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.tokens.svg(height: AppDimens.h20, width: AppDimens.w20),
              SizedBox(width: AppDimens.w6),
              Text(
                '$coins',
                strutStyle: StrutStyle(fontSize: AppDimens.sp20, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.sp20,
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
      height: AppDimens.h70,
      width: AppDimens.h70,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B3D),
        borderRadius: BorderRadius.circular(AppDimens.r20),
        border: Border.all(color: Colors.white12),
      ),
      padding: EdgeInsets.all(AppDimens.h16),
      child: Center(
        child: Assets.icons.quizChampion.svg(width: AppDimens.w40, height: AppDimens.h40),
      ),
    );
  }

  Widget _buildEquationBox(BuildContext context, MathTriviaProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppDimens.h24),
      decoration: BoxDecoration(
        gradient: context.themeColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimens.r14),
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

  Widget _buildOptionsGrid(BuildContext context, MathTriviaProvider provider) {
    return Wrap(
      spacing: AppDimens.w12,
      runSpacing: AppDimens.h12,
      alignment: WrapAlignment.center,
      children: List.generate(provider.options.length, (index) {
        final isSelected = provider.selectedIndex == index;
        return GestureDetector(
          onTap: () => provider.selectOption(index),
          child: Container(
            width: AppDimens.w60,
            height: AppDimens.h60,
            decoration: BoxDecoration(
              gradient: isSelected ? context.themeColors.primaryGradient : null,
              color: isSelected ? null : context.themeColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimens.r12 + 1),
            ),
            padding: EdgeInsets.all(AppDimens.w1),
            child: Container(
              decoration: BoxDecoration(
                color: context.themeColors.surfaceColor,
                borderRadius: BorderRadius.circular(AppDimens.r12),
              ),
              alignment: Alignment.center,
              child: Text(
                provider.options[index].toString(),
                strutStyle: StrutStyle(fontSize: AppDimens.sp20, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.sp20,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showResultDialog(BuildContext context, bool isCorrect, MathTriviaProvider provider) {
    final isLast = provider.questionDisplay == MathTriviaProvider.totalQuestions;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.themeColors.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isCorrect ? 'Correct! +${RemoteSettingsService.instance.quizPerQuestionReward} coins' : 'Wrong Answer',
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: AppDimens.sp18,
            color: isCorrect ? Colors.green : Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isCorrect ? 'Great job! Keep going.' : 'The answer was ${provider.correctAnswer}.',
              style: context.textTheme.bodyLarge?.copyWith(fontSize: AppDimens.sp16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            // if (isLast)
            //   AdNoticeText(show: RewardAdService.isMathQuizAdEnabled),
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
              strutStyle: StrutStyle(fontSize: AppDimens.sp16, height: 1.1, forceStrutHeight: true),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppDimens.sp16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
