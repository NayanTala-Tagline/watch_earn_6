import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/milestone_module/model/milestone_item.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class MilestoneCard extends StatelessWidget {
  final MilestoneItem achievement;

  const MilestoneCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;
    
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.h16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.r12),
        gradient: LinearGradient(
          colors: [
            themeColors.secondaryGradient2,
            themeColors.secondaryGradient4.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(1.2), // The gradient border width
      child: Container(
        padding: EdgeInsets.all(AppDimens.w16),
        decoration: BoxDecoration(
          color: themeColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppDimens.r12), // Adjust for border
        ),
        child: Row(
          children: [
          // Icon Container with Neon Glow
          Assets.icons.award.svg(height: AppDimens.h40,width: AppDimens.w40),
          
          SizedBox(width: AppDimens.w16),
          
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDimens.h4),
                Text(
                  achievement.description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          
          // Reward Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.w10, vertical: AppDimens.h4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppDimens.r20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.tokens.svg(width: AppDimens.w16),
                SizedBox(width: AppDimens.w4),
                Text(
                  '+${achievement.reward}',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.themeTextColors.blueTextColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }
}
