import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  final String title;
  final double currentIndex;
  final TextStyle? style;
  final String? description;

  const IntroCard({
    super.key,
    required this.title,
    required this.description,
    required this.currentIndex,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF120F2C), Color(0xFF122077)],
          begin: Alignment.bottomLeft,
          end: Alignment.bottomRight,
        ),
        color: context.themeColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(top: 35, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Glowing Title ──────────────────────
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                style ??
                context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: AppDimens.sp28,
                  color: context.themeTextColors.textColor,
                ),
          ),

          const SizedBox(height: 1),
          // ── Subtitle ───────────────────────────
          if (description != null)
            Text(
              description!,
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: AppDimens.sp15,
                color: context.themeTextColors.descriptionColor,
              ),
            ),
          const SizedBox(height: 20),
          // ── Static 3-dot indicator (first dot active) ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = currentIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: isActive ? 16 : 8,
                  height: 8,
                  decoration: isActive
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0x909467FF),
                              Color(0xFF424EFE),
                              Color(0xFF3346FF),
                              Color(0xF805C1FD),
                            ],
                          ),
                        )
                      : const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF273079),
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
