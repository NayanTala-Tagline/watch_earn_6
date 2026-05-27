import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/widgets/dashboard_balance_section.dart';
import 'package:daily_cash/features/purse_module/provider/purse_provider.dart';
import 'package:daily_cash/features/purse_module/widgets/purse_bottom_sheet.dart';
import 'package:daily_cash/features/purse_module/widgets/purse_tab_card.dart';
import 'package:daily_cash/features/purse_module/widgets/purse_tabs_delegate.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PurseScreen extends StatelessWidget {
  const PurseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;

    return ChangeNotifierProvider(
      create: (context) => PurseProvider(),
      child: Consumer<PurseProvider>(
        builder: (context, provider, _) {
          final categories = provider.getWalletCategories(context);
          return Scaffold(
            backgroundColor: themeColors.backgroundColor,
            appBar: SharedAppBar(
              title: context.l10n.wallet,
              showLeading: false,
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // ── Balance section ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.w20,
                      vertical: AppDimens.h16,
                    ),
                    child: DashboardBalanceSection(
                      showMinWithdrawalTxt: true,
                      rightBtnLabel: context.l10n.rewards,
                      leftBtnLabel: context.l10n.history,
                      rightOnTap: () {},
                      leftOnTap: () {
                        context.pushNamed(AppRoutes.walletHistory);
                      },
                      leftBtnVisible: true,
                      rightBtnVisible: false,
                    ),
                  ),
                ),

                // ── Floating tabs ─────────────────────────────────────
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: PurseTabsDelegate(),
                ),
              ],

              body: PageView.builder(
                controller: provider.pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  provider.setSelectedIndex(index);
                  provider.setWithdrawType(categories[index].dbTitle);
                },
                itemCount: categories.length,
                itemBuilder: (context, pageIndex) {
                  final items = categories[pageIndex].items;

                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.w20,
                      vertical: AppDimens.h8,
                    ),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          provider.setWithdrawSubType(items[index].dbTitle);

                          showModalBottomSheet(
                            context: rootNavKey.currentContext!,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) {
                              return ChangeNotifierProvider.value(
                                value: provider,
                                child: PurseBottomSheet(item: items[index]),
                              );
                            },
                          ).then((_) {
                            provider.resetWithdrawForm();
                          });
                        },
                        child: PurseTabCard(item: items[index]),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
