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

/// Onboarding Page 1 - Figma Node ID: 3:3
/// Title: "Congratulations!"
/// Description: "Welcome to Watch & Earn"
class Intro1 extends StatelessWidget {
  const Intro1({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IntroProvider(onboardingIndex: 1),
      child: Consumer<IntroProvider>(
        builder: (context, onboardingProvider, child) {
          final dataList = onboardingProvider.onboardingList[0];
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Assets.images.intro1.image(fit: BoxFit.cover),
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
                          decoration: BoxDecoration(color: Color(0xFFFF007B)),
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
                        PageDots(activePage: 0, pageTotal: 3),

                        SizedBox(height: AppDimens.h20),

                        if (onboardingProvider.nativeAd1?.adStatus == AdStatus.loaded ||
                            onboardingProvider.nativeAd1?.adStatus == AdStatus.loading)
                          SizedBox(
                            height: onboardingProvider.nativeAd1?.adData.templateType == TemplateType.medium
                                ? AppDimens.h330
                                : AppDimens.h150,
                            child: onboardingProvider.nativeAd1!.adWidget(),
                          ),

                        SizedBox(height: AppDimens.h10),

                        // Next Button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimens.w10),
                          child: GlowBox(
                            child: GradientActionButton(
                              isLoading: onboardingProvider.isLoading,
                              text: dataList.buttonText,
                              onPressed: () async {
                                await onboardingProvider.wait(
                                  onboardingProvider.nativeAd1!,
                                  onboardingProvider.interAd1!,
                                );
                                await onboardingProvider.interAd1?.show();
                                if (context.mounted) context.pushNamed(AppRoutes.onBoardring2);
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
