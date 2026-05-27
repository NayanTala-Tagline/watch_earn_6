import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/provider/home_provider.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_drawer.dart';
import 'widgets/daily_checkin_card.dart';
// import 'widgets/daily_missions_section.dart';
import 'widgets/earn_rewards_section.dart';
import 'widgets/home_balance_section.dart';
import 'widgets/home_bottom_actions.dart';
import 'widgets/home_header.dart';
import 'widgets/home_stats_row.dart';
import 'widgets/how_it_works_card.dart';
import 'widgets/top_earning_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Scaffold(
        drawer: const AppDrawer(),
        body: StreamBuilder(
          stream: Injector.instance<AppDB>().userListenable(),
          builder: (context, _) {
            final user = Injector.instance<AppDB>().userModel;
            return Padding(
              padding: EdgeInsets.all(AppSize.appPadding),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSize.h20,
                  children: [
                    HomeHeader(user: user),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: AppSize.h20,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: GlowContainer(
                                accent: context.themeColors.primaryGradient2,
                                child: const DailyCheckinCard(),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: GlowContainer(
                                accent: context.themeColors.primaryGradient1,
                                child: HomeBalanceSection(
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

                            HomeStatsRow(user: user),

                            const EarnRewardsSection(),

                            const TopEarningSection(),

                            // const DailyMissionsSection(),
                            const HomeBottomActions(),

                            const HowItWorksCard(),
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
