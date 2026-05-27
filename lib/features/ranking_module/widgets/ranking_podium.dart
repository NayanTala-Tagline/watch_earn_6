import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:flutter/material.dart';

class RankingPodium extends StatelessWidget {
  final int rank;
  final String name;
  final String coins;
  final double height;
  final LinearGradient gradient;
  final Color borderColor;
  final Color avatarColor;

  const RankingPodium({
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
    double avatarSize = isFirst ? AppDimens.w60 : AppDimens.w50;
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
              fontSize: AppDimens.sp15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimens.h6),

          Container(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.w8, vertical: AppDimens.h4),
            decoration: BoxDecoration(
              color: context.themeColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppDimens.r12),
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.tokens.svg(width: AppDimens.w12),
                SizedBox(width: AppDimens.w4),
                Text(
                  coins,
                  strutStyle: StrutStyle(
                    fontSize: AppDimens.sp14,
                    height: 1.1,
                    forceStrutHeight: true,
                  ),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppDimens.sp14,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isFirst ? AppDimens.h60 : AppDimens.h40),

          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: GlowBox(
                  highlight: gradient.colors.last,
                  borderRadius: 16,
                  child: Container(
                    height: height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(AppDimens.r16),
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
                          fontSize: AppDimens.sp30,
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
                      Assets.icons.victoryCap.svg(width: AppDimens.w28),
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
                      child: Assets.navIcons.account.svg(
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