import 'package:ad_manager/ad_manager.dart';
import 'package:ad_manager/enum/ad_status.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/onboarding_module/onboarding_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:daily_cash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Onboarding Page 1 - Figma Node ID: 3:3
/// Title: "Congratulations!"
/// Description: "Welcome to Watch & Earn"
class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingProvider(onboardingIndex: 1),
      child: Consumer<OnboardingProvider>(
        builder: (context, onboardingProvider, child) {
          final dataList = onboardingProvider.onboardingList[0];
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Assets.images.onboarding1.image(fit: BoxFit.cover),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.w20),
                    child: Column(
                      children: [
                        SizedBox(height: AppSize.h50),

                        // Title
                        Text(
                          dataList.title,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.sp28,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: AppSize.h4),

                        Container(
                          height: AppSize.h2,
                          width: context.width / 2.5,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                        SizedBox(height: AppSize.h4),
                        Container(
                          height: AppSize.h2,
                          width: context.width / 3.5,
                          decoration: BoxDecoration(color: Color(0xFFFF007B)),
                        ),

                        SizedBox(height: AppSize.h30),

                        // Description
                        if (dataList.description != null)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSize.w20),
                            child: Text(
                              dataList.description!,
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: AppSize.sp18,
                                color: Colors.white70,
                              ),
                            ),
                          ),

                        // Image
                        Expanded(child: Center(child: dataList.image)),

                        // Page dots
                        PageIndicator(currentPage: 0, pageCount: 3),

                        SizedBox(height: AppSize.h20),

                        if (onboardingProvider.nativeAd1?.adStatus == AdStatus.loaded ||
                            onboardingProvider.nativeAd1?.adStatus == AdStatus.loading)
                          SizedBox(
                            height: onboardingProvider.nativeAd1?.adData.templateType == TemplateType.medium
                                ? AppSize.h330
                                : AppSize.h150,
                            child: onboardingProvider.nativeAd1!.adWidget(),
                          ),

                        SizedBox(height: AppSize.h10),

                        // Next Button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSize.w10),
                          child: GlowContainer(
                            child: GradientButton(
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

                        SizedBox(height: AppSize.h50),
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
