import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:flutter/material.dart';

/// Bottom navigation bar matching Figma design
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81,
      decoration: BoxDecoration(
        color: Color(0xFF10132E),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => _NavBarItem(
            item: items[index],
            isActive: currentIndex == index,
            onTap: () => onTap(index),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final BottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeGradient = LinearGradient(
      colors: [Color(0xFFDF49FD), Color(0xFF5029FF), Color(0xFF45C1FD)],
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSize.h8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              ShaderMask(
                shaderCallback: (bounds) => activeGradient.createShader(bounds),
                child: item.icon,
              )
            else
              item.icon,
            SizedBox(height: AppSize.h4),
            ShaderMask(
              shaderCallback: (bounds) => isActive
                  ? activeGradient.createShader(bounds)
                  : LinearGradient(
                      colors: [
                        context.themeTextColors.descriptionColor,
                        context.themeTextColors.descriptionColor,
                      ],
                    ).createShader(bounds),
              child: Text(
                item.label,
                style: context.textTheme.labelLarge?.copyWith(
                  fontSize: AppSize.sp14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem {
  final Widget icon;
  final String label;

  const BottomNavItem({required this.icon, required this.label});
}
