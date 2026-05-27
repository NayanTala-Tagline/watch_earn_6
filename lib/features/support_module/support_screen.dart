import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/support_module/provider/support_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/app_textfield.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:daily_cash/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;

    return ChangeNotifierProvider(
      create: (_) => SupportProvider(),
      child: Consumer<SupportProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: themeColors.backgroundColor,
            appBar: CommonAppBar(title: context.l10n.support),
            body: SafeArea(
              child: Form(
                key: provider.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.w20,
                    vertical: AppSize.h16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(),
                      SizedBox(height: AppSize.h24),
                      _FieldLabel(text: context.l10n.title),
                      SizedBox(height: AppSize.h8),
                      AppTextFormField(
                        controller: provider.titleController,
                        keyboardType: TextInputType.text,
                        cursorColor: themeColors.secondaryGradient4,
                        hintText: context.l10n.brieflyDescribeIssue,
                        fillColor: themeColors.surfaceColor,
                        maxTextLength: 100,
                        textAction: TextInputAction.next,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return context.l10n.pleaseEnterTitle;
                          }
                          if (val.trim().length < 3) {
                            return context.l10n.titleTooShort;
                          }
                          return null;
                        },
                        hintStyle: context.textTheme.bodyMedium?.copyWith(
                          color: context.themeTextColors.descriptionColor,
                          fontSize: AppSize.sp14,
                          fontWeight: FontWeight.w400,
                        ),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.themeTextColors.textColor,
                          fontSize: AppSize.sp15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSize.h20),
                      _FieldLabel(text: context.l10n.description),
                      SizedBox(height: AppSize.h8),
                      AppTextFormField(
                        controller: provider.descriptionController,
                        keyboardType: TextInputType.multiline,
                        cursorColor: themeColors.secondaryGradient4,
                        hintText: context.l10n.tellUsMore,
                        fillColor: themeColors.surfaceColor,
                        minLine: 5,
                        maxLine: 8,
                        maxTextLength: 1000,
                        textAlignVertical: TextAlignVertical.top,
                        contentHeight: AppSize.h14,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return context.l10n.pleaseEnterDescription;
                          }
                          if (val.trim().length < 10) {
                            return context.l10n.pleaseProvideMoreDetail;
                          }
                          return null;
                        },
                        hintStyle: context.textTheme.bodyMedium?.copyWith(
                          color: context.themeTextColors.descriptionColor,
                          fontSize: AppSize.sp14,
                          fontWeight: FontWeight.w400,
                        ),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.themeTextColors.textColor,
                          fontSize: AppSize.sp15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSize.h28),
                      GradientButton(
                        text: context.l10n.submitRequest,
                        isLoading: provider.isSubmitting,
                        height: AppSize.h54,
                        borderRadius: AppSize.r14,
                        gradient: LinearGradient(
                          colors: [
                            themeColors.secondaryGradient3,
                            themeColors.secondaryGradient4,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        textStyle: context.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppSize.sp16,
                        ),
                        onPressed: () async {
                          final ok = await provider.submit();
                          if (ok && context.mounted) {
                            context.pop();
                          }
                        },
                      ),
                      SizedBox(height: AppSize.h16),
                      _SupportNote(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.w16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.r16),
        gradient: LinearGradient(
          colors: [
            themeColors.primaryGradient1.withValues(alpha: 0.4),
            themeColors.primaryGradient2.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: themeColors.primaryGradient2.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSize.w48,
            height: AppSize.w48,
            decoration: BoxDecoration(
              color: themeColors.secondaryGradient2.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSize.r12),
            ),
            alignment: Alignment.center,
            child: Assets.icons.profileIcons.support.svg(
              width: AppSize.w24,
              height: AppSize.w24,
            ),
          ),
          SizedBox(width: AppSize.w14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.howCanWeHelp,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.sp18,
                  ),
                ),
                SizedBox(height: AppSize.h4),
                Text(
                  context.l10n.supportSubtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontWeight: FontWeight.w400,
                    fontSize: AppSize.sp13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSize.w6),
      child: Text(
        text,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.themeTextColors.textColor,
          fontWeight: FontWeight.w600,
          fontSize: AppSize.sp14,
        ),
      ),
    );
  }
}

class _SupportNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: AppSize.w16,
          color: context.themeTextColors.descriptionColor,
        ),
        SizedBox(width: AppSize.w8),
        Expanded(
          child: Text(
            context.l10n.supportNote,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.themeTextColors.descriptionColor,
              fontSize: AppSize.sp12,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
