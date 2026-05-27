import 'dart:async';
import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/inner_screens/play_game/provider/play_game_provider.dart';
import 'package:daily_cash/features/home_module/inner_screens/play_game/widgets/game_grid_card.dart';
import 'package:daily_cash/features/home_module/inner_screens/play_game/widgets/game_mission_dialog.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayGameScreen extends StatefulWidget {
  const PlayGameScreen({super.key});

  @override
  State<PlayGameScreen> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen>
    with WidgetsBindingObserver {
  Timer? _lockRefreshTimer;
  late final PlayGameProvider _provider;
  final Set<int> _pendingClaimDialog = {};
  final Set<int> _activeClaimDialog = {};

  @override
  void initState() {
    super.initState();
    _provider = PlayGameProvider();
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
          NavigationHelper().handleBackPress(context);
        },
        child: Scaffold(
          backgroundColor: context.themeColors.backgroundColor,
          appBar: const CommonAppBar(title: 'Play Game'),
          body: Consumer<PlayGameProvider>(
            builder: (context, provider, _) {
              return GridView.builder(
                padding: EdgeInsets.all(AppSize.appPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSize.h16,
                  crossAxisSpacing: AppSize.w16,
                ),
                itemCount: provider.games.length,
                itemBuilder: (context, index) {
                  final locked = provider.isLocked(index);
                  final lockCD = provider.lockCountdown(index);

                  return Stack(
                    children: [
                      GameGridCard(
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
                              borderRadius: BorderRadius.circular(AppSize.r16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_rounded,
                                    color: Colors.white70, size: AppSize.w24),
                                SizedBox(height: AppSize.h4),
                                Text(
                                  lockCD,
                                  style: context.textTheme.labelMedium?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppSize.sp14,
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
