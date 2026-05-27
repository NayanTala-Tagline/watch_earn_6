import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/inner_screens/play_game/provider/play_game_provider.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppGameViewScreen extends StatefulWidget {
  final String url;
  final int cardIndex;

  const InAppGameViewScreen({
    super.key,
    required this.url,
    required this.cardIndex,
  });

  @override
  State<InAppGameViewScreen> createState() => _InAppGameViewScreenState();
}

class _InAppGameViewScreenState extends State<InAppGameViewScreen> {
  late final WebViewController _controller;
  PlayGameProvider? _cachedProvider;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cachedProvider != null) return;
    _cachedProvider = context.read<PlayGameProvider>();
    _cachedProvider?.addListener(_onProviderChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final p = _cachedProvider;
      if (p != null && p.isCompleted(widget.cardIndex) && !p.isRunning(widget.cardIndex)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  void _onProviderChanged() {
    if (!mounted) return;
    final provider = _cachedProvider;
    if (provider == null) return;
    if (provider.isCompleted(widget.cardIndex) && !provider.isRunning(widget.cardIndex)) {
      provider.removeListener(_onProviderChanged);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  void dispose() {
    _cachedProvider?.removeListener(_onProviderChanged);
    final provider = _cachedProvider;
    if (provider != null && provider.isRunning(widget.cardIndex)) {
      final index = widget.cardIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.cancelMission(index);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayGameProvider>(
      builder: (context, provider, _) {
        final remaining = provider.remaining(widget.cardIndex);
        final isRunning = provider.isRunning(widget.cardIndex);

        return Scaffold(
          backgroundColor: context.themeColors.backgroundColor,
          appBar: const CommonAppBar(title: 'Play Game'),
          body: SafeArea(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (isRunning)
                  Positioned(
                    bottom: AppSize.h24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _TimerBadge(remaining: remaining),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimerBadge extends StatelessWidget {
  final int remaining;
  const _TimerBadge({required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppSize.w16, vertical: AppSize.h12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F2A).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppSize.r20),
        border: Border.all(
          color: context.themeColors.secondaryGradient4,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppSize.w28,
            height: AppSize.w28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: remaining / RemoteConfigService.instance.playGameVisitTimer,
                  strokeWidth: 2.5,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.themeColors.secondaryGradient4,
                  ),
                ),
                Text(
                  '$remaining',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.sp10,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSize.w10),
          Text(
            'Keep playing...',
            style: context.textTheme.labelMedium?.copyWith(
              color: context.themeTextColors.descriptionColor,
              fontSize: AppSize.sp13,
            ),
          ),
        ],
      ),
    );
  }
}
