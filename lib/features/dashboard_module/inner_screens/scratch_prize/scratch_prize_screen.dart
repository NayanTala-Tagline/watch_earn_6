import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:confetti/confetti.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/scratch_prize/provider/scratch_prize_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/services/reward_ad_service.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/ad_notice_text.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:daily_cash/widgets/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

/// Scratch & Win Screen — High-fidelity UI with realistic scratching and victory confetti.
class ScratchPrizeScreen extends StatelessWidget {
  const ScratchPrizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ScratchPrizeProvider(), child: const _ScratchPrizeContent());
  }
}

class _ScratchPrizeContent extends StatefulWidget {
  const _ScratchPrizeContent();

  @override
  State<_ScratchPrizeContent> createState() => _ScratchPrizeContentState();
}

class _ScratchPrizeContentState extends State<_ScratchPrizeContent> {
  late ConfettiController _confettiController;
  final GlobalKey<ScratcherState> _scratchKey = GlobalKey<ScratcherState>();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    AnalyticsManager.instance.logScreenView(screenName: 'scratch_win_screen');
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScratchPrizeProvider>();
    final themeColors = context.themeColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        RoutingHelper().handleBackPress(context);
      },
      child: Scaffold(
      backgroundColor: themeColors.backgroundColor,
      appBar: SharedAppBar(title: 'Scratch & Win', actions: [_buildCoinBadge(context)]),
      body: Stack(
        alignment: Alignment.center, // Change alignment to center
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
              child: Column(
                children: [
                  SizedBox(height: AppDimens.h20),

                  _buildSubHeader(context),

                  // ─── Centered Interactive Content ──────────────────────────────────────
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildScratchCard(context, provider),

                          SizedBox(height: AppDimens.h24),

                          Text(
                            provider.isScratched ? "You Found Coins!" : "Scratch the card and win rewards",
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.themeTextColors.textColor,
                              fontSize: AppDimens.sp16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          SizedBox(height: AppDimens.h40),

                          // Disclaimer — only when scratched, not yet claimed, and ad is enabled
                          AdNoticeText(
                            show: provider.isScratched &&
                                !provider.isClaimed &&
                                RewardAdService.isScratchCardAdEnabled,
                          ),

                          GradientActionButton(
                            text: 'Claim Rewards',
                            onPressed: provider.isClaimed
                                ? null
                                : !provider.isScratched
                                    ? () => 'Scratch the card first to claim your reward!'
                                        .showInfoAlert()
                                    : () => _onClaim(context, provider),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppDimens.h30),
                ],
              ),
            ),
          ),

          // Confetti Overlay (Now centered)
          _buildConfettiOverlay(),
        ],
      ),
    ),
    );
  }

  Widget _buildSubHeader(BuildContext context) {
    final themeColors = context.themeColors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: themeColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimens.r14 + 1.2),
      ),
      padding: const EdgeInsets.all(1.2),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.w16, vertical: AppDimens.h12),
        decoration: BoxDecoration(color: themeColors.backgroundColor, borderRadius: BorderRadius.circular(AppDimens.r14)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Scratch to Reveal',
                strutStyle: StrutStyle(fontSize: AppDimens.sp16, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppDimens.sp16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: AppDimens.w10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w10, vertical: AppDimens.h5),
              decoration: BoxDecoration(color: context.themeTextColors.blueTextColor, borderRadius: BorderRadius.circular(AppDimens.r10)),
              child: Text(
                'Win 20-30 Coins',
                strutStyle: StrutStyle(fontSize: AppDimens.sp16, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.labelMedium?.copyWith(
                  color: Colors.black,
                  fontSize: AppDimens.sp16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScratchCard(BuildContext context, ScratchPrizeProvider provider) {
    return Container(
      width: AppDimens.w300,
      height: AppDimens.w300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.r24),
        boxShadow: [
          BoxShadow(color: context.themeColors.primary.withValues(alpha: 0.15), blurRadius: 30, spreadRadius: 5),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.r24),
        child: Scratcher(
          key: _scratchKey,
          brushSize: 45,
          threshold: 45,
          image: Assets.images.spinPrize.image(),
          onThreshold: () {
            _confettiController.play();
            provider.updateProgress(50.0);
            AnalyticsManager.instance.logEvent(name: 'scratch_card_revealed');
          },
          onChange: (p) => provider.updateProgress(p),
          child: Container(
            color: const Color(0xFF1E1B3D), // Results background
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${provider.reward}",
                  style: context.textTheme.displayMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: AppDimens.sp64,
                  ),
                ),
                Text(
                  "You Found Coins",
                  style: context.textTheme.bodyLarge?.copyWith(color: Colors.white70, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiOverlay() {
    return ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: false,
      colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
      numberOfParticles: 20,
      gravity: 0.1,
    );
  }

  Widget _buildCoinBadge(BuildContext context) {
    return StreamBuilder(
      stream: Injector.instance<AppDB>().userListenable(),
      builder: (context, _) {
        final coins = Injector.instance<AppDB>().userModel?.coin.toInt() ?? 0;
        return Container(
          margin: EdgeInsets.only(right: AppDimens.w10),
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w12, vertical: AppDimens.h6),
          decoration: BoxDecoration(
            color: context.themeColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppDimens.r12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icons.tokens.svg(height: AppDimens.h20, width: AppDimens.w20),
              SizedBox(width: AppDimens.w6),
              Text(
                '$coins',
                strutStyle: StrutStyle(fontSize: AppDimens.sp20, height: 1.1, forceStrutHeight: true),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.sp20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onClaim(BuildContext context, ScratchPrizeProvider provider) async {
    final earnedCoins = await RewardAdService.showScratchCard(context, defaultCoins: provider.reward);
    if (earnedCoins == null) return;
    await provider.claimReward(earnedCoins: earnedCoins);
    AnalyticsManager.instance.logEvent(
      name: 'scratch_reward_claimed',
      parameters: {'coins': earnedCoins},
    );
    if (context.mounted) _showSuccessDialog(context, provider, earnedCoins);
  }

  void _showSuccessDialog(BuildContext context, ScratchPrizeProvider provider, int coins) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.themeColors.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Congratulations!',
          style: context.textTheme.bodyLarge?.copyWith(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        content: Text('You claimed $coins coins successfully!', textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.resetGame();
              _scratchKey.currentState?.reset();
            },
            child: Text(
              'Try Again',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontSize: AppDimens.sp16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
