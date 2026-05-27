import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/locale_module/provider/locale_provider.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';
import 'provider/preference_provider.dart';
import 'widgets/custom_toggle.dart';
import 'widgets/preference_tile.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
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
        RoutingHelper().handleBackPress(context);
      },
      child: ChangeNotifierProvider(
        create: (context) => PreferenceProvider(),
        child: Consumer<PreferenceProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              appBar: SharedAppBar(title: context.l10n.settings),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w20, vertical: AppDimens.h10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.preferences,
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
                        child: Column(
                          children: [
                            PreferenceTile(
                              icon: Assets.icons.profileIcons.audio.svg(),
                              title: context.l10n.soundEffects,
                              subtitle: context.l10n.appSounds,
                              trailing: CustomToggle(
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
                              indent: AppDimens.w16,
                              endIndent: AppDimens.w16,
                            ),
                            PreferenceTile(
                              icon: Assets.icons.profileIcons.review.svg(),
                              title: context.l10n.hapticFeedback,
                              subtitle: context.l10n.vibrationOnTap,
                              trailing: CustomToggle(
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
                      SizedBox(height: AppDimens.h16),
                      Text(
                        context.l10n.language,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: context.themeTextColors.descriptionColor,
                          fontSize: AppDimens.sp16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: AppDimens.h5),
                      GestureDetector(
                        onTap: (){
                          context.pushNamed(AppRoutes.language);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.themeColors.surfaceColor,
                            borderRadius: BorderRadius.circular(AppDimens.r14),
                          ),
                          child: Column(
                            children: [
                              PreferenceTile(
                                icon: Assets.icons.profileIcons.audio.svg(),
                                title: context.l10n.language,
                                subtitle: context.watch<LocaleProvider>().selectedLanguageName,
                                trailing: Assets.icons.expandArrow.svg(
                                  height: AppDimens.h20,
                                  width: AppDimens.w20
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
