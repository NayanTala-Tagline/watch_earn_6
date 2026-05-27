import 'package:flutter/material.dart';

/// Page indicator dots matching Figma design
class PageDots extends StatelessWidget {
  final int activePage;
  final int pageTotal;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageDots({
    super.key,
    required this.activePage,
    required this.pageTotal,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageTotal, (index) {
        final isActive = activePage == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 16 : 8,
            height: 8,
            decoration: isActive
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: activeColor != null
                        ? null
                        : LinearGradient(
                            colors: [
                              Color(0x909467FF),
                              Color(0xFF424EFE),
                              Color(0xFF3346FF),
                              Color(0xF805C1FD),
                            ],
                          ),
                    color: activeColor,
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    color: inactiveColor ?? Color(0xFF273079),
                  ),
          ),
        );
      }),
    );
  }
}
