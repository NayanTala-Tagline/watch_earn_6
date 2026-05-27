import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/help_module/provider/help_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/app_input_field.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;

    return ChangeNotifierProvider(
      create: (_) => HelpProvider(),
      child: Consumer<HelpProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: themeColors.backgroundColor,
            appBar: SharedAppBar(title: context.l10n.support),
            body: SafeArea(
              child: Form(
                key: provider.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.w20,
                    vertical: AppDimens.h16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopBanner(),
                      SizedBox(height: AppDimens.h24),
                      _InputLabel(text: context.l10n.title),
                      SizedBox(height: AppDimens.h8),
                      AppInputField(
                        controller: provider.titleController,
                        keyboardType: TextInputType.text,
                        cursorColor: themeColors.secondaryGradient4,
                        hintText: context.l10n.brieflyDescribeIssue,
                        fillColor: themeColors.surfaceColor,
                        maxChars: 100,
                        actionLabel: TextInputAction.next,
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
                          fontSize: AppDimens.sp14,
                          fontWeight: FontWeight.w400,
                        ),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.themeTextColors.textColor,
                          fontSize: AppDimens.sp15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppDimens.h20),
                      _InputLabel(text: context.l10n.description),
                      SizedBox(height: AppDimens.h8),
                      AppInputField(
                        controller: provider.descriptionController,
                        keyboardType: TextInputType.multiline,
                        cursorColor: themeColors.secondaryGradient4,
                        hintText: context.l10n.tellUsMore,
                        fillColor: themeColors.surfaceColor,
                        minLine: 5,
                        maxLine: 8,
                        maxChars: 1000,
                        textAlignVertical: TextAlignVertical.top,
                        bodyHeight: AppDimens.h14,
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
                          fontSize: AppDimens.sp14,
                          fontWeight: FontWeight.w400,
                        ),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.themeTextColors.textColor,
                          fontSize: AppDimens.sp15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppDimens.h28),
                      GradientActionButton(
                        text: context.l10n.submitRequest,
                        isLoading: provider.isSubmitting,
                        height: AppDimens.h54,
                        borderRadius: AppDimens.r14,
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
                          fontSize: AppDimens.sp16,
                        ),
                        onPressed: () async {
                          final ok = await provider.submit();
                          if (ok && context.mounted) {
                            context.pop();
                          }
                        },
                      ),
                      SizedBox(height: AppDimens.h16),
                      _HelpNote(),
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

class _TopBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.w16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.r16),
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
            width: AppDimens.w48,
            height: AppDimens.w48,
            decoration: BoxDecoration(
              color: themeColors.secondaryGradient2.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimens.r12),
            ),
            alignment: Alignment.center,
            child: Assets.icons.profileIcons.help.svg(
              width: AppDimens.w24,
              height: AppDimens.w24,
            ),
          ),
          SizedBox(width: AppDimens.w14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.howCanWeHelp,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppDimens.sp18,
                  ),
                ),
                SizedBox(height: AppDimens.h4),
                Text(
                  context.l10n.supportSubtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontWeight: FontWeight.w400,
                    fontSize: AppDimens.sp13,
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

class _InputLabel extends StatelessWidget {
  final String text;
  const _InputLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppDimens.w6),
      child: Text(
        text,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.themeTextColors.textColor,
          fontWeight: FontWeight.w600,
          fontSize: AppDimens.sp14,
        ),
      ),
    );
  }
}

class _HelpNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: AppDimens.w16,
          color: context.themeTextColors.descriptionColor,
        ),
        SizedBox(width: AppDimens.w8),
        Expanded(
          child: Text(
            context.l10n.supportNote,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.themeTextColors.descriptionColor,
              fontSize: AppDimens.sp12,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
