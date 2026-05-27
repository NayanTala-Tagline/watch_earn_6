import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/language_module/provider/language_provider.dart';
import 'package:daily_cash/features/language_module/widgets/language_tile_widget.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
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
        NavigationHelper().handleBackPress(context);
      },
      child: Consumer<LanguageProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CommonAppBar(title: context.l10n.language),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.w20,
                  vertical: AppSize.h10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.selectLanguage,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.themeTextColors.descriptionColor,
                        fontSize: AppSize.sp16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: AppSize.h16),
                    Container(
                      decoration: BoxDecoration(
                        color: context.themeColors.surfaceColor,
                        borderRadius: BorderRadius.circular(AppSize.r14),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: LanguageProvider.supportedLanguages.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.1),
                          indent: AppSize.w16,
                          endIndent: AppSize.w16,
                        ),
                        itemBuilder: (context, index) {
                          final language = LanguageProvider.supportedLanguages[index];
                          final isSelected = provider.isSelected(language);
                          return LanguageTile(
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
