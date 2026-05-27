import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/language_module/provider/language_provider.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';
import 'provider/setting_provider.dart';
import 'widgets/custom_switch.dart';
import 'widgets/setting_tile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'setting_screen');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        NavigationHelper().handleBackPress(context);
      },
      child: ChangeNotifierProvider(
        create: (context) => SettingProvider(),
        child: Consumer<SettingProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              appBar: CommonAppBar(title: context.l10n.settings),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.w20, vertical: AppSize.h10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.preferences,
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
                        child: Column(
                          children: [
                            SettingTile(
                              icon: Assets.icons.profileIcons.sound.svg(),
                              title: context.l10n.soundEffects,
                              subtitle: context.l10n.appSounds,
                              trailing: CustomSwitch(
                                value: provider.soundEffects,
                                onChanged: (value) {
                                  provider.toggleSoundEffects(value);
                                  AnalyticsManager.instance.logEvent(
                                    name: 'sound_effects_toggled',
                                    parameters: {'enabled': value},
                                  );
                                },
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.1),
                              indent: AppSize.w16,
                              endIndent: AppSize.w16,
                            ),
                            SettingTile(
                              icon: Assets.icons.profileIcons.feedback.svg(),
                              title: context.l10n.hapticFeedback,
                              subtitle: context.l10n.vibrationOnTap,
                              trailing: CustomSwitch(
                                value: provider.hapticFeedback,
                                onChanged: (value) {
                                  provider.toggleHapticFeedback(value);
                                  AnalyticsManager.instance.logEvent(
                                    name: 'haptic_feedback_toggled',
                                    parameters: {'enabled': value},
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.h16),
                      Text(
                        context.l10n.language,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.themeTextColors.descriptionColor,
                          fontSize: AppSize.sp16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: AppSize.h5),
                      GestureDetector(
                        onTap: (){
                          context.pushNamed(AppRoutes.language);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.themeColors.surfaceColor,
                            borderRadius: BorderRadius.circular(AppSize.r14),
                          ),
                          child: Column(
                            children: [
                              SettingTile(
                                icon: Assets.icons.profileIcons.sound.svg(),
                                title: context.l10n.language,
                                subtitle: context.watch<LanguageProvider>().selectedLanguageName,
                                trailing: Assets.icons.openArrow.svg(
                                  height: AppSize.h20,
                                  width: AppSize.w20
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
