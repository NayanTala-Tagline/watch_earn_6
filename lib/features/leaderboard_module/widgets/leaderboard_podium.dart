import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:flutter/material.dart';

class LeaderboardPodium extends StatelessWidget {
  final int rank;
  final String name;
  final String coins;
  final double height;
  final LinearGradient gradient;
  final Color borderColor;
  final Color avatarColor;

  const LeaderboardPodium({
    super.key,
    required this.rank,
    required this.name,
    required this.coins,
    required this.height,
    required this.gradient,
    required this.borderColor,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isFirst = rank == 1;
    double avatarSize = isFirst ? AppSize.w60 : AppSize.w50;
    double value = isFirst ? 1.3 : 2.5;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 1. Name
          Text(
            name,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.themeTextColors.textColor,
              fontWeight: FontWeight.w700,
              fontSize: AppSize.sp15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSize.h6),

          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSize.w8, vertical: AppSize.h4),
            decoration: BoxDecoration(
              color: context.themeColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppSize.r12),
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.coins.svg(width: AppSize.w12),
                SizedBox(width: AppSize.w4),
                Text(
                  coins,
                  strutStyle: StrutStyle(
                    fontSize: AppSize.sp14,
                    height: 1.1,
                    forceStrutHeight: true,
                  ),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.sp14,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isFirst ? AppSize.h60 : AppSize.h40),

          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: GlowContainer(
                  accent: gradient.colors.last,
                  borderRadius: 16,
                  child: Container(
                    height: height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(AppSize.r16),
                      border: Border.all(color: borderColor.withValues(alpha: 0.5), width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        rank.toString(),
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.themeTextColors.textColor.withValues(alpha: 0.3), // Faded look
                          fontSize: AppSize.sp30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: -(avatarSize / value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFirst)
                      Assets.icons.winningCap.svg(width: AppSize.w28),
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [avatarColor,context.themeColors.surfaceColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: avatarColor.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Assets.navIcons.profile.svg(
                        width: avatarSize * 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}