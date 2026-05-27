import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/browse_site_module/provider/browse_site_provider.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbeddedWebScreen extends StatefulWidget {
  final String url;
  final int cardIndex;

  const EmbeddedWebScreen({
    super.key,
    required this.url,
    required this.cardIndex,
  });

  @override
  State<EmbeddedWebScreen> createState() => _EmbeddedWebScreenState();
}

class _EmbeddedWebScreenState extends State<EmbeddedWebScreen> {
  late final WebViewController _controller;
  BrowseSiteProvider? _cachedProvider;

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
    _cachedProvider = context.read<BrowseSiteProvider>();
    // Listen for completion → auto-pop back to visit website screen
    _cachedProvider?.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    if (!mounted) return;
    final provider = _cachedProvider;
    if (provider == null) return;
    if (provider.isCompleted(widget.cardIndex) && !provider.isRunning(widget.cardIndex)) {
      provider.removeListener(_onProviderChanged);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _cachedProvider?.removeListener(_onProviderChanged);
    final provider = _cachedProvider;
    if (provider != null && provider.isRunning(widget.cardIndex)) {
      final index = widget.cardIndex;
      // Defer notifyListeners call — calling it during dispose/unmount
      // triggers "setState called when widget tree was locked"
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.cancelMission(index);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrowseSiteProvider>(
      builder: (context, provider, _) {
        final remaining  = provider.remaining(widget.cardIndex);
        final isRunning  = provider.isRunning(widget.cardIndex);

        return Scaffold(
          backgroundColor: context.themeColors.backgroundColor,
          appBar: const SharedAppBar(title: 'Visit Website'),
          body: SafeArea(
            child: Stack(
              children: [
                // ── WebView fills the safe area ──────────────────────
                WebViewWidget(controller: _controller),

                // ── Timer badge — bottom center ──────────────────────
                if (isRunning)
                  Positioned(
                    bottom: AppDimens.h24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _TimerChip(remaining: remaining),
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

class _TimerChip extends StatelessWidget {
  final int remaining;

  const _TimerChip({required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimens.w16, vertical: AppDimens.h12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F2A).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppDimens.r20),
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
            width: AppDimens.w28,
            height: AppDimens.w28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: remaining / RemoteSettingsService.instance.websiteVisitTimer,
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
                    fontSize: AppDimens.sp10,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.w10),
          Text(
            'Stay on page...',
            style: context.textTheme.labelMedium?.copyWith(
              color: context.themeTextColors.descriptionColor,
              fontSize: AppDimens.sp13,
            ),
          ),
        ],
      ),
    );
  }
}
