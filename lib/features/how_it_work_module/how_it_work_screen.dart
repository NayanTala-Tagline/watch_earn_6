import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:daily_cash/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

import 'model/how_it_work_rule.dart';
import 'widgets/how_it_work_card.dart';

class HowItWorkScreen extends StatefulWidget {
  const HowItWorkScreen({super.key});

  @override
  State<HowItWorkScreen> createState() => _HowItWorkScreenState();
}

class _HowItWorkScreenState extends State<HowItWorkScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'how_it_works_screen');
  }

  @override
  Widget build(BuildContext context) {
    const rules = [
      HowItWorksRule(
        title: 'What are Coins?',
        desc:
            'Coins are the main currency in this app. You can earn coins by completing tasks and exchange them for real money.',
      ),
      HowItWorksRule(
        title: 'Daily Missions',
        desc:
            'Complete daily tasks like spinning the wheel, scratching cards, or answering quizzes. Each completed mission rewards you with coins.',
      ),
      HowItWorksRule(
        title: 'Spin Wheel',
        desc:
            'Spin the lucky wheel to win instant coin rewards! Each spin can reward you with 10-500 coins.',
      ),
      HowItWorksRule(
        title: 'Scratch Cards',
        desc:
            'Scratch virtual cards to reveal hidden coin rewards from 5 to 50 coins. Free cards daily!',
      ),
      HowItWorksRule(
        title: 'Quiz Game',
        desc:
            'Answer trivia questions correctly to earn 22 coins per question. Build your combo streak.',
      ),
      HowItWorksRule(
        title: 'Watch Ads',
        desc:
            'Watch short video ads to earn quick coins. Each ad rewards you instantly. Up to 10 ads per day.',
      ),
      HowItWorksRule(
        title: 'Referral System',
        desc:
            'Share your referral code with friends. When they sign up, you both get 500 bonus coins!',
      ),
      HowItWorksRule(
        title: 'Withdraw Money',
        desc:
            'Once you reach the minimum threshold, go to Wallet to request withdrawal via various payment methods.',
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        NavigationHelper().handleBackPress(context);
      },
      child: Scaffold(
        backgroundColor: context.themeColors.backgroundColor,
        appBar: CommonAppBar(title: context.l10n.howItWorks),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.w20),
            child: Column(
              spacing: AppSize.h15,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: rules.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSize.h15),
                    itemBuilder: (context, index) {
                      return HowItWorkCard(
                        index: index + 1,
                        title: rules[index].title,
                        description: rules[index].desc,
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.r12),
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
                    padding: EdgeInsets.all(AppSize.w16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(AppSize.r12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.readyToStartEarning,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.sp16,
                          ),
                        ),
                        SizedBox(height: AppSize.h16),
                        GradientButton(
                          text: context.l10n.backToHome,
                          textStyle: context.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: AppSize.sp16,
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7E52FF), Color(0xFF3884FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          onPressed: () =>
                              NavigationHelper().handleBackPress(context),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSize.h10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
