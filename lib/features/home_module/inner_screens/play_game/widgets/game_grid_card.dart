import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/inner_screens/play_game/model/game_model.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class GameGridCard extends StatelessWidget {
  final GameItem game;
  final VoidCallback onTap;

  const GameGridCard({super.key, required this.game, required this.onTap});

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
              borderRadius: BorderRadius.circular(AppSize.r16),
              gradient: LinearGradient(
                colors: game.gradientColors
                    .map((c) => c.withValues(alpha: 0.3))
                    .toList(),
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(AppSize.w16),
              decoration: BoxDecoration(
                color: context.themeColors.surfaceColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSize.r16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: AppSize.w54,
                    height: AppSize.w54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.r12),
                      color: game.gradientColors.first.withValues(alpha: 0.1),
                    ),
                    alignment: Alignment.center,
                    child:
                        game.icon ??
                        Assets.navIcons.home.svg(
                          width: AppSize.w28,
                        ),
                  ),

                  const Spacer(),

                  Text(
                    game.title,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.themeTextColors.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: AppSize.sp17,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: AppSize.h6),

                  Row(
                    children: [
                      Assets.icons.coins.svg(width: AppSize.w14),
                      SizedBox(width: AppSize.w4),
                      Text(
                        '+${game.reward}',
                        strutStyle: StrutStyle(
                          fontSize: AppSize.sp14,
                          height: 1.1,
                          forceStrutHeight: true,
                        ),
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.themeTextColors.blueTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: AppSize.sp14,
                        ),
                      ),
                      SizedBox(width: AppSize.w4),
                      Text(
                        'Coins',
                        strutStyle: StrutStyle(
                          fontSize: AppSize.sp16,
                          height: 1.1,
                          forceStrutHeight: true,
                        ),
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.themeTextColors.descriptionColor,
                          fontWeight: FontWeight.w400,
                          fontSize: AppSize.sp16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: AppSize.h12,
            right: AppSize.w12,
            child: Assets.icons.openArrow.svg(),
          ),
        ],
      ),
    );
  }
}
