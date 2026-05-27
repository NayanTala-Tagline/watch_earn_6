import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/purse_module/model/purse_models.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class PurseTabCard extends StatelessWidget {
  final PurseItem item;
  const PurseTabCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF120F2C), Color(0xFF121C5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          item.icon,
          const SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: AppDimens.sp13,
              fontWeight: FontWeight.w500,
              color: context.themeTextColors.textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
