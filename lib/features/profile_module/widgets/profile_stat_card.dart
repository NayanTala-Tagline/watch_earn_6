import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSize.h16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.r12),
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.w10,vertical: AppSize.h5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppSize.sp16,
                ),
              ),
              SizedBox(height: AppSize.h4),
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.themeTextColors.descriptionColor,
                  fontWeight: FontWeight.w400,
                  fontSize: AppSize.sp14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
