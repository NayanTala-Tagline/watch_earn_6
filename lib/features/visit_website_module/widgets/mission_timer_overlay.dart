import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/visit_website_module/provider/visit_website_provider.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A floating overlay entry that shows the countdown timer on top of
/// the in-app browser view. Inserted into the root Overlay so it
/// persists even when the browser covers the screen.
class MissionTimerOverlay {
  OverlayEntry? _entry;

  void show(BuildContext context, int cardIndex) {
    _entry?.remove();
    _entry = OverlayEntry(
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<VisitWebsiteProvider>(),
        child: _TimerBubble(cardIndex: cardIndex, onClose: hide),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _TimerBubble extends StatelessWidget {
  final int cardIndex;
  final VoidCallback onClose;

  const _TimerBubble({required this.cardIndex, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final provider  = context.watch<VisitWebsiteProvider>();
    final remaining = provider.remaining(cardIndex);
    final completed = provider.isCompleted(cardIndex);
    final running   = provider.isRunning(cardIndex);

    // Auto-hide once completed or cancelled
    if (!running && !completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onClose());
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: AppSize.h60,
      right: AppSize.w16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppSize.w16, vertical: AppSize.h12),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0F2A).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(AppSize.r16),
            border: Border.all(
              color: completed
                  ? context.themeColors.secondaryGradient3
                  : context.themeColors.secondaryGradient4,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 12,
              ),
            ],
          ),
          child: completed
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: context.themeColors.secondaryGradient3,
                        size: AppSize.w20),
                    SizedBox(width: AppSize.w8),
                    Text(
                      'Done! Claim reward',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.themeColors.secondaryGradient3,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSize.sp14,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSize.w10,
                  children: [
                    Text(
                      '$remaining',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.themeTextColors.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSize.sp10,
                      ),
                    ),
                    Text(
                      'Stay on page...',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.themeTextColors.descriptionColor,
                        fontSize: AppSize.sp13,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
