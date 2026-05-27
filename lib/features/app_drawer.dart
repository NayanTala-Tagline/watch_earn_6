import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/shared/models/user_model.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/widgets/app_button.dart';
import 'package:daily_cash/widgets/gradient_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../routes/app_routes.dart';
import '../utils/remote_config.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;

    return Drawer(
      backgroundColor: themeColors.backgroundColor,
      width: AppSize.w250 + AppSize.w50,
      child: GradientCard(
        gradient: LinearGradient(
          colors: [
            themeColors.surfaceColor,
            themeColors.primaryGradient2.withValues(alpha: 0.5),
            themeColors.surfaceColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: StreamBuilder(
          stream: Injector.instance<AppDB>().userListenable(),
          builder: (context, _) {
            final user = Injector.instance<AppDB>().userModel;
            return Column(
              children: [
                _buildHeader(context, user),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: AppSize.h10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MenuItem(
                          icon: Assets.navIcons.house.svg(
                            width: AppSize.w24,
                          ),
                          title: context.l10n.home,
                          onTap: () => context.pop(),
                        ),
                        _MenuItem(
                          icon: Assets.navIcons.account.svg(
                            width: AppSize.w24,
                          ),
                          title: context.l10n.myProfile,
                          onTap: () {
                            context.pop();
                            context.goNamed(AppRoutes.profile);
                          },
                        ),
                        // _MenuItem(
                        //   icon: Assets.icons.award.svg(
                        //     width: AppSize.w24,
                        //   ),
                        //   title: 'Achievement',
                        //   onTap: () {
                        //     context.pop();
                        //     context.pushNamed(AppRoutes.achievement);
                        //   },
                        // ),
                        _MenuItem(
                          icon: Assets.icons.rankings
                              .svg(width: AppSize.w24),
                          title: context.l10n.leaderboard,
                          onTap: () {
                            context.pop();
                            context.goNamed(AppRoutes.leaderboard);
                          },
                        ),
                        _MenuItem(
                          icon: Assets.icons.inviteEarn.svg(
                            width: AppSize.w24,
                          ),
                          title: context.l10n.referAndEarn,
                          onTap: () {
                            context.pop();
                            context.pushNamed(AppRoutes.referEarn);
                          },
                        ),
                        _MenuItem(
                          icon: Assets.icons.cashout.svg(
                            width: AppSize.w24,
                          ),
                          title: context.l10n.myWallet,
                          onTap: () {
                            context.pop();
                            context.goNamed(AppRoutes.wallet);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppSize.w20,
                            AppSize.h24,
                            AppSize.w20,
                            AppSize.h12,
                          ),
                          child: Text(
                            context.l10n.shareAndSupport,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.themeTextColors.descriptionColor,
                              fontWeight: FontWeight.w400,
                              fontSize: AppSize.sp14,
                            ),
                          ),
                        ),
                        _MenuItem(
                          icon: Assets.icons.profileIcons.audio.svg(width: AppSize.w24),
                          title: context.l10n.settings,
                          onTap: () {
                            context.pop();
                            context.pushNamed(AppRoutes.settings);
                          },
                        ),
                        _MenuItem(
                          icon: Assets.icons.profileIcons.confidential.svg(width: AppSize.w24),
                          title: context.l10n.privacyPolicy,
                          onTap: () {
                            context.pop();
                            launchUrlString(RemoteConfigService.instance.privacyPolicyUrl);
                          },
                        ),
                        _MenuItem(
                          icon: Assets.icons.profileIcons.conditions.svg(width: AppSize.w24),
                          title: context.l10n.termsOfService,
                          onTap: () {
                            context.pop();
                            launchUrlString(RemoteConfigService.instance.termsAndConditions);
                          },
                        ),
                        _MenuItem(
                          icon: Assets.icons.profileIcons.help.svg(
                            width: AppSize.w24,
                          ),
                          title: context.l10n.support,
                          onTap: () {
                            context.pushNamed(AppRoutes.support);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _buildFooter(context),
              ],
            );
          },
        ),
      ),
      );
  }


  Widget _buildHeader(BuildContext context, UserModel? user) {
    final themeColors = context.themeColors;
    final name = user?.name ?? 'Guest User';

    return Container(
      padding: EdgeInsets.only(top: AppSize.h30, bottom: AppSize.h30),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppSize.w48,
            height: AppSize.w48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: themeColors.secondaryGradient2,
                width: 1,
              ),
              color: themeColors.primaryGradient1,
              image: user?.photoUrl?.isNotEmpty ?? false
                  ? DecorationImage(
                      image: NetworkImage(user!.photoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: user?.photoUrl?.isNotEmpty ?? false
                ? null
                : ShaderMask(
                    shaderCallback: (bounds) =>
                        themeColors.primaryGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: Text(
                      name[0].toUpperCase(),
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: context.themeTextColors.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSize.sp24,
                      ),
                    ),
                  ),
          ),
          SizedBox(width: AppSize.w16),

          // User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.sp20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSize.h4),
                Text(
                  'Lv ${user?.level.toStringAsFixed(1) ?? '1.0'}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontWeight: FontWeight.w400,
                    fontSize: AppSize.sp14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: context.themeColors.secondaryGradient2.withValues(alpha: 0.5),
        ),
        _MenuItem(
          icon: Container(
            decoration: BoxDecoration(
              color: context.themeColors.secondaryGradient2.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppSize.r12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.w10, vertical: AppSize.h10),
              child: Icon(
                Icons.delete_forever_rounded,
                color: context.themeColors.secondaryGradient2,
                size: AppSize.w24,
              ),
            ),
          ),
          title: context.l10n.deleteAccount,
          isLogOut: true,
          titleColor: context.themeColors.secondaryGradient2,
          onTap: () => _confirmDeleteAccount(context),
        ),
        SizedBox(height: AppSize.h8),
        _MenuItem(
          icon: Container(
            decoration: BoxDecoration(
              color: context.themeColors.secondaryGradient2.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppSize.r12),
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.w10, vertical: AppSize.h10),
                child: Assets.icons.profileIcons.logout.svg(),
              ),
            ),
          title: context.l10n.signOut,
          isLogOut: true,
          titleColor: context.themeColors.secondaryGradient2,
          onTap: () => _confirmSignOut(context),
        ),
      ],
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: EdgeInsets.fromLTRB(AppSize.w24, AppSize.h28, AppSize.w24, 0),
        contentPadding: EdgeInsets.fromLTRB(AppSize.w24, AppSize.h12, AppSize.w24, 0),
        actionsPadding: EdgeInsets.fromLTRB(AppSize.w16, AppSize.h16, AppSize.w16, AppSize.h20),
        title: Column(
          children: [
            Container(
              width: AppSize.w60,
              height: AppSize.w60,
              decoration: BoxDecoration(
                color: context.themeColors.secondaryGradient2.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.delete_forever_rounded,
                color: context.themeColors.secondaryGradient2,
                size: AppSize.w32,
              ),
            ),
            SizedBox(height: AppSize.h14),
            Text(
              context.l10n.deleteAccountConfirmTitle,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.themeColors.secondaryGradient2,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          context.l10n.deleteAccountConfirmMessage,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.themeTextColors.descriptionColor,
            height: 1.4,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: context.themeColors.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.r10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppSize.h12),
                  ),
                  onPressed: () => context.pop(),
                  child: Text(
                    context.l10n.cancel,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.themeTextColors.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSize.w12),
              Expanded(
                child: AppButton(
                  onPressed: () async {
                    context.pop();
                    final db = Injector.instance<AppDB>();
                    final userId = db.userModel?.userId;
                    if (userId != null) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .delete();
                    }
                    await db.clearData();
                    if (context.mounted) {
                      context.goNamed(AppRoutes.login);
                    }
                  },
                  text: context.l10n.delete,
                  buttonColor: context.themeColors.secondaryGradient2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: EdgeInsets.fromLTRB(AppSize.w24, AppSize.h28, AppSize.w24, 0),
        contentPadding: EdgeInsets.fromLTRB(AppSize.w24, AppSize.h12, AppSize.w24, 0),
        actionsPadding: EdgeInsets.fromLTRB(AppSize.w16, AppSize.h16, AppSize.w16, AppSize.h20),
        title: Column(
          children: [
            Container(
              width: AppSize.w60,
              height: AppSize.w60,
              decoration: BoxDecoration(
                color: context.themeColors.secondaryGradient2.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Assets.icons.profileIcons.logout.svg(
                width: AppSize.w28,
                colorFilter: ColorFilter.mode(
                  context.themeTextColors.textColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: AppSize.h14),
            Text(
              context.l10n.signOutConfirmTitle,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.themeTextColors.textColor,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          context.l10n.signOutConfirmMessage,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.themeTextColors.descriptionColor,
            height: 1.4,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: context.themeColors.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.r10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppSize.h12),
                  ),
                  onPressed: () => context.pop(),
                  child: Text(
                    context.l10n.cancel,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.themeTextColors.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSize.w12),
              Expanded(
                child: AppButton(
                  onPressed: () async {
                    context.pop();
                    await Injector.instance<AppDB>().logoutUser();
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      context.goNamed(AppRoutes.login);
                    }
                  },
                  text: context.l10n.signOut,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogOut;
  final Color? titleColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogOut = false,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: true,
      visualDensity: VisualDensity.compact,
      onTap: onTap,
      leading: icon,
      title: Text(
        title,
        strutStyle: StrutStyle(
          fontSize: AppSize.sp16,
          height: 1.1,
          forceStrutHeight: true,
        ),
        style: context.textTheme.bodyLarge?.copyWith(
          color: isLogOut ? context.themeColors.secondaryGradient2 : context.themeTextColors.textColor,
          fontWeight: FontWeight.w700,
          fontSize: AppSize.sp16,
        ),
      ),
    );
  }
}
