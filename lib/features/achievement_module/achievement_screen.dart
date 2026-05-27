import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/achievement_module/provider/achievement_provider.dart';
import 'package:daily_cash/features/achievement_module/widgets/achievement_card.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:daily_cash/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
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
        NavigationHelper().handleBackPress(context);
      },
      child: ChangeNotifierProvider(
        create: (context) => AchievementProvider(),
        child: Scaffold(
          backgroundColor: themeColors.backgroundColor,
          appBar: CommonAppBar(title: context.l10n.achievements),
          body: Consumer<AchievementProvider>(
            builder: (context, provider, _) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.w20, vertical: AppSize.h10),
                        itemCount: provider.achievements.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AchievementCard(achievement: provider.achievements[index]);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(AppSize.w20, AppSize.h10, AppSize.w20, AppSize.h20),
                        child: GradientButton(
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
