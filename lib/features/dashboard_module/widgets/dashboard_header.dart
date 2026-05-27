import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/provider/dashboard_provider.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/shared/models/user_model.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/widgets/spinning_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppDimens.h5),
              child: Builder(
                builder: (innerContext) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(innerContext).openDrawer();
                    },
                    child: Container(
                      width: AppDimens.w40,
                      height: AppDimens.w40,
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
                              strutStyle: StrutStyle(fontSize: AppDimens.sp15, height: 1.1, forceStrutHeight: true),
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.themeTextColors.textColor,
                                fontSize: AppDimens.sp18,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: AppDimens.w12),
            // Welcome Text
            Expanded(
              child: Text(
                user?.name ?? 'Guest User',
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.themeTextColors.textColor,
                  fontSize: AppDimens.sp20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w12, vertical: AppDimens.h6),
              decoration: BoxDecoration(
                color: context.themeColors.surfaceColor,
                borderRadius: BorderRadius.circular(AppDimens.r10),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinningIcon(
                    icon: Assets.icons.tokens.svg(width: AppDimens.w20, height: AppDimens.h20),
                  ),
                  SizedBox(width: AppDimens.w6),
                  Text(
                    '${user?.coin.toInt()}',
                    strutStyle: StrutStyle(fontSize: AppDimens.sp20, height: 1.1, forceStrutHeight: true),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.themeTextColors.textColor,
                      fontSize: AppDimens.sp20,
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
