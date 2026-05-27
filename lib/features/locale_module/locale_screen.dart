import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/locale_module/provider/locale_provider.dart';
import 'package:daily_cash/features/locale_module/widgets/locale_tile.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocaleScreen extends StatefulWidget {
  const LocaleScreen({super.key});

  @override
  State<LocaleScreen> createState() => _LocaleScreenState();
}

class _LocaleScreenState extends State<LocaleScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'language_screen');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        RoutingHelper().handleBackPress(context);
      },
      child: Consumer<LocaleProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: SharedAppBar(title: context.l10n.language),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.w20,
                  vertical: AppDimens.h10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.selectLanguage,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.themeTextColors.descriptionColor,
                        fontSize: AppDimens.sp16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: AppDimens.h16),
                    Container(
                      decoration: BoxDecoration(
                        color: context.themeColors.surfaceColor,
                        borderRadius: BorderRadius.circular(AppDimens.r14),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: LocaleProvider.supportedLanguages.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.1),
                          indent: AppDimens.w16,
                          endIndent: AppDimens.w16,
                        ),
                        itemBuilder: (context, index) {
                          final language = LocaleProvider.supportedLanguages[index];
                          final isSelected = provider.isSelected(language);
                          return LocaleTile(
                            language: language,
                            isSelected: isSelected,
                            onTap: () {
                              provider.selectLanguage(language);
                              AnalyticsManager.instance.logEvent(
                                name: 'language_selected',
                                parameters: {'language': language.code},
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
