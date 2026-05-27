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

/// Onboarding Page 3 - Figma Node ID: 3:127
/// Title: "The longer you watch - the more you earn"
/// Button: "Get Started" (final page)
class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingProvider(onboardingIndex: 3),
      child: Consumer<OnboardingProvider>(
        builder: (context, onboardingProvider, child) {
          final dataList = onboardingProvider.onboardingList[2];
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Assets.images.onboarding3.image(fit: BoxFit.cover),
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
                          decoration: BoxDecoration(color: Color(0xFF00FFE1)),
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
                        PageIndicator(currentPage: 2, pageCount: 3),

                        SizedBox(height: AppSize.h20),

                        if (onboardingProvider.nativeAd3?.adStatus == AdStatus.loaded ||
                            onboardingProvider.nativeAd3?.adStatus == AdStatus.loading)
                          SizedBox(
                            height: onboardingProvider.nativeAd3?.adData.templateType == TemplateType.medium
                                ? AppSize.h330
                                : AppSize.h150,
                            child: onboardingProvider.nativeAd3!.adWidget(),
                          ),

                        SizedBox(height: AppSize.h10),

                        // Get Started Button (final page)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSize.w10),
                          child: GlowContainer(
                            child: GradientButton(
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
