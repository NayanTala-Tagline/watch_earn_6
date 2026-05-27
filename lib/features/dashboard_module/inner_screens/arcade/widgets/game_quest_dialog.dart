import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/arcade/provider/arcade_provider.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:daily_cash/widgets/ad_notice_text.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../gen/assets.gen.dart';

Future<void> showGameMissionDialog(
  BuildContext context,
  String url,
  int cardIndex,
  ArcadeProvider provider,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => ChangeNotifierProvider.value(
      value: provider,
      child: _GameQuestDialog(url: url, cardIndex: cardIndex),
    ),
  );
}

class _GameQuestDialog extends StatefulWidget {
  final String url;
  final int cardIndex;
  const _GameQuestDialog({required this.url, required this.cardIndex});

  @override
  State<_GameQuestDialog> createState() => _GameQuestDialogState();
}

class _GameQuestDialogState extends State<_GameQuestDialog>
    with WidgetsBindingObserver {

  bool _popped = false;

  void _safePop() {
    if (_popped || !mounted) return;
    _popped = true;
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!mounted) return;
    final provider = context.read<ArcadeProvider>();
    if (provider.isRunning(widget.cardIndex)) {
      _safePop();
      provider.cancelMission(widget.cardIndex);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider  = context.watch<ArcadeProvider>();
    final running   = provider.isRunning(widget.cardIndex);
    final completed = provider.isCompleted(widget.cardIndex);
    final claimed   = provider.isClaimed(widget.cardIndex);

    if (running) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _safePop());
      return const SizedBox.shrink();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        provider.cancelMission(widget.cardIndex);
        _safePop();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
        child: Container(
          padding: EdgeInsets.all(AppDimens.w24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.r20),
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
                height: AppDimens.h80,
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppDimens.h12),
              Text(
                'Mission Brief',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.themeTextColors.greenTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.sp26,
                ),
              ),
              SizedBox(height: AppDimens.h12),

              // ── Brief phase ──────────────────────────────────────────
              if (!running && !completed && !claimed) ...[
                Text(
                  'Play the game for ${RemoteSettingsService.instance.playGameVisitTimer} seconds. A countdown timer will start after you tap "Start". Tap "Claim Reward" when the timer finishes!',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: AppDimens.sp16,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: AppDimens.h20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          provider.cancelMission(widget.cardIndex);
                          _safePop();
                        },
                        child: Container(
                          height: AppDimens.h48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppDimens.r10),
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
                              fontSize: AppDimens.sp16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.w16),
                    Expanded(
                      child: GradientActionButton(
                        text: 'Start',
                        onPressed: () {
                          _safePop();
                          provider.startMission(widget.cardIndex);
                          if (RemoteSettingsService.instance.showGameInCustomWebview) {
                            context.pushNamed(
                              AppRoutes.inAppGameView,
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

              // ── Completed phase ──────────────────────────────────────
              if (completed && !claimed) ...[
                Text(
                  'Great job! You played for ${RemoteSettingsService.instance.playGameVisitTimer} seconds.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimens.sp16,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: AppDimens.h8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.icons.tokens.svg(
                      width: AppDimens.w24,
                      height: AppDimens.h24,
                    ),
                    SizedBox(width: AppDimens.w8),
                    Text(
                      '+${RemoteSettingsService.instance.playGameRewardCoins} Coins',
                      strutStyle: StrutStyle(
                        fontSize: AppDimens.sp20,
                        height: 1.1,
                        forceStrutHeight: true,
                      ),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.themeTextColors.greenTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimens.sp20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.h16),
                AdNoticeText(show: RewardAdService.isPlayGameRewardAdEnabled),
                GradientActionButton(
                  text: 'Claim Reward',
                  onPressed: () async {
                    final rootCtx = rootNavKey.currentContext;
                    if (rootCtx == null || !rootCtx.mounted) return;
                    final success = await provider.claimReward(widget.cardIndex, rootCtx);
                    if (!success) _safePop();
                  },
                ),
              ],

              // ── Claimed phase ────────────────────────────────────────
              if (claimed) ...[
                Text(
                  'Reward claimed! Come back in ${RemoteSettingsService.instance.playGameLockMinutes} minutes.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.blueTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimens.sp16,
                  ),
                ),
                SizedBox(height: AppDimens.h20),
                GradientActionButton(
                  text: 'Done',
                  onPressed: _safePop,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
