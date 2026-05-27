import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: AppSize.w54,
        height: AppSize.h25,
        padding: EdgeInsets.symmetric(horizontal: AppSize.w4, vertical: AppSize.h2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.r20),
          gradient: value
              ? LinearGradient(
                  colors: [
                    context.themeColors.primaryGradient2.withValues(alpha: 0.5),
                    context.themeColors.secondaryGradient5,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: value ? null : Colors.white.withValues(alpha: 0.5),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: AppSize.w20,
            height: AppSize.w20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
