import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/widgets/ad_notice_text.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Daily Check-in Reward Card matching the reference image layout.
/// Features a segmented progress bar with slanted parallelogram segments and floating status icons.
class DailyLoginCard extends StatelessWidget {
  const DailyLoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            color: context.themeColors.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimens.r10),
            border: Border.all(color: context.themeColors.secondaryGradient2.withValues(alpha: 0.5)),
          ),

          padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.dailyCheckinReward,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.themeTextColors.textColor,
                        fontSize: AppDimens.sp18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '+${provider.dailyRewardCoins} Coins',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF007BFF),
                      fontSize: AppDimens.sp16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimens.h24),

              // ─── Progress Bar with Floating Icons ───────────────────
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      // Segments Row
                      Row(
                        children: List.generate(7, (index) {
                          final day = index + 1;
                          final isCompleted = day < provider.currentCheckInDay;
                          final isCurrent = day == provider.currentCheckInDay;

                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppDimens.w4),
                              child: _ProgressChunk(isCompleted: isCompleted, isCurrent: isCurrent),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: AppDimens.h10),
                      // Labels Row
                      Row(
                        children: List.generate(7, (index) {
                          final day = index + 1;
                          final isDay7 = day == 7;
                          return Expanded(
                            child: Center(
                              child: Text(
                                isDay7 ? '7' : 'Day $day',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                  fontSize: AppDimens.sp11,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),

                  // Floating Checkmark on Day 1
                  if (provider.currentCheckInDay > 1)
                    Positioned(
                      top: -AppDimens.h10,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: AppDimens.r12),
                      ),
                    ),

                  // Floating Gift Box on Day 7
                  Positioned(
                    top: -AppDimens.h20,
                    right: 0,
                    child: Assets.icons.tokens.svg(width: AppDimens.w36, height: AppDimens.h36, fit: BoxFit.contain),
                  ),
                ],
              ),
              SizedBox(height: AppDimens.h24),

              // ─── Ad disclaimer + Action Button ─────────────────────
              if (!provider.isRewardClaimed && !provider.adWatched)
                AdNoticeText(show: RewardAdService.isDailyCheckinAdEnabled),
              GradientActionButton(
                text: provider.isRewardClaimed ? context.l10n.rewardClaimed : context.l10n.claimReward,
                tailIcon: provider.isRewardClaimed
                    ? const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20)
                    : Icon(Icons.arrow_forward_ios, color: Colors.white, size: AppDimens.w20),
                onPressed: provider.isRewardClaimed
                    ? null
                    : () => provider.claimReward(context),
                height: AppDimens.h50,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A slanted parallelogram segment for the progress bar.
class _ProgressChunk extends StatelessWidget {
  final bool isCompleted;
  final bool isCurrent;

  const _ProgressChunk({required this.isCompleted, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    bool isIncomplete = !isCompleted && !isCurrent;

    return Transform(
      transform: Matrix4.skewX(-0.25),
      child: Container(
        height: AppDimens.h16,
        decoration: BoxDecoration(
          // Use border instead of fill color for incomplete days as requested
          color: isIncomplete ? Colors.white.withValues(alpha: 0.05) : null,
          border: isIncomplete ? Border.all(color: Colors.white12, width: 1) : null,
          gradient: !isIncomplete
              ? const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius: BorderRadius.circular(AppDimens.r2),
        ),
      ),
    );
  }
}
