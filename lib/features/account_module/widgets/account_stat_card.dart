import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class AccountStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const AccountStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppDimens.h16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.r12),
          color: color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w10,vertical: AppDimens.h5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.sp16,
                ),
              ),
              SizedBox(height: AppDimens.h4),
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.themeTextColors.descriptionColor,
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimens.sp14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
