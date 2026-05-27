import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/visit_website_module/provider/visit_website_provider.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:daily_cash/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewScreen extends StatefulWidget {
  final String url;
  final int cardIndex;

  const InAppWebViewScreen({
    super.key,
    required this.url,
    required this.cardIndex,
  });

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  late final WebViewController _controller;
  VisitWebsiteProvider? _cachedProvider;

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
    _cachedProvider = context.read<VisitWebsiteProvider>();
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
    return Consumer<VisitWebsiteProvider>(
      builder: (context, provider, _) {
        final remaining  = provider.remaining(widget.cardIndex);
        final isRunning  = provider.isRunning(widget.cardIndex);

        return Scaffold(
          backgroundColor: context.themeColors.backgroundColor,
          appBar: const CommonAppBar(title: 'Visit Website'),
          body: SafeArea(
            child: Stack(
              children: [
                // ── WebView fills the safe area ──────────────────────
                WebViewWidget(controller: _controller),

                // ── Timer badge — bottom center ──────────────────────
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
                  value: remaining / RemoteConfigService.instance.websiteVisitTimer,
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
            'Stay on page...',
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
