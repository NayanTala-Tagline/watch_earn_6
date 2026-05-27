import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class LeaderboardListTile extends StatelessWidget {
  final int rank;
  final String name;
  final int level;
  final String coins;

  const LeaderboardListTile({
    super.key,
    required this.rank,
    required this.name,
    required this.level,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    
    final initialsColor = _getAvatarColor(name);
    
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.h12),
      padding: EdgeInsets.symmetric(horizontal: AppSize.w16, vertical: AppSize.h12),
      decoration: BoxDecoration(
        color: context.themeColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppSize.r12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: AppSize.w20,
            child: Text(
              rank.toString(),
              style: context.textTheme.titleSmall?.copyWith(
                color: context.themeTextColors.textColor,
                fontWeight: FontWeight.w500,
                fontSize: AppSize.sp14
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: AppSize.w16),

          Container(
            width: AppSize.w40,
            height: AppSize.w40,
            decoration: BoxDecoration(
              color: context.themeColors.primaryGradient2.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppSize.r10),
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              strutStyle: StrutStyle(
                fontSize: AppSize.sp20,
                height: 1.1,
                forceStrutHeight: true,
              ),
              style: context.textTheme.titleMedium?.copyWith(
                color: initialsColor,
                fontSize: AppSize.sp20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: AppSize.w16),

          // Name and Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.sp16,
                  ),
                ),
                SizedBox(height: AppSize.h4),
                Text(
                  'Lv.$level',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontWeight: FontWeight.w400,
                    fontSize: AppSize.sp16,
                  ),
                ),
              ],
            ),
          ),

          // Coins output
          Container(
             padding: EdgeInsets.symmetric(horizontal: AppSize.w10, vertical: AppSize.h6),
             decoration: BoxDecoration(
               color: context.themeColors.secondaryGradient4.withValues(alpha: 0.1),
               borderRadius: BorderRadius.circular(AppSize.r16)
             ),
             child: Row(
               children: [
                 Assets.icons.tokens.svg(width: AppSize.w14),
                 SizedBox(width: AppSize.w6),
                 Text(
                   coins,
                   strutStyle: StrutStyle(
                     fontSize: AppSize.sp14,
                     height: 1.1,
                     forceStrutHeight: true,
                   ),
                   style: context.textTheme.labelMedium?.copyWith(
                     color: context.themeColors.secondaryGradient4,
                     fontWeight: FontWeight.w700,
                     fontSize: AppSize.sp14
                   ),
                 )
               ],
             ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(String name) {
    if (name.isEmpty) return Colors.white;
    final int hash = name.codeUnitAt(0);
    final List<Color> colors = [
      Color(0xFF424EFE), // Blue
      Color(0xFFFFB900), // Yellow
      Color(0xFF00CC9C), // Green
      Color(0xFF9467FF), // Purple
      Color(0xFFFF2D55), // Pink
      Color(0xFFFF7D00), // Orange
    ];
    return colors[hash % colors.length];
  }
}
