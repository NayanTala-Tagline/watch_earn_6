import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/milestone_module/provider/milestone_provider.dart';
import 'package:daily_cash/features/milestone_module/widgets/milestone_card.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MilestoneScreen extends StatefulWidget {
  const MilestoneScreen({super.key});

  @override
  State<MilestoneScreen> createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'achievement_screen');
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        RoutingHelper().handleBackPress(context);
      },
      child: ChangeNotifierProvider(
        create: (context) => MilestoneProvider(),
        child: Scaffold(
          backgroundColor: themeColors.backgroundColor,
          appBar: SharedAppBar(title: context.l10n.achievements),
          body: Consumer<MilestoneProvider>(
            builder: (context, provider, _) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: AppDimens.w20, vertical: AppDimens.h10),
                        itemCount: provider.achievements.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MilestoneCard(achievement: provider.achievements[index]);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(AppDimens.w20, AppDimens.h10, AppDimens.w20, AppDimens.h20),
                        child: GradientActionButton(
                          text: context.l10n.checkAnswer,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
