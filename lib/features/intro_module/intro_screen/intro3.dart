import 'package:ad_manager/ad_manager.dart';
import 'package:ad_manager/enum/ad_status.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/intro_module/intro_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:daily_cash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Onboarding Page 3 - Figma Node ID: 3:127
/// Title: "The longer you watch - the more you earn"
/// Button: "Get Started" (final page)
class Intro3 extends StatelessWidget {
  const Intro3({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IntroProvider(onboardingIndex: 3),
      child: Consumer<IntroProvider>(
        builder: (context, onboardingProvider, child) {
          final dataList = onboardingProvider.onboardingList[2];
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Assets.images.intro3.image(fit: BoxFit.cover),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
                    child: Column(
                      children: [
                        SizedBox(height: AppDimens.h50),

                        // Title
                        Text(
                          dataList.title,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimens.sp28,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: AppDimens.h4),

                        Container(
                          height: AppDimens.h2,
                          width: context.width / 2.5,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                        SizedBox(height: AppDimens.h4),
                        Container(
                          height: AppDimens.h2,
                          width: context.width / 3.5,
                          decoration: BoxDecoration(color: Color(0xFF00FFE1)),
                        ),

                        SizedBox(height: AppDimens.h30),

                        // Description
                        if (dataList.description != null)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
                            child: Text(
                              dataList.description!,
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: AppDimens.sp18,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        // Image
                        Expanded(child: Center(child: dataList.image)),

                        // Page dots
                        PageDots(activePage: 2, pageTotal: 3),

                        SizedBox(height: AppDimens.h20),

                        if (onboardingProvider.nativeAd3?.adStatus == AdStatus.loaded ||
                            onboardingProvider.nativeAd3?.adStatus == AdStatus.loading)
                          SizedBox(
                            height: onboardingProvider.nativeAd3?.adData.templateType == TemplateType.medium
                                ? AppDimens.h330
                                : AppDimens.h150,
                            child: onboardingProvider.nativeAd3!.adWidget(),
                          ),

                        SizedBox(height: AppDimens.h10),

                        // Get Started Button (final page)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimens.w10),
                          child: GlowBox(
                            child: GradientActionButton(
                              isLoading: onboardingProvider.isLoading,
                              text: dataList.buttonText,
                              onPressed: () async {
                                await onboardingProvider.wait(
                                  onboardingProvider.nativeAd3!,
                                  onboardingProvider.interAd3!,
                                );
                                await onboardingProvider.interAd3?.show();
                                if (context.mounted) context.pushNamed(AppRoutes.login);
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: AppDimens.h50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
