import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';

import 'model/guideline_rule.dart';
import 'widgets/guide_card.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'how_it_works_screen');
  }

  @override
  Widget build(BuildContext context) {
    const rules = [
      GuidelineRule(
        title: 'What are Coins?',
        desc:
            'Coins are the main currency in this app. You can earn coins by completing tasks and exchange them for real money.',
      ),
      GuidelineRule(
        title: 'Daily Missions',
        desc:
            'Complete daily tasks like spinning the wheel, scratching cards, or answering quizzes. Each completed mission rewards you with coins.',
      ),
      GuidelineRule(
        title: 'Spin Wheel',
        desc:
            'Spin the lucky wheel to win instant coin rewards! Each spin can reward you with 10-500 coins.',
      ),
      GuidelineRule(
        title: 'Scratch Cards',
        desc:
            'Scratch virtual cards to reveal hidden coin rewards from 5 to 50 coins. Free cards daily!',
      ),
      GuidelineRule(
        title: 'Quiz Game',
        desc:
            'Answer trivia questions correctly to earn 22 coins per question. Build your combo streak.',
      ),
      GuidelineRule(
        title: 'Watch Ads',
        desc:
            'Watch short video ads to earn quick coins. Each ad rewards you instantly. Up to 10 ads per day.',
      ),
      GuidelineRule(
        title: 'Referral System',
        desc:
            'Share your referral code with friends. When they sign up, you both get 500 bonus coins!',
      ),
      GuidelineRule(
        title: 'Withdraw Money',
        desc:
            'Once you reach the minimum threshold, go to Wallet to request withdrawal via various payment methods.',
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        RoutingHelper().handleBackPress(context);
      },
      child: Scaffold(
        backgroundColor: context.themeColors.backgroundColor,
        appBar: SharedAppBar(title: context.l10n.howItWorks),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
            child: Column(
              spacing: AppDimens.h15,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: rules.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppDimens.h15),
                    itemBuilder: (context, index) {
                      return GuideCard(
                        index: index + 1,
                        title: rules[index].title,
                        description: rules[index].desc,
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.r12),
                    gradient: LinearGradient(
                      colors: [
                        context.themeColors.secondaryGradient4.withValues(
                          alpha: 0.2,
                        ),
                        context.themeColors.secondaryGradient2,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(1.2),
                  child: Container(
                    padding: EdgeInsets.all(AppDimens.w16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(AppDimens.r12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.readyToStartEarning,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimens.sp16,
                          ),
                        ),
                        SizedBox(height: AppDimens.h16),
                        GradientActionButton(
                          text: context.l10n.backToHome,
                          textStyle: context.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: AppDimens.sp16,
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7E52FF), Color(0xFF3884FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          onPressed: () =>
                              RoutingHelper().handleBackPress(context),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppDimens.h10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
