import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Earn Rewards section — 2×2 grid of reward cards (Quiz, Games, Scratch, Spin)
/// Updated to match the high-fidelity border-based grid design.
class EarnPrizesSection extends StatelessWidget {
  const EarnPrizesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final items = provider.earnRewards;
        if (items.length < 4) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w4),
              child: Text(
                context.l10n.earnRewards,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppDimens.sp18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: AppDimens.h16),

            // 2×2 grid using nested Rows/Columns for precise spacing
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GlowBox(
                          highlight: context.themeColors.primaryGradient1,
                          child: _EarnPrizeCard(
                            item: items[0],
                            accentColor: context.themeColors.primaryGradient1,
                            color: context.themeColors.secondaryGradient1,
                            onTap: () {
                              RoutingHelper().navigateWithAdCheck(context, () {
                                context.pushNamed(AppRoutes.mathQuiz);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.w12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GlowBox(
                          highlight: context.themeColors.primaryGradient1,
                          child: _EarnPrizeCard(
                            item: items[1],
                            accentColor: context.themeColors.primaryGradient1,
                            color: context.themeColors.secondaryGradient2,
                            onTap: () {
                              RoutingHelper().navigateWithAdCheck(context, () {
                                context.pushNamed(AppRoutes.playGame);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.h12),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GlowBox(
                          highlight: context.themeTextColors.textColor,
                          child: _EarnPrizeCard(
                            item: items[2],
                            accentColor: context.themeTextColors.textColor,
                            color: context.themeTextColors.textColor,
                            onTap: () {
                              RoutingHelper().navigateWithAdCheck(context, () {
                                context.pushNamed(AppRoutes.scratchWin);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.w12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GlowBox(
                          highlight: context.themeColors.secondaryGradient4,
                          child: _EarnPrizeCard(
                            item: items[3],
                            accentColor: context.themeColors.secondaryGradient4,
                            color: context.themeColors.secondaryGradient4,
                            onTap: () {
                              RoutingHelper().navigateWithAdCheck(context, () {
                                context.pushNamed(AppRoutes.spinWheel);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Single Earn Reward Card with colored border and top-right badge
class _EarnPrizeCard extends StatelessWidget {
  final EarnPrizeItem item;
  final Color accentColor;
  final Color color;
  final VoidCallback onTap;

  const _EarnPrizeCard({required this.item, required this.accentColor, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.themeColors.primaryGradient2, Colors.black.withValues(alpha: 0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(AppDimens.r14),
          border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.2),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w10, vertical: AppDimens.h15),
              child: Row(
                children: [
                  Container(
                    width: AppDimens.w44,
                    height: AppDimens.h44,
                    padding: EdgeInsets.all(AppDimens.w10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppDimens.r12),
                    ),
                    child: item.icon.svg(),
                  ),
                  SizedBox(width: AppDimens.w10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.split(' ')[0],
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.themeTextColors.textColor,
                            fontSize: AppDimens.sp16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.subtitle,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            fontSize: AppDimens.sp14, // Adjusted from 16 to 14 for better hierarchy
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: AppDimens.h4,
              right: AppDimens.w4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.w8, vertical: AppDimens.h4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimens.r10),
                ),
                child: Text(
                  '+${item.reward}',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
