import 'dart:async';
import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/visit_website_module/provider/visit_website_provider.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../gen/assets.gen.dart';
import 'model/visit_website_data_model.dart';
import 'widgets/mission_brief_dialog.dart';
import 'widgets/visit_website_card.dart';

class VisitWebsiteScreen extends StatefulWidget {
  const VisitWebsiteScreen({super.key});

  @override
  State<VisitWebsiteScreen> createState() => _VisitWebsiteScreenState();
}

class _VisitWebsiteScreenState extends State<VisitWebsiteScreen>
    with WidgetsBindingObserver {
  final List<VisitWebsiteData> websites = [
    VisitWebsiteData(
      title: 'Tech News Daily',
      icon: Assets.icons.techUpdates.svg(),
      reward: RemoteConfigService.instance.websiteRewardCoins,
      startColor: rootNavKey.currentContext!.themeColors.secondaryGradient3,
      endColor: const Color(0xFF073B4C),
    ),
    VisitWebsiteData(
      title: 'Viral Gadgets',
      icon: Assets.icons.trendingGadget.svg(),
      reward: RemoteConfigService.instance.websiteRewardCoins,
      startColor: rootNavKey.currentContext!.themeColors.secondaryGradient4,
      endColor: rootNavKey.currentContext!.themeColors.secondaryGradient2,
    ),
    VisitWebsiteData(
      title: 'Lifestyle Blog',
      icon: Assets.icons.living.svg(),
      reward: RemoteConfigService.instance.websiteRewardCoins,
      startColor: rootNavKey.currentContext!.themeColors.secondaryGradient4,
      endColor: rootNavKey.currentContext!.themeColors.secondaryGradient5,
    ),
    VisitWebsiteData(
      title: 'Travel Dailies',
      icon: Assets.icons.journey.svg(),
      reward: RemoteConfigService.instance.websiteRewardCoins,
      startColor: rootNavKey.currentContext!.themeColors.secondaryGradient2,
      endColor: const Color(0xFF4A0E1A),
    ),
    VisitWebsiteData(
      title: 'Finance Tips',
      icon: Assets.icons.tokens.svg(),
      reward: RemoteConfigService.instance.websiteRewardCoins,
      startColor: rootNavKey.currentContext!.themeColors.secondaryGradient2,
      endColor: rootNavKey.currentContext!.themeColors.primaryGradient2,
    ),
  ];

  final List<String> websitesUrl = [
    RemoteConfigService.instance.techNewsUrl,
    RemoteConfigService.instance.viralGadgetUrl,
    RemoteConfigService.instance.lifestyleBlogUrl,
    RemoteConfigService.instance.travelDailiesUrl,
    RemoteConfigService.instance.financeTipsUrl,
  ];

  Timer? _lockRefreshTimer;
  late final VisitWebsiteProvider _provider;
  final Set<int> _pendingClaimDialog = {};
  final Set<int> _activeClaimDialog = {};

  @override
  void initState() {
    super.initState();
    _provider = VisitWebsiteProvider();
    WidgetsBinding.instance.addObserver(this);
    AnalyticsManager.instance.logScreenView(screenName: 'visit_website_screen');
    _lockRefreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) { if (mounted) setState(() {}); },
    );
    _provider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    if (!mounted) return;
    for (int i = 0; i < websitesUrl.length; i++) {
      if (_provider.isCompleted(i) && !_provider.isClaimed(i) && !_provider.isRunning(i)) {
        if (_pendingClaimDialog.contains(i) || _activeClaimDialog.contains(i)) continue;
        _pendingClaimDialog.add(i);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pendingClaimDialog.remove(i);
          if (mounted && _provider.isCompleted(i) && !_provider.isClaimed(i) && !_activeClaimDialog.contains(i)) {
            _activeClaimDialog.add(i);
            showMissionBriefDialog(context, websitesUrl[i], i, _provider)
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
            showMissionBriefDialog(context, websitesUrl[index], index, _provider)
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
          appBar: CommonAppBar(title: context.l10n.visitWebsites),
          body: SafeArea(
            child: Consumer<VisitWebsiteProvider>(
              builder: (context, provider, _) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.w20, vertical: AppSize.h20),
                  itemCount: websites.length,
                  separatorBuilder: (_, _) => SizedBox(height: AppSize.h16),
                  itemBuilder: (context, index) {
                    final data   = websites[index];
                    final locked = provider.isLocked(index);
                    final lockCD = provider.lockCountdown(index);

                    return Stack(
                      children: [
                        VisitWebsiteCard(
                          title: data.title,
                          icon: data.icon,
                          reward: data.reward,
                          startColor: locked
                              ? Colors.grey
                              : data.startColor,
                          endColor: locked
                              ? Colors.grey.shade800
                              : data.endColor,
                          onTap: locked
                              ? () {}
                              : () => showMissionBriefDialog(
                                    context,
                                    websitesUrl[index],
                                    index,
                                    provider
                                  ),
                        ),

                        if (locked)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                borderRadius:
                                    BorderRadius.circular(AppSize.r14),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock_rounded,
                                      color: Colors.white70,
                                      size: AppSize.w24),
                                  SizedBox(height: AppSize.h4),
                                  Text(
                                    lockCD,
                                    style: context.textTheme.labelMedium
                                        ?.copyWith(
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
      ),
    );
  }
}
