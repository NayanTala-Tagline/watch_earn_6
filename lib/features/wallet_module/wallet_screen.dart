import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/widgets/home_balance_section.dart';
import 'package:daily_cash/features/wallet_module/provider/wallet_provider.dart';
import 'package:daily_cash/features/wallet_module/widgets/wallet_bottom_sheet.dart';
import 'package:daily_cash/features/wallet_module/widgets/wallet_tab_card.dart';
import 'package:daily_cash/features/wallet_module/widgets/wallet_tabs_delegate.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;

    return ChangeNotifierProvider(
      create: (context) => WalletProvider(),
      child: Consumer<WalletProvider>(
        builder: (context, provider, _) {
          final categories = provider.getWalletCategories(context);
          return Scaffold(
            backgroundColor: themeColors.backgroundColor,
            appBar: CommonAppBar(
              title: context.l10n.wallet,
              showLeading: false,
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // ── Balance section ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.w20,
                      vertical: AppSize.h16,
                    ),
                    child: HomeBalanceSection(
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
                  delegate: WalletTabsDelegate(),
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
                      horizontal: AppSize.w20,
                      vertical: AppSize.h8,
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
                                child: WalletBottomSheet(item: items[index]),
                              );
                            },
                          ).then((_) {
                            provider.resetWithdrawForm();
                          });
                        },
                        child: WalletTabCard(item: items[index]),
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
