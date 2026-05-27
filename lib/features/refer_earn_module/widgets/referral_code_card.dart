import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class ReferralCodeCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final LinearGradient? gradient;
  final VoidCallback onTap;
  final Color titleColor;

  const ReferralCodeCard({
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
          padding: EdgeInsets.all(AppSize.w14),
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? Colors.transparent : null,
            borderRadius: BorderRadius.circular(AppSize.r12),
            border: gradient == null ? Border.all(color: Colors.orange.withValues(alpha: 0.4), width: 1.5) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: AppSize.h10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Main Icon
                  Container(
                    width: AppSize.w40,
                    height: AppSize.w40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSize.r8),
                    ),
                    alignment: Alignment.center,
                    child: icon,
                  ),

                  Assets.icons.expandArrow.svg(width: AppSize.w18),
                ],
              ),

              // Card Text
              Text(
                title,
                style: context.textTheme.labelMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.sp14,
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
