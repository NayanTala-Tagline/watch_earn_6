import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/achievement_module/model/achievement_model.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  final AchievementItem achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;
    
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.h16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.r12),
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
        padding: EdgeInsets.all(AppSize.w16),
        decoration: BoxDecoration(
          color: themeColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppSize.r12), // Adjust for border
        ),
        child: Row(
          children: [
          // Icon Container with Neon Glow
          Assets.icons.trophy.svg(height: AppSize.h40,width: AppSize.w40),
          
          SizedBox(width: AppSize.w16),
          
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
                SizedBox(height: AppSize.h4),
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
            padding: EdgeInsets.symmetric(horizontal: AppSize.w10, vertical: AppSize.h4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppSize.r20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.coins.svg(width: AppSize.w16),
                SizedBox(width: AppSize.w4),
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
