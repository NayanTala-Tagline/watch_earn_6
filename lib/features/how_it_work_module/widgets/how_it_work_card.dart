import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class HowItWorkCard extends StatelessWidget {
  final int index;
  final String title;
  final String description;

  const HowItWorkCard({
    super.key,
    required this.index,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.r12),
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
            padding: EdgeInsets.all(AppSize.w16),
            decoration: BoxDecoration(
              color: context.themeColors.surfaceColor,
              borderRadius: BorderRadius.circular(AppSize.r12), // Adjust for border
            ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSize.w12,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.themeColors.backgroundColor,
              borderRadius: BorderRadius.circular(AppSize.r8),
              border: Border.all(color: Colors.white10),

            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.w14, vertical: AppSize.h5),
              child: Text(
                index.toString(),
                strutStyle: StrutStyle(
                  fontSize: AppSize.sp20,
                  height: 1.1,
                  forceStrutHeight: true,
                ),
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppSize.sp20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.h5,
              children: [
                Text(
                  title,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.sp16,
                  ),
                ),
                Text(
                  description,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontWeight: FontWeight.w400,
                    fontSize: AppSize.sp14,
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
