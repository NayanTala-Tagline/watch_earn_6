import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/purse_module/provider/purse_provider.dart';
import 'package:flutter/material.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:provider/provider.dart';

class PurseTabs extends StatelessWidget {
  const PurseTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PurseProvider>(
      builder: (context, provider, _) {
        final categories = provider.getWalletCategories(context);
        return Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0F2A),
              borderRadius: BorderRadius.circular(28),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        categories.length,
                        (index) => GestureDetector(
                          onTap: () {
                            provider.setSelectedIndex(index);
                            provider.setWithdrawType(
                              categories[index].title,
                            );
                            provider.pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: _PurseTabitem(
                            title:categories[index].title,
                            isSelected: provider.selectedIndex == index,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _PurseTabitem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _PurseTabitem({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 36, // ✅ IMPORTANT (controls vertical alignment)
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.w14),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blueAccent.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isSelected
          ? ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4C67FE), Color(0xFF45C1FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.displayLarge?.copyWith(
                    fontSize: AppDimens.sp15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    // height: 0.8, // ✅ IMPORTANT FIX
                  ),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.displayLarge?.copyWith(
                  fontSize: AppDimens.sp14,
                  fontWeight: FontWeight.w700,
                  color: context.themeTextColors.textColor,
                  // height: 1.0, // ✅ IMPORTANT FIX
                ),
              ),
            ),
    );
  }
}
