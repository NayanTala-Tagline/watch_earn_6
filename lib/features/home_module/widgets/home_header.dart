import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/home_module/provider/home_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/shared/models/user_model.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/rotating_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppSize.h5),
              child: Builder(
                builder: (innerContext) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(innerContext).openDrawer();
                    },
                    child: Container(
                      width: AppSize.w40,
                      height: AppSize.w40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: context.themeColors.secondaryGradient2, width: 1),
                        color: context.themeColors.primaryGradient1,
                        image: user?.photoUrl?.isNotEmpty ?? false
                            ? DecorationImage(image: NetworkImage(user?.photoUrl ?? ''))
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: user?.photoUrl?.isEmpty ?? true
                          ? Text(
                              user?.name[0].toUpperCase() ?? 'G',
                              strutStyle: StrutStyle(fontSize: AppSize.sp15, height: 1.1, forceStrutHeight: true),
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.themeTextColors.textColor,
                                fontSize: AppSize.sp18,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: AppSize.w12),
            // Welcome Text
            Expanded(
              child: Text(
                user?.name ?? 'Guest User',
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppSize.sp20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.w12, vertical: AppSize.h6),
              decoration: BoxDecoration(
                color: context.themeColors.surfaceColor,
                borderRadius: BorderRadius.circular(AppSize.r10),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotatingIcon(
                    icon: Assets.icons.tokens.svg(width: AppSize.w20, height: AppSize.h20),
                  ),
                  SizedBox(width: AppSize.w6),
                  Text(
                    '${user?.coin.toInt()}',
                    strutStyle: StrutStyle(fontSize: AppSize.sp20, height: 1.1, forceStrutHeight: true),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.themeTextColors.textColor,
                      fontSize: AppSize.sp20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
