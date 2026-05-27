import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.h16, horizontal: AppSize.w16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: AppSize.w12,
        children: [
          Expanded(
            child: Row(
              spacing: AppSize.w10,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: context.themeColors.primaryGradient2.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppSize.r12)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.w8),
                      child: icon,
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.themeTextColors.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: AppSize.sp16,
                        ),
                      ),
                      SizedBox(height: AppSize.h4),
                      Text(
                        subtitle,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.themeTextColors.descriptionColor, // Dimmed subtitle text matching screenshot
                          fontWeight: FontWeight.w400,
                          fontSize: AppSize.sp16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
