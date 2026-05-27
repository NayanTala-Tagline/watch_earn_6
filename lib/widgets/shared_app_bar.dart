import 'package:daily_cash/utils/routing_helper.dart';
import 'package:flutter/material.dart';

import '../extension/ext_context.dart';
import '../gen/assets.gen.dart';
import '../utils/app_dimens.dart';

/// Common application header widget that functions as a PreferredSizeWidget (AppBar).
///
/// It provides highly customizable options for title, leading/actions, and styling
/// while maintaining a consistent design language.
class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppBar({
    required this.title,
    super.key,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.onBackTap,
    this.horizontalPadding,
    this.verticalPadding,
    this.leadingWidth,
    this.showLeading = true,
    this.titleTextStyle,
    this.height = kToolbarHeight + 20,
  });

  /// appbar title
  final String title;

  /// appbar leading
  final Widget? leading;

  /// actions
  final List<Widget>? actions;

  /// center title
  final bool centerTitle;

  /// background color of the AppBar itself
  final Color? backgroundColor;

  /// Back press callback (used if default leading icon is shown)
  final VoidCallback? onBackTap;

  ///Horizontal Padding for the content inside the bar (defaults to AppDimens.w16)
  final double? horizontalPadding;

  ///Vertical Padding for the content inside the bar
  final double? verticalPadding;

  /// Leading Width, overrides the default calculated width
  final double? leadingWidth;

  /// Toggles the visibility of the leading widget (default back button or custom leading)
  final bool showLeading;

  /// Custom text style for the title
  final TextStyle? titleTextStyle;

  /// The height of the AppBar, defaults to kToolbarHeight
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final defaultLeading = GestureDetector(
        onTap: onBackTap ?? () {
          RoutingHelper().handleBackPress(context);
        },
        child: Padding(
          padding: EdgeInsets.only(bottom:AppDimens.h8),
          child: Assets.icons.returnArrow.svg(
            height: AppDimens.h20,
            width: AppDimens.w20,
            fit: BoxFit.contain
          ),
        ));

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? AppDimens.w14, vertical: verticalPadding ?? 0.0),
        child: AppBar(
          backgroundColor: backgroundColor ?? context.themeColors.backgroundColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          toolbarHeight: height,
          leadingWidth: leadingWidth ?? 45,
          leading: showLeading ? (leading ?? defaultLeading) : null,
          title: Text(
            title,
            style:
                titleTextStyle ??
                context.textTheme.bodyMedium!.copyWith(fontSize: AppDimens.sp20, fontWeight: FontWeight.w700),
          ),
          centerTitle: centerTitle,
          actions: actions,
        ),
      ),
    );
  }
}
