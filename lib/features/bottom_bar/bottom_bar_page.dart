import 'dart:io';

import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/bottom_bar/widgets/bottom_bar_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import '../../../utils/anaytics_manager.dart';
import '../../extension/ext_context.dart';
import '../dashboard_module/provider/dashboard_provider.dart';

/// Bottom navigation page for managing bottom navigation
class BottomBarPage extends StatefulWidget {
  /// Default constructor
  const BottomBarPage({required this.child, this.showWalletDialog, super.key});

  /// The navigation shell
  final StatefulNavigationShell child;

  /// Want to show Wallet Feature dialog or not
  final bool? showWalletDialog;

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  final dashboardSfKey = GlobalKey<ScaffoldState>();

  DateTime? _currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      dialogStyle: UpgradeDialogStyle.cupertino,
      cupertinoButtonTextStyle: context.textTheme.titleSmall,
      child: BackButtonListener(
        onBackButtonPressed: () async {
          if (ModalRoute.of(context)?.isCurrent ?? false) {
            if (widget.child.currentIndex == 0) {
              _handleBackPress(context);
            } else {
              widget.child.goBranch(0);
            }
            return true;
          }
          return false;
        },
        child: ChangeNotifierProvider(
          create: (context) => DashboardProvider(),
          child: Scaffold(
            key: dashboardSfKey,
            body: widget.child,
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: BottomBarShell(shell: widget.child),
          ),
        ),
      ),
    );
  }

  void _handleBackPress(BuildContext context) {
    if (_currentBackPressTime == null ||
        DateTime.now().difference(_currentBackPressTime!) > const Duration(milliseconds: 750)) {
      _currentBackPressTime = DateTime.now();
      context.l10n.pressBackToExit.showInfoAlert(duration: const Duration(milliseconds: 750));
      AnalyticsManager.instance.logEvent(name: "app_exit_attempted");
      /*ConfirmDialog.instance.show(
        context: context,
        title: context.l10n.appName,
        message: context.l10n.doYouWantToExit,
        onYes: () async {
          if (Platform.isAndroid) {
            await SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
      ); */
    } else {
      AnalyticsManager.instance.logEvent(name: "app_exit_confirmed");
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }
}
