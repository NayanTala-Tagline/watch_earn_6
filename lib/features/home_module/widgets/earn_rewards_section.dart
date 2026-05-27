import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/provider/home_provider.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Earn Rewards section — 2×2 grid of reward cards (Quiz, Games, Scratch, Spin)
/// Updated to match the high-fidelity border-based grid design.
class EarnRewardsSection extends StatelessWidget {
  const EarnRewardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final items = provider.earnRewards;
        if (items.length < 4) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.w4),
              child: Text(
                context.l10n.earnRewards,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppSize.sp18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: AppSize.h16),

            // 2×2 grid using nested Rows/Columns for precise spacing
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GlowContainer(
                          accent: context.themeColors.primaryGradient1,
                          child: _EarnRewardCard(
                            item: items[0],
                            accentColor: context.themeColors.primaryGradient1,
                            color: context.themeColors.secondaryGradient1,
                            onTap: () {
                              NavigationHelper().navigateWithAdCheck(context, () {
                                context.pushNamed(AppRoutes.mathQuiz);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.w12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GlowContainer(
                          accent: context.themeColors.primaryGradient1,
                          child: _EarnRewardCard(
                            item: items[1],
                            accentColor: context.themeColors.primaryGradient1,
                            color: context.themeColors.secondaryGradient2,
                            onTap: () {
                              NavigationHelper().navigateWithAdCheck(context, () {
                                context.pushNamed(AppRoutes.playGame);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.h12),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GlowContainer(
                          accent: context.themeTextColors.textColor,
                          child: _EarnRewardCard(
                            item: items[2],
                            accentColor: context.themeTextColors.textColor,
                            color: context.themeTextColors.textColor,
                            onTap: () {
                              NavigationHelper().navigateWithAdCheck(context, () {
                                context.pushNamed(AppRoutes.scratchWin);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.w12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GlowContainer(
                          accent: context.themeColors.secondaryGradient4,
                          child: _EarnRewardCard(
                            item: items[3],
                            accentColor: context.themeColors.secondaryGradient4,
                            color: context.themeColors.secondaryGradient4,
                            onTap: () {
                              NavigationHelper().navigateWithAdCheck(context, () {
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
class _EarnRewardCard extends StatelessWidget {
  final EarnRewardItem item;
  final Color accentColor;
  final Color color;
  final VoidCallback onTap;

  const _EarnRewardCard({required this.item, required this.accentColor, required this.color, required this.onTap});

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
          borderRadius: BorderRadius.circular(AppSize.r14),
          border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.2),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.w10, vertical: AppSize.h15),
              child: Row(
                children: [
                  Container(
                    width: AppSize.w44,
                    height: AppSize.h44,
                    padding: EdgeInsets.all(AppSize.w10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSize.r12),
                    ),
                    child: item.icon.svg(),
                  ),
                  SizedBox(width: AppSize.w10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.split(' ')[0],
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.themeTextColors.textColor,
                            fontSize: AppSize.sp16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.subtitle,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            fontSize: AppSize.sp14, // Adjusted from 16 to 14 for better hierarchy
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
              top: AppSize.h4,
              right: AppSize.w4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSize.w8, vertical: AppSize.h4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSize.r10),
                ),
                child: Text(
                  '+${item.reward}',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontSize: AppSize.sp14,
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
