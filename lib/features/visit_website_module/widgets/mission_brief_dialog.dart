import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/visit_website_module/provider/visit_website_provider.dart';
import 'package:daily_cash/features/visit_website_module/widgets/mission_timer_overlay.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:daily_cash/widgets/ad_disclaimer_text.dart';
import 'package:daily_cash/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../gen/assets.gen.dart';

/// Shows the mission brief dialog for a specific website card.
/// Handles the full flow: brief → countdown → claim reward.
Future<void> showMissionBriefDialog(
  BuildContext context,
  String url,
  int cardIndex,
  VisitWebsiteProvider provider,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => ChangeNotifierProvider.value(
      value: provider,
      child: _MissionDialog(url: url, cardIndex: cardIndex),
    ),
  );
}

class _MissionDialog extends StatefulWidget {
  final String url;
  final int cardIndex;

  const _MissionDialog({required this.url, required this.cardIndex});

  @override
  State<_MissionDialog> createState() => _MissionDialogState();
}

class _MissionDialogState extends State<_MissionDialog>
    with WidgetsBindingObserver {
  final _overlay = MissionTimerOverlay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Listen to provider changes to detect external cancellation (WebView path)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VisitWebsiteProvider>().addListener(_onProviderChanged);
    });
  }

  void _onProviderChanged() {
    if (!mounted) return;
    final provider = context.read<VisitWebsiteProvider>();
    // Mission was cancelled externally (not running, not completed, not claimed)
    // → dismiss dialog silently
    if (!provider.isRunning(widget.cardIndex) &&
        !provider.isCompleted(widget.cardIndex) &&
        !provider.isClaimed(widget.cardIndex)) {
      // Only dismiss if we were previously in a started state
      // (i.e. the dialog was past the brief phase)
      if (_missionStarted) {
        _missionStarted = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => _safePop());
      }
    }
  }

  bool _missionStarted = false;
  bool _popped = false;

  void _safePop() {
    if (_popped || !mounted) return;
    _popped = true;
    Navigator.of(context).pop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // System browser path: app resumes → cancel if still running
    if (state != AppLifecycleState.resumed) return;
    if (!mounted) return;
    final provider = context.read<VisitWebsiteProvider>();
    if (provider.isRunning(widget.cardIndex)) {
      _overlay.hide();
      _safePop();
      provider.cancelMission(widget.cardIndex);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Safe removal — provider may already be disposed
    try {
      context.read<VisitWebsiteProvider>().removeListener(_onProviderChanged);
    } catch (_) {}
    _overlay.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider  = context.watch<VisitWebsiteProvider>();
    final running   = provider.isRunning(widget.cardIndex);
    final completed = provider.isCompleted(widget.cardIndex);
    final claimed   = provider.isClaimed(widget.cardIndex);

    // Mission is running — dialog should not be visible, dismiss immediately
    if (running) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _safePop());
      return const SizedBox.shrink();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        provider.cancelMission(widget.cardIndex);
        _overlay.hide();
        _safePop();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: AppSize.w20),
        child: Container(
          padding: EdgeInsets.all(AppSize.w24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.r20),
            gradient: LinearGradient(
              colors: [
                context.themeColors.secondaryGradient1.withValues(alpha: 0.85),
                context.themeColors.secondaryGradient2.withValues(alpha: 0.85),
                context.themeColors.surfaceColor.withValues(alpha: 0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.missionAward.image(
                height: AppSize.h80,
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppSize.h12),

              Text(
                'Mission Brief',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.themeTextColors.greenTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppSize.sp26,
                ),
              ),
              SizedBox(height: AppSize.h12),

              if (!running && !completed && !claimed) ...[
                Text(
                  'Stay on the page for ${RemoteConfigService.instance.websiteVisitTimer} seconds. A countdown timer will start after you tap "Start". Tap "Claim Reward" when the timer finishes!',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: AppSize.sp16,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: AppSize.h20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          provider.cancelMission(widget.cardIndex);
                          _safePop();
                        },
                        child: Container(
                          height: AppSize.h48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSize.r10),
                            border: Border.all(
                              color: context.themeColors.secondaryGradient4
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.themeTextColors.textColor,
                              fontWeight: FontWeight.w700,
                              fontSize: AppSize.sp16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.w16),
                    Expanded(
                      child: GradientButton(
                        text: 'Start',
                        onPressed: () {
                          _safePop();
                          provider.startMission(widget.cardIndex);
                          if (RemoteConfigService.instance.showInCustomWebview) {
                            context.pushNamed(
                              AppRoutes.inAppWebView,
                              extra: {
                                'url': widget.url,
                                'cardIndex': widget.cardIndex,
                                'provider': provider,
                              },
                            );
                          } else {
                            launchUrlString(
                              widget.url,
                              mode: LaunchMode.inAppBrowserView,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],

              // ── Phase: running — no content shown in dialog ─────────
              // (timer is shown in the WebView badge or system browser overlay)

              if (completed && !claimed) ...[
                Text(
                  'Great job! You stayed for ${RemoteConfigService.instance.websiteVisitTimer} seconds.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSize.sp16,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: AppSize.h8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.icons.tokens.svg(
                      width: AppSize.w24,
                      height: AppSize.h24,
                    ),
                    SizedBox(width: AppSize.w8),
                    Text(
                      '+${RemoteConfigService.instance.websiteRewardCoins} Coins',
                      strutStyle: StrutStyle(
                        fontSize: AppSize.sp20,
                        height: 1.1,
                        forceStrutHeight: true,
                      ),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.themeTextColors.greenTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSize.sp20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.h16),
                AdDisclaimerText(show: RewardAdService.isWebsiteRewardAdEnabled),
                GradientButton(
                  text: 'Claim Reward',
                  onPressed: () async {
                    _overlay.hide();
                    final rootCtx = rootNavKey.currentContext;
                    if (rootCtx == null || !rootCtx.mounted) return;
                    final success = await provider.claimReward(widget.cardIndex, rootCtx);
                    // Cancelled (user tapped Cancel on Support Us) → close dialog
                    if (!success) _safePop();
                    // On success, dialog stays open and transitions to claimed phase
                  },
                ),
              ],

              if (claimed) ...[
                Text(
                  'Reward claimed! Come back in ${RemoteConfigService.instance.websiteLockMinutes} minutes.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeColors.secondaryGradient3,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSize.sp16,
                  ),
                ),
                SizedBox(height: AppSize.h20),
                GradientButton(
                  text: 'Done',
                  onPressed: () {
                    _overlay.hide();
                    _safePop();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
