import 'dart:async';
import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/arcade/provider/arcade_provider.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/arcade/widgets/game_tile_card.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/arcade/widgets/game_quest_dialog.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArcadeScreen extends StatefulWidget {
  const ArcadeScreen({super.key});

  @override
  State<ArcadeScreen> createState() => _ArcadeScreenState();
}

class _ArcadeScreenState extends State<ArcadeScreen>
    with WidgetsBindingObserver {
  Timer? _lockRefreshTimer;
  late final ArcadeProvider _provider;
  final Set<int> _pendingClaimDialog = {};
  final Set<int> _activeClaimDialog = {};

  @override
  void initState() {
    super.initState();
    _provider = ArcadeProvider();
    WidgetsBinding.instance.addObserver(this);
    AnalyticsManager.instance.logScreenView(screenName: 'play_game_screen');
    _lockRefreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) { if (mounted) setState(() {}); },
    );
    _provider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    if (!mounted) return;
    for (int i = 0; i < _provider.gamesUrl.length; i++) {
      if (_provider.isCompleted(i) && !_provider.isClaimed(i) && !_provider.isRunning(i)) {
        if (_pendingClaimDialog.contains(i) || _activeClaimDialog.contains(i)) continue;
        _pendingClaimDialog.add(i);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pendingClaimDialog.remove(i);
          if (mounted && _provider.isCompleted(i) && !_provider.isClaimed(i) && !_activeClaimDialog.contains(i)) {
            _activeClaimDialog.add(i);
            showGameMissionDialog(context, _provider.gamesUrl[i], i, _provider)
                .whenComplete(() => _activeClaimDialog.remove(i));
          }
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _provider.onAppResumed(
        onCompleted: (index) {
          if (mounted &&
              !_provider.isRunning(index) &&
              !_activeClaimDialog.contains(index)) {
            _activeClaimDialog.add(index);
            showGameMissionDialog(context, _provider.gamesUrl[index], index, _provider)
                .whenComplete(() => _activeClaimDialog.remove(index));
          }
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lockRefreshTimer?.cancel();
    _provider.removeListener(_onProviderChanged);
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          RoutingHelper().handleBackPress(context);
        },
        child: Scaffold(
          backgroundColor: context.themeColors.backgroundColor,
          appBar: const SharedAppBar(title: 'Play Game'),
          body: Consumer<ArcadeProvider>(
            builder: (context, provider, _) {
              return GridView.builder(
                padding: EdgeInsets.all(AppDimens.appPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppDimens.h16,
                  crossAxisSpacing: AppDimens.w16,
                ),
                itemCount: provider.games.length,
                itemBuilder: (context, index) {
                  final locked = provider.isLocked(index);
                  final lockCD = provider.lockCountdown(index);

                  return Stack(
                    children: [
                      GameTileCard(
                        game: provider.games[index],
                        onTap: locked
                            ? () {}
                            : () => showGameMissionDialog(
                                  context,
                                  provider.gamesUrl[index],
                                  index,
                                  provider,
                                ),
                      ),
                      if (locked)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(AppDimens.r16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_rounded,
                                    color: Colors.white70, size: AppDimens.w24),
                                SizedBox(height: AppDimens.h4),
                                Text(
                                  lockCD,
                                  style: context.textTheme.labelMedium?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppDimens.sp14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
