import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class InviteCodeCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final LinearGradient? gradient;
  final VoidCallback onTap;
  final Color titleColor;

  const InviteCodeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor = Colors.white,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppDimens.w14),
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? Colors.transparent : null,
            borderRadius: BorderRadius.circular(AppDimens.r12),
            border: gradient == null ? Border.all(color: Colors.orange.withValues(alpha: 0.4), width: 1.5) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: AppDimens.h10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Main Icon
                  Container(
                    width: AppDimens.w40,
                    height: AppDimens.w40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimens.r8),
                    ),
                    alignment: Alignment.center,
                    child: icon,
                  ),

                  Assets.icons.expandArrow.svg(width: AppDimens.w18),
                ],
              ),

              // Card Text
              Text(
                title,
                style: context.textTheme.labelMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppDimens.sp14,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
