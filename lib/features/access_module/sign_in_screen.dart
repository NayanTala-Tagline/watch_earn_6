import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/access_module/provider/access_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/glow_box.dart';
import 'package:daily_cash/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => AccessProvider(), child: const _SignInBody());
  }
}

class _SignInBody extends StatelessWidget {
  const _SignInBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;
    final textColors = context.themeTextColors;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Assets.images.intro2.path))),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.w24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // App icon
                GlowBox(
                  borderRadius: AppDimens.r24,
                  child: Container(
                    width: AppDimens.w100,
                    height: AppDimens.w100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimens.r24),
                      border: Border.all(color: colors.secondaryGradient1.withValues(alpha: 0.4), width: 1.5),

                      image: DecorationImage(image: AssetImage(Assets.images.spinPrize.path), fit: BoxFit.cover),
                    ),
                  ),
                ),

                SizedBox(height: AppDimens.h24),

                // "EARN MONEY" heading
                Text(
                  context.l10n.dailyCash,
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontSize: AppDimens.sp32,
                    fontWeight: FontWeight.w700,
                    color: textColors.textColor,
                    letterSpacing: 2,
                  ),
                ),

                SizedBox(height: AppDimens.h8),

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
                  padding: EdgeInsets.all(AppDimens.w24),
                  decoration: BoxDecoration(
                    color: colors.surfaceColor,
                    borderRadius: BorderRadius.circular(AppDimens.r20),
                    border: Border.all(color: colors.primaryGradient1.withValues(alpha: 0.6), width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.welcome,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontSize: AppDimens.sp22,
                          fontWeight: FontWeight.w700,
                          color: textColors.textColor,
                        ),
                      ),

                      SizedBox(height: AppDimens.h6),

                      Text(
                        context.l10n.signInToAccessWallet,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: AppDimens.sp14,
                          color: textColors.descriptionColor,
                        ),
                      ),

                      SizedBox(height: AppDimens.h24),

                      // Google button
                      Consumer<AccessProvider>(
                        builder: (context, auth, _) => GlowBox(
                          child: GradientActionButton(
                            text: context.l10n.continueWithGoogle,
                            isLoading: auth.isGoogleLoading,
                            icon: auth.isGoogleLoading ? null : _GoogleMark(),
                            onPressed: auth.isGuestLoading ? null : () => _handleGoogle(context, auth),
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimens.h12),

                      // Guest button
                      Consumer<AccessProvider>(
                        builder: (context, auth, _) => GlowBox(
                          child: AppActionButton(
                            text: context.l10n.continueAsGuest,
                            isLoading: auth.isGuestLoading,
                            icon: auth.isGuestLoading
                                ? null
                                : Icon(
                                    Icons.person_outline_rounded,
                                    size: AppDimens.w20,
                                    color: textColors.descriptionColor,
                                  ),
                            isSolidButton: false,
                            buttonColor: Colors.transparent,
                            isInactive: auth.isGoogleLoading,
                            onPressed: auth.isGoogleLoading ? null : () => _handleGuest(context, auth),
                          ),
                        ),
                      ),

                      // Error message
                      Consumer<AccessProvider>(
                        builder: (context, auth, _) {
                          if (auth.errorMessage == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: AppDimens.h12),
                            child: Text(
                              auth.errorMessage!,
                              style: context.textTheme.bodySmall?.copyWith(color: Colors.red, fontSize: AppDimens.sp12),
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
                  padding: EdgeInsets.only(bottom: AppDimens.h16),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: context.textTheme.bodySmall?.copyWith(
                        fontSize: AppDimens.sp12,
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
        fontSize: AppDimens.sp12,
        letterSpacing: 2,
        color: context.themeTextColors.descriptionColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _diamond(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w6),
      child: Icon(Icons.diamond_outlined, size: AppDimens.w10, color: context.themeColors.secondaryGradient1),
    );
  }

  Future<void> _handleGoogle(BuildContext context, AccessProvider auth) async {
    final success = await auth.signInWithGoogle();
    if (success && context.mounted) {
      context.goNamed(AppRoutes.home);
    }
  }

  Future<void> _handleGuest(BuildContext context, AccessProvider auth) async {
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
class _GoogleMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.w20,
      height: AppDimens.w20,
      child: CustomPaint(painter: _GoogleGlyphPainter()),
    );
  }
}

class _GoogleGlyphPainter extends CustomPainter {
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
