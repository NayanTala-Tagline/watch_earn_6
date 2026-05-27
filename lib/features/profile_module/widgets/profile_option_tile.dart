import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:flutter/material.dart';


class ProfileOptionTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileOptionTile({
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
        padding: EdgeInsets.only(bottom: AppSize.h18),
        child: Row(
          children: [
            Container(
              width: AppSize.w40,
              height: AppSize.w40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColors.primaryGradient2, themeColors.primaryGradient1],
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSize.r10),
              ),
              alignment: Alignment.center,
              child: icon,
            ),

            SizedBox(width: AppSize.w16),

            // Title
            Expanded(
              child: Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppSize.sp16,
                ),
              ),
            ),

            GlowContainer(
              strokeWith: 1,
              accent: Colors.white,
              borderRadius: 100,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Icons.navigate_next_rounded, size: AppSize.sp18),
              ))
          ],
        ),
      ),
    );
  }
}
