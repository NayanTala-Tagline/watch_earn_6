import 'dart:async';
import 'package:flutter/material.dart';
import '../extension/ext_context.dart';
import '../utils/app_size.dart';
import 'app_button.dart';

class RewardAdBottomSheet extends StatefulWidget {
  final VoidCallback onSupportUs;
  final VoidCallback onCancel;
  final int timerSeconds;

  const RewardAdBottomSheet({
    super.key,
    required this.onSupportUs,
    required this.onCancel,
    this.timerSeconds = 3,
  });

  @override
  State<RewardAdBottomSheet> createState() => _RewardAdBottomSheetState();
}

class _RewardAdBottomSheetState extends State<RewardAdBottomSheet> {
  late int _secondsLeft;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.timerSeconds;
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _countdownTimer?.cancel();
        // Auto-close and show ad after timer expires
        Navigator.of(context).pop();
        widget.onSupportUs();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette  = context.themeColors;
    final textPalette = context.themeTextColors;

    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.r20)),
        border: Border(
          top: BorderSide(color: palette.secondaryGradient2.withValues(alpha: 0.3), width: 1),
        ),
      ),
      padding: EdgeInsets.all(AppSize.w20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: AppSize.w40,
            height: AppSize.h4,
            decoration: BoxDecoration(
              color: textPalette.descriptionColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppSize.r2),
            ),
          ),
          SizedBox(height: AppSize.h20),

          // Title
          Text(
            'Support Our App',
            style: context.textTheme.titleLarge?.copyWith(
              color: textPalette.textColor,
              fontSize: AppSize.sp22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSize.h12),

          // Description
          Text(
            'Help us keep the app free by watching a short ad. Your support means everything to us!',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: AppSize.sp16,
              color: textPalette.descriptionColor,
            ),
          ),
          SizedBox(height: AppSize.h20),

          // Timer display
          if (_secondsLeft > 0)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.w16,
                vertical: AppSize.h8,
              ),
              decoration: BoxDecoration(
                color: palette.primaryGradient2.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(AppSize.r12),
                border: Border.all(color: palette.secondaryGradient2.withValues(alpha: 0.2)),
              ),
              child: Text(
                'Auto-starting in $_secondsLeft seconds...',
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: AppSize.sp14,
                  color: textPalette.descriptionColor,
                ),
              ),
            ),

          SizedBox(height: AppSize.h24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Cancel',
                  backgroundColor: palette.backgroundColor,
                  borderRadius: AppSize.r25,
                  onPressed: () {
                    _countdownTimer?.cancel();
                    Navigator.of(context).pop();
                    widget.onCancel();
                  },
                ),
              ),
              SizedBox(width: AppSize.w12),
              Expanded(
                child: AppButton(
                  text: 'Support Us',
                  borderRadius: AppSize.r25,
                  onPressed: () {
                    _countdownTimer?.cancel();
                    Navigator.of(context).pop();
                    widget.onSupportUs();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.h10),
        ],
      ),
    );
  }
}

/// Helper function to show the reward ad bottom sheet
Future<void> showRewardAdBottomSheet({
  required BuildContext context,
  required VoidCallback onSupportUs,
  required VoidCallback onCancel,
  int timerSeconds = 3,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (context) => RewardAdBottomSheet(
      onSupportUs: onSupportUs,
      onCancel: onCancel,
      timerSeconds: timerSeconds,
    ),
  );
}