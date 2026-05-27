import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../side_menu.dart';
import 'widgets/daily_login_card.dart';
// import 'widgets/daily_quests_section.dart';
import 'widgets/earn_prizes_section.dart';
import 'widgets/dashboard_balance_section.dart';
import 'widgets/dashboard_bottom_actions.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_stats_row.dart';
import 'widgets/guideline_card.dart';
import 'widgets/top_earner_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardProvider(),
      child: Scaffold(
        drawer: const SideMenu(),
        body: StreamBuilder(
          stream: Injector.instance<AppDB>().userListenable(),
          builder: (context, _) {
            final user = Injector.instance<AppDB>().userModel;
            return Padding(
              padding: EdgeInsets.all(AppDimens.appPadding),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppDimens.h20,
                  children: [
                    DashboardHeader(user: user),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: AppDimens.h20,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: GlowBox(
                                highlight: context.themeColors.primaryGradient2,
                                child: const DailyLoginCard(),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: GlowBox(
                                highlight: context.themeColors.primaryGradient1,
                                child: DashboardBalanceSection(
                                  showMinWithdrawalTxt: false,
                                  leftBtnLabel: context.l10n.withdraw,
                                  leftOnTap: () {
                                    context.goNamed(AppRoutes.wallet);
                                  },
                                  rightBtnLabel: context.l10n.history,
                                  rightOnTap: () {
                                    context.pushNamed(AppRoutes.walletHistory);
                                  },
                                  leftBtnVisible: true,
                                  rightBtnVisible: true,
                                ),
                              ),
                            ),

                            DashboardStatsRow(user: user),

                            const EarnPrizesSection(),

                            const TopEarnerSection(),

                            // const DailyQuestsSection(),
                            const DashboardBottomActions(),

                            const GuidelineCard(),
                          ],
                        ),
                      ),
                    ),

                    // Daily Check-in Card
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
