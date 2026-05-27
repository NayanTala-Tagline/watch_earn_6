import 'package:flutter/material.dart';
import '../../../extension/ext_context.dart';
import '../../../utils/app_size.dart';
import '../model/language_model.dart';

class LanguageTile extends StatelessWidget {
  final LanguageModel language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.r14),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.h16,
          horizontal: AppSize.w16,
        ),
        child: Row(
          spacing: AppSize.w12,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    language.name,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.themeTextColors.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: AppSize.sp16,
                    ),
                  ),
                  SizedBox(height: AppSize.h4),
                  Text(
                    language.nativeName,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.themeTextColors.descriptionColor,
                      fontWeight: FontWeight.w400,
                      fontSize: AppSize.sp14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.themeColors.secondaryGradient2,
                size: AppSize.r20,
              ),
          ],
        ),
      ),
    );
  }
}
