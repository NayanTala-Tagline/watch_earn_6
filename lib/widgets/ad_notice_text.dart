import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:flutter/material.dart';

/// Shows italic "This section may contain ads" text only when [show] is true.
/// Drop this above any Claim Reward button that may show a rewarded ad.
class AdNoticeText extends StatelessWidget {
  final bool show;

  const AdNoticeText({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.h8),
      child: Text(
        'This section may contain ads',
        textAlign: TextAlign.center,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.themeTextColors.descriptionColor,
          fontSize: AppDimens.sp12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
