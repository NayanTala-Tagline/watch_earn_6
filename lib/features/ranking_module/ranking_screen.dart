import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/ranking_module/provider/ranking_provider.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../gen/assets.gen.dart';
import 'widgets/ranking_list_tile.dart';
import 'widgets/ranking_podium.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'leaderboard_screen');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        RoutingHelper().handleBackPress(context);
      },
      child: ChangeNotifierProvider(
        create: (_) => RankingProvider(),
        child: Consumer<RankingProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              backgroundColor: context.themeColors.backgroundColor,
              appBar: SharedAppBar(title: context.l10n.leaderboard, showLeading: false),
              body: provider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : provider.error != null
                      ? Center(
                          child: Text(
                            provider.error ?? '',
                            style: context.textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: provider.canRefresh
                              ? () => provider.refresh()
                              : () async {},
                          color: context.themeColors.secondaryGradient4,
                          backgroundColor: context.themeColors.surfaceColor,
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      AppDimens.w20, AppDimens.h20, AppDimens.w20, AppDimens.h30),
                                  child: Column(
                                    children: [
                                      // ── Podium ──────────────────────────────
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          RankingPodium(
                                            rank: 2,
                                            name: provider.top3[1].name,
                                            coins: provider.top3[1].coins,
                                            height: AppDimens.h110,
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF0C3D2F), Color(0xFF147558)],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                            borderColor: const Color(0xFF1A8C66),
                                            avatarColor: const Color(0xFF147558),
                                          ),
                                          SizedBox(width: AppDimens.w8),
                                          RankingPodium(
                                            rank: 1,
                                            name: provider.top3[0].name,
                                            coins: provider.top3[0].coins,
                                            height: AppDimens.h140,
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF0F1B4E), Color(0xFF2A5298)],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                            borderColor: context.themeColors.secondaryGradient3,
                                            avatarColor: context.themeColors.secondaryGradient1,
                                          ),
                                          SizedBox(width: AppDimens.w8),
                                          RankingPodium(
                                            rank: 3,
                                            name: provider.top3[2].name,
                                            coins: provider.top3[2].coins,
                                            height: AppDimens.h110,
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF4A260C), Color(0xFF8A531C)],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                            borderColor: const Color(0xFFA56627),
                                            avatarColor: const Color(0xFF8A531C),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: AppDimens.h30),

                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Assets.icons.award.svg(
                                            width: AppDimens.w26,
                                            height: AppDimens.h26,
                                          ),
                                          SizedBox(width: AppDimens.w8),
                                          Text(
                                            provider.canRefresh
                                                ? context.l10n.pullDownToRefresh
                                                : context.l10n.refreshIn,
                                            style: context.textTheme.labelMedium?.copyWith(
                                              color: provider.canRefresh
                                                  ? context.themeColors.secondaryGradient3
                                                  : context.themeTextColors.textColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: AppDimens.sp18,
                                            ),
                                          ),
                                          if (!provider.canRefresh)
                                            SizedBox(
                                              width: AppDimens.w120,
                                              child: Text(
                                                provider.formattedTimer,
                                                style: context.textTheme.labelMedium?.copyWith(
                                                  color: context.themeTextColors.greenTextColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: AppDimens.sp18,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // ── Ranked list (rank 4+) ──────────────────────
                              SliverPadding(
                                padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final user = provider.listUsers[index];
                                      return RankingListTile(
                                        rank: index + 4,
                                        name: user.name,
                                        level: user.level,
                                        coins: user.coins,
                                      );
                                    },
                                    childCount: provider.listUsers.length,
                                  ),
                                ),
                              ),

                              SliverToBoxAdapter(child: SizedBox(height: AppDimens.h20)),
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
