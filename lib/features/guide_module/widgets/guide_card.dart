import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class GuideCard extends StatelessWidget {
  final int index;
  final String title;
  final String description;

  const GuideCard({
    super.key,
    required this.index,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.r12),
          gradient: LinearGradient(
            colors: [
              context.themeColors.secondaryGradient4.withValues(alpha: 0.2),
              context.themeColors.secondaryGradient2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(1.2), // The gradient border width
        child: Container(
            padding: EdgeInsets.all(AppDimens.w16),
            decoration: BoxDecoration(
              color: context.themeColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppDimens.r12), // Adjust for border
            ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppDimens.w12,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.themeColors.backgroundColor,
              borderRadius: BorderRadius.circular(AppDimens.r8),
              border: Border.all(color: Colors.white10),

            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w14, vertical: AppDimens.h5),
              child: Text(
                index.toString(),
                strutStyle: StrutStyle(
                  fontSize: AppDimens.sp20,
                  height: 1.1,
                  forceStrutHeight: true,
                ),
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.sp20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppDimens.h5,
              children: [
                Text(
                  title,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppDimens.sp16,
                  ),
                ),
                Text(
                  description,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontWeight: FontWeight.w400,
                    fontSize: AppDimens.sp14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      ),
    );
  }
}
