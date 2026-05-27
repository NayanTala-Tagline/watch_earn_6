import 'package:flutter/material.dart';
import '../../../extension/ext_context.dart';
import '../../../utils/app_dimens.dart';
import '../model/locale_model.dart';

class LocaleTile extends StatelessWidget {
  final LocaleModel language;
  final bool isSelected;
  final VoidCallback onTap;

  const LocaleTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.r14),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.h16,
          horizontal: AppDimens.w16,
        ),
        child: Row(
          spacing: AppDimens.w12,
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
                      fontSize: AppDimens.sp16,
                    ),
                  ),
                  SizedBox(height: AppDimens.h4),
                  Text(
                    language.nativeName,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.themeTextColors.descriptionColor,
                      fontWeight: FontWeight.w400,
                      fontSize: AppDimens.sp14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.themeColors.secondaryGradient2,
                size: AppDimens.r20,
              ),
          ],
        ),
      ),
    );
  }
}
