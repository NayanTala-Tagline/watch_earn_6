import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:flutter/material.dart';


class AccountOptionTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  const AccountOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;
    
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: AppDimens.h18),
        child: Row(
          children: [
            Container(
              width: AppDimens.w40,
              height: AppDimens.w40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColors.primaryGradient2, themeColors.primaryGradient1],
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimens.r10),
              ),
              alignment: Alignment.center,
              child: icon,
            ),

            SizedBox(width: AppDimens.w16),

            // Title
            Expanded(
              child: Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.sp16,
                ),
              ),
            ),

            GlowBox(
              strokeWith: 1,
              highlight: Colors.white,
              borderRadius: 100,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Icons.navigate_next_rounded, size: AppDimens.sp18),
              ))
          ],
        ),
      ),
    );
  }
}
