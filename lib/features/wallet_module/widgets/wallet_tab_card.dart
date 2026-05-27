import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/wallet_module/model/wallet_models.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class WalletTabCard extends StatelessWidget {
  final WalletItem item;
  const WalletTabCard({super.key, required this.item});

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
              fontSize: AppSize.sp13,
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
