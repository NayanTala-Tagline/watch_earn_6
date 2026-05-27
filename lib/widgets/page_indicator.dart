import 'package:flutter/material.dart';

/// Page indicator dots matching Figma design
class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = currentPage == index;
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
