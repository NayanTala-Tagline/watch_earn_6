import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/ad_disclaimer_text.dart';
import 'package:daily_cash/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

class DailyCheckinDialog extends StatelessWidget {
  final int currentDay;
  final int rewardCoins;
  final VoidCallback onClaim;

  const DailyCheckinDialog({
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
      contentPadding: EdgeInsets.all(AppSize.w24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.coins.svg(
            width: AppSize.w60,
            height: AppSize.h60,
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppSize.h16),
          Text(
            'Daily Check-in Reward',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.themeTextColors.textColor,
              fontSize: AppSize.sp18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSize.h8),
          Text(
            'Day $currentDay',
            style: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8B5CF6),
              fontSize: AppSize.sp16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSize.h8),
          Text(
            'Claim your daily reward of +$rewardCoins Coins!',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.themeTextColors.descriptionColor,
              fontSize: AppSize.sp14,
            ),
          ),
          SizedBox(height: AppSize.h8),

          // Progress bar
          Row(
            children: List.generate(7, (index) {
              final day = index + 1;
              final isCompleted = day < currentDay;
              final isCurrent = day == currentDay;
              final isIncomplete = !isCompleted && !isCurrent;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.w2),
                  child: Transform(
                    transform: Matrix4.skewX(-0.25),
                    child: Container(
                      height: AppSize.h12,
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
                        borderRadius: BorderRadius.circular(AppSize.r2),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: AppSize.h20),

          AdDisclaimerText(show: RewardAdService.isDailyCheckinAdEnabled),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              text: 'Claim Reward',
              trailingIcon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: AppSize.w20,
              ),
              onPressed: onClaim,
              height: AppSize.h50,
            ),
          ),
        ],
      ),
    );
  }
}
