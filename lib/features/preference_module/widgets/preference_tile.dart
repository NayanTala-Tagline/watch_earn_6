import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class PreferenceTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const PreferenceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.h16, horizontal: AppDimens.w16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: AppDimens.w12,
        children: [
          Expanded(
            child: Row(
              spacing: AppDimens.w10,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: context.themeColors.primaryGradient2.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppDimens.r12)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppDimens.w8),
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
                          fontSize: AppDimens.sp16,
                        ),
                      ),
                      SizedBox(height: AppDimens.h4),
                      Text(
                        subtitle,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.themeTextColors.descriptionColor, // Dimmed subtitle text matching screenshot
                          fontWeight: FontWeight.w400,
                          fontSize: AppDimens.sp16,
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
