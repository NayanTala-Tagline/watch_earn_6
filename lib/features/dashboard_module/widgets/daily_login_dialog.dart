import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/ad_notice_text.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';

class DailyLoginDialog extends StatelessWidget {
  final int currentDay;
  final int rewardCoins;
  final VoidCallback onClaim;

  const DailyLoginDialog({
    super.key,
    required this.currentDay,
    required this.rewardCoins,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.themeColors.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.all(AppDimens.w24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.tokens.svg(
            width: AppDimens.w60,
            height: AppDimens.h60,
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppDimens.h16),
          Text(
            'Daily Check-in Reward',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.themeTextColors.textColor,
              fontSize: AppDimens.sp18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.h8),
          Text(
            'Day $currentDay',
            style: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8B5CF6),
              fontSize: AppDimens.sp16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimens.h8),
          Text(
            'Claim your daily reward of +$rewardCoins Coins!',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.themeTextColors.descriptionColor,
              fontSize: AppDimens.sp14,
            ),
          ),
          SizedBox(height: AppDimens.h8),

          // Progress bar
          Row(
            children: List.generate(7, (index) {
              final day = index + 1;
              final isCompleted = day < currentDay;
              final isCurrent = day == currentDay;
              final isIncomplete = !isCompleted && !isCurrent;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w2),
                  child: Transform(
                    transform: Matrix4.skewX(-0.25),
                    child: Container(
                      height: AppDimens.h12,
                      decoration: BoxDecoration(
                        color: isIncomplete
                            ? Colors.white.withValues(alpha: 0.05)
                            : null,
                        border: isIncomplete
                            ? Border.all(color: Colors.white12, width: 1)
                            : null,
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
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: AppDimens.h20),

          AdNoticeText(show: RewardAdService.isDailyCheckinAdEnabled),
          SizedBox(
            width: double.infinity,
            child: GradientActionButton(
              text: 'Claim Reward',
              tailIcon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: AppDimens.w20,
              ),
              onPressed: onClaim,
              height: AppDimens.h50,
            ),
          ),
        ],
      ),
    );
  }
}
