import 'dart:async';
import 'package:flutter/material.dart';
import '../extension/ext_context.dart';
import '../utils/app_dimens.dart';
import 'app_action_button.dart';

class RewardedAdBottomSheet extends StatefulWidget {
  final VoidCallback onSupportTap;
  final VoidCallback onCancel;
  final int countdownSeconds;

  const RewardedAdBottomSheet({
    super.key,
    required this.onSupportTap,
    required this.onCancel,
    this.countdownSeconds = 3,
  });

  @override
  State<RewardedAdBottomSheet> createState() => _RewardedAdBottomSheetState();
}

class _RewardedAdBottomSheetState extends State<RewardedAdBottomSheet> {
  late int _secondsLeft;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.countdownSeconds;
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
        widget.onSupportTap();
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.r20)),
        border: Border(
          top: BorderSide(color: palette.secondaryGradient2.withValues(alpha: 0.3), width: 1),
        ),
      ),
      padding: EdgeInsets.all(AppDimens.w20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: AppDimens.w40,
            height: AppDimens.h4,
            decoration: BoxDecoration(
              color: textPalette.descriptionColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppDimens.r2),
            ),
          ),
          SizedBox(height: AppDimens.h20),

          // Title
          Text(
            'Support Our App',
            style: context.textTheme.titleLarge?.copyWith(
              color: textPalette.textColor,
              fontSize: AppDimens.sp22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimens.h12),

          // Description
          Text(
            'Help us keep the app free by watching a short ad. Your support means everything to us!',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: AppDimens.sp16,
              color: textPalette.descriptionColor,
            ),
          ),
          SizedBox(height: AppDimens.h20),

          // Timer display
          if (_secondsLeft > 0)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.w16,
                vertical: AppDimens.h8,
              ),
              decoration: BoxDecoration(
                color: palette.primaryGradient2.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(AppDimens.r12),
                border: Border.all(color: palette.secondaryGradient2.withValues(alpha: 0.2)),
              ),
              child: Text(
                'Auto-starting in $_secondsLeft seconds...',
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: AppDimens.sp14,
                  color: textPalette.descriptionColor,
                ),
              ),
            ),

          SizedBox(height: AppDimens.h24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: AppActionButton(
                  text: 'Cancel',
                  backgroundColor: palette.backgroundColor,
                  borderRadius: AppDimens.r25,
                  onPressed: () {
                    _countdownTimer?.cancel();
                    Navigator.of(context).pop();
                    widget.onCancel();
                  },
                ),
              ),
              SizedBox(width: AppDimens.w12),
              Expanded(
                child: AppActionButton(
                  text: 'Support Us',
                  borderRadius: AppDimens.r25,
                  onPressed: () {
                    _countdownTimer?.cancel();
                    Navigator.of(context).pop();
                    widget.onSupportTap();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.h10),
        ],
      ),
    );
  }
}

/// Helper function to show the reward ad bottom sheet
Future<void> showRewardAdBottomSheet({
  required BuildContext context,
  required VoidCallback onSupportTap,
  required VoidCallback onCancel,
  int countdownSeconds = 3,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (context) => RewardedAdBottomSheet(
      onSupportTap: onSupportTap,
      onCancel: onCancel,
      countdownSeconds: countdownSeconds,
    ),
  );
}