import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../gen/assets.gen.dart';
import '../../../utils/navigation_helper.dart';

/// Bottom navigation bar view
class BottomNavView extends StatelessWidget {
  /// Default constructor
  const BottomNavView({required this.shell, super.key});

  /// The navigation shell
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            // This removes the splash/ripple effect across the navigation bar
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: NavigationBar(
            selectedIndex: shell.currentIndex,
            height: kBottomNavigationBarHeight,
            onDestinationSelected: (index) {
              // shell.goBranch(index, initialLocation: shell.currentIndex == index);
              NavigationHelper().navigateWithAdCheck(
                context,
                () => shell.goBranch(index, initialLocation: shell.currentIndex == index),
              );
            },
            // backgroundColor: context.themeColors.bottomNavColor,
            shadowColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.textTheme.bodyMedium?.copyWith(
                  fontSize: AppSize.sp14,
                  fontWeight: FontWeight.w700,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        context.themeColors.secondaryGradient4,
                        context.themeColors.secondaryGradient2,
                        context.themeColors.secondaryGradient1,
                      ],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 100.0, 20.0)), // Estimate label bounds
                );
              }
              return context.textTheme.bodyMedium?.copyWith(
                color: Color(0xFFE9FCFF),
                fontSize: AppSize.sp14,
                fontWeight: FontWeight.w700,
              );
            }),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Opacity(opacity: 0.7, child: Assets.navIcons.house.svg()),
                selectedIcon: _applyGradient(Assets.navIcons.house.svg(), context),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Assets.navIcons.standing.svg(),
                selectedIcon: _applyGradient(Assets.navIcons.standing.svg(), context),
                label: 'Rank',
              ),
              GestureDetector(
                onTap: () {
                  NavigationHelper().navigateWithAdCheck(context, () {
                    shell.goBranch(2);
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF45C1FD), Color(0xFF4B71FE), Color(0xFF512AFF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10)],
                  ),
                  child: Center(child: Assets.icons.cashout.svg(color: Colors.white, height: 22)),
                ),
              ),
              NavigationDestination(
                icon: Assets.navIcons.prizes.svg(),
                selectedIcon: _applyGradient(Assets.navIcons.prizes.svg(), context),
                label: 'Rewards',
              ),
              NavigationDestination(
                icon: Assets.navIcons.account.svg(),
                selectedIcon: _applyGradient(Assets.navIcons.account.svg(), context),
                label: 'Profile',
              ),
            ],
          ),
        ),
        // Positioned(
        //   bottom: 20, // adjust based on design
        //   child: ,
        // ),
      ],
    );
  }
}

Widget _applyGradient(Widget child, BuildContext context) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        colors: [
          context.themeColors.secondaryGradient4,
          context.themeColors.secondaryGradient2,
          context.themeColors.secondaryGradient1,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds);
    },
    child: child,
  );
}
