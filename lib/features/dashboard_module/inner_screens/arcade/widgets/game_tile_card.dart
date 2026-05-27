import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/arcade/model/game_entry.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class GameTileCard extends StatelessWidget {
  final GameEntry game;
  final VoidCallback onTap;

  const GameTileCard({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.r16),
              gradient: LinearGradient(
                colors: game.gradientColors
                    .map((c) => c.withValues(alpha: 0.3))
                    .toList(),
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(AppDimens.w16),
              decoration: BoxDecoration(
                color: context.themeColors.surfaceColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppDimens.r16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: AppDimens.w54,
                    height: AppDimens.w54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimens.r12),
                      color: game.gradientColors.first.withValues(alpha: 0.1),
                    ),
                    alignment: Alignment.center,
                    child:
                        game.icon ??
                        Assets.navIcons.house.svg(
                          width: AppDimens.w28,
                        ),
                  ),

                  const Spacer(),

                  Text(
                    game.title,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.themeTextColors.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: AppDimens.sp17,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: AppDimens.h6),

                  Row(
                    children: [
                      Assets.icons.tokens.svg(width: AppDimens.w14),
                      SizedBox(width: AppDimens.w4),
                      Text(
                        '+${game.reward}',
                        strutStyle: StrutStyle(
                          fontSize: AppDimens.sp14,
                          height: 1.1,
                          forceStrutHeight: true,
                        ),
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.themeTextColors.blueTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: AppDimens.sp14,
                        ),
                      ),
                      SizedBox(width: AppDimens.w4),
                      Text(
                        'Coins',
                        strutStyle: StrutStyle(
                          fontSize: AppDimens.sp16,
                          height: 1.1,
                          forceStrutHeight: true,
                        ),
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.themeTextColors.descriptionColor,
                          fontWeight: FontWeight.w400,
                          fontSize: AppDimens.sp16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: AppDimens.h12,
            right: AppDimens.w12,
            child: Assets.icons.expandArrow.svg(),
          ),
        ],
      ),
    );
  }
}
