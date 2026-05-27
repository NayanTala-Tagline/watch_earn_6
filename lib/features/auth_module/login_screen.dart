import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/auth_module/provider/auth_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/glow_container.dart';
import 'package:daily_cash/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => AuthProvider(), child: const _LoginBody());
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;
    final textColors = context.themeTextColors;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Assets.images.onboarding2.path))),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.w24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // App icon
                GlowContainer(
                  borderRadius: AppSize.r24,
                  child: Container(
                    width: AppSize.w100,
                    height: AppSize.w100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.r24),
                      border: Border.all(color: colors.secondaryGradient1.withValues(alpha: 0.4), width: 1.5),

                      image: DecorationImage(image: AssetImage(Assets.images.spinReward.path), fit: BoxFit.cover),
                    ),
                  ),
                ),

                SizedBox(height: AppSize.h24),

                // "EARN MONEY" heading
                Text(
                  context.l10n.dailyCash,
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontSize: AppSize.sp32,
                    fontWeight: FontWeight.w700,
                    color: textColors.textColor,
                    letterSpacing: 2,
                  ),
                ),

                SizedBox(height: AppSize.h8),

                // "WATCH • EARN • PLAY" subtitle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _subtitleChip(context, context.l10n.watch),
                    _diamond(context),
                    _subtitleChip(context, context.l10n.earn),
                    _diamond(context),
                    _subtitleChip(context, context.l10n.play),
                  ],
                ),

                const Spacer(flex: 2),

                // Welcome card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSize.w24),
                  decoration: BoxDecoration(
                    color: colors.surfaceColor,
                    borderRadius: BorderRadius.circular(AppSize.r20),
                    border: Border.all(color: colors.primaryGradient1.withValues(alpha: 0.6), width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.welcome,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontSize: AppSize.sp22,
                          fontWeight: FontWeight.w700,
                          color: textColors.textColor,
                        ),
                      ),

                      SizedBox(height: AppSize.h6),

                      Text(
                        context.l10n.signInToAccessWallet,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: AppSize.sp14,
                          color: textColors.descriptionColor,
                        ),
                      ),

                      SizedBox(height: AppSize.h24),

                      // Google button
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) => GlowContainer(
                          child: GradientButton(
                            text: context.l10n.continueWithGoogle,
                            isLoading: auth.isGoogleLoading,
                            icon: auth.isGoogleLoading ? null : _GoogleIcon(),
                            onPressed: auth.isGuestLoading ? null : () => _handleGoogle(context, auth),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSize.h12),

                      // Guest button
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) => GlowContainer(
                          child: AppButton(
                            text: context.l10n.continueAsGuest,
                            isLoading: auth.isGuestLoading,
                            icon: auth.isGuestLoading
                                ? null
                                : Icon(
                                    Icons.person_outline_rounded,
                                    size: AppSize.w20,
                                    color: textColors.descriptionColor,
                                  ),
                            isFillButton: false,
                            buttonColor: Colors.transparent,
                            isDisabled: auth.isGoogleLoading,
                            onPressed: auth.isGoogleLoading ? null : () => _handleGuest(context, auth),
                          ),
                        ),
                      ),

                      // Error message
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          if (auth.errorMessage == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: AppSize.h12),
                            child: Text(
                              auth.errorMessage!,
                              style: context.textTheme.bodySmall?.copyWith(color: Colors.red, fontSize: AppSize.sp12),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Terms & Privacy Policy
                Padding(
                  padding: EdgeInsets.only(bottom: AppSize.h16),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: AppSize.sp12,
                        color: textColors.descriptionColor,
                      ),
                      children: [
                        TextSpan(text: context.l10n.byContYouAgree),
                        TextSpan(
                          text: context.l10n.terms,
                          style: TextStyle(
                            color: colors.secondaryGradient4,
                            decoration: TextDecoration.underline,
                            decorationColor: colors.secondaryGradient4,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl('https://example.com/terms'),
                        ),
                        TextSpan(text: context.l10n.andSymbol),
                        TextSpan(
                          text: context.l10n.privacyPolicy,
                          style: TextStyle(
                            color: colors.secondaryGradient4,
                            decoration: TextDecoration.underline,
                            decorationColor: colors.secondaryGradient4,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl('https://example.com/privacy'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _subtitleChip(BuildContext context, String text) {
    return Text(
      text,
      style: context.textTheme.bodySmall?.copyWith(
        fontSize: AppSize.sp12,
        letterSpacing: 2,
        color: context.themeTextColors.descriptionColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _diamond(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.w6),
      child: Icon(Icons.diamond_outlined, size: AppSize.w10, color: context.themeColors.secondaryGradient1),
    );
  }

  Future<void> _handleGoogle(BuildContext context, AuthProvider auth) async {
    final success = await auth.signInWithGoogle();
    if (success && context.mounted) {
      context.goNamed(AppRoutes.home);
    }
  }

  Future<void> _handleGuest(BuildContext context, AuthProvider auth) async {
    final success = await auth.continueAsGuest();
    if (success && context.mounted) {
      context.goNamed(AppRoutes.home);
    }
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}

/// Simple Google "G" icon rendered with canvas
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.w20,
      height: AppSize.w20,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // White circle background
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    // Draw a simplified "G" text
    final tp = TextPainter(
      text: TextSpan(
        text: 'G',
        style: TextStyle(
          color: const Color(0xFF4285F4),
          fontSize: size.width * 0.65,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
