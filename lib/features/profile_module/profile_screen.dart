import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/auth_module/provider/auth_provider.dart';
import 'package:daily_cash/features/profile_module/widgets/header_clipper.dart';
import 'package:daily_cash/features/profile_module/widgets/profile_option_tile.dart';
import 'package:daily_cash/features/profile_module/widgets/profile_stat_card.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/shared/models/user_model.dart';
import 'package:daily_cash/utils/app_size.dart';
import 'package:daily_cash/utils/navigation_helper.dart';
import 'package:daily_cash/utils/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'profile_screen');
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        NavigationHelper().handleBackPress(context);
      },
      child: ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: Scaffold(
          backgroundColor: themeColors.backgroundColor,
          body: SafeArea(
            child: StreamBuilder(
              stream: Injector.instance<AppDB>().userListenable(),
              builder: (context, _) {
                final user = Injector.instance<AppDB>().userModel;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.h20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildClippedHeader(context, user),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSize.w20),
                          child: _buildAccountSection(context, user),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel? user) {
    final themeColors = context.themeColors;
    final name = user?.name ?? 'Guest User';

    return Column(
      children: [
        Container(
          width: AppSize.w72,
          height: AppSize.w72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: themeColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: themeColors.secondaryGradient1.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
            image: user?.photoUrl?.isNotEmpty ?? false
                ? DecorationImage(image: NetworkImage(user!.photoUrl!), fit: BoxFit.cover)
                : null,
          ),
          alignment: Alignment.center,
          child: user?.photoUrl?.isNotEmpty ?? false
              ? null
              : Text(
                  name[0].toUpperCase(),
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.sp34,
                  ),
                ),
        ),
        SizedBox(height: AppSize.h16),
        Text(
          name,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.themeTextColors.textColor,
            fontWeight: FontWeight.w700,
            fontSize: AppSize.sp20,
          ),
        ),
        SizedBox(height: AppSize.h4),
        Text(
          'Lv ${user?.level.toStringAsFixed(1) ?? '1.0'}',
          style: context.textTheme.labelLarge?.copyWith(
            color: context.themeTextColors.descriptionColor,
            fontWeight: FontWeight.w400,
            fontSize: AppSize.sp14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, UserModel? user) {
    final coins = user?.coin ?? 0;
    final xp    = user?.xp.toInt() ?? 0;
    return Row(
      spacing: AppSize.w12,
      children: [
        ProfileStatCard(
          value: '${coins.toInt()}',
          label: context.l10n.coins,
          color: context.themeColors.primaryGradient1.withValues(alpha: 0.2),
        ),
        ProfileStatCard(
          value: '$xp',
          label: 'XP',
          color: const Color(0xffFC299E).withValues(alpha: 0.1),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context, UserModel? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.account,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.themeTextColors.descriptionColor,
            fontWeight: FontWeight.w400,
            fontSize: AppSize.sp16,
          ),
        ),
        SizedBox(height: AppSize.h16),
        if (user?.isGuest ?? true)
          Consumer<AuthProvider>(
            builder: (context, auth, _) => ProfileOptionTile(
              icon: auth.isLinkLoading
                  ? SizedBox(
                      width: AppSize.w22,
                      height: AppSize.w22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.themeColors.secondaryGradient4,
                      ),
                    )
                  : Assets.navIcons.home.svg(width: AppSize.w22),
              title: context.l10n.linkGoogleAccount,
              onTap: auth.isLinkLoading ? null : () => _handleLinkAccount(context, auth),
            ),
          ),
        ProfileOptionTile(
          icon: Assets.navIcons.profile.svg(width: AppSize.w22),
          title: context.l10n.settings,
          onTap: () => NavigationHelper().navigateWithAdCheck(
              context, () => context.pushNamed(AppRoutes.settings)),
        ),
        ProfileOptionTile(
          icon: Assets.icons.trophy.svg(width: AppSize.w22),
          title: context.l10n.referAndEarn,
          onTap: () => NavigationHelper().navigateWithAdCheck(
              context, () => context.goNamed(AppRoutes.referEarn)),
        ),
        // ProfileOptionTile(
        //   icon: Assets.icons.leaderboard.svg(width: AppSize.w22),
        //   title: 'Achievement',
        //   onTap: () => NavigationHelper().navigateWithAdCheck(
        //       context, () => context.pushNamed(AppRoutes.achievement)),
        // ),
        ProfileOptionTile(
          icon: Assets.icons.profileIcons.support.svg(width: AppSize.w22),
          title: context.l10n.support,
          onTap: () => NavigationHelper().navigateWithAdCheck(
              context, () => context.pushNamed(AppRoutes.support)),
        ),
        ProfileOptionTile(
          icon: Assets.icons.withdraw.svg(width: AppSize.w22),
          title: context.l10n.privacyPolicy,
          onTap: () {
            launchUrlString(RemoteConfigService.instance.privacyPolicyUrl);
          },
        ),
        ProfileOptionTile(
          icon: Assets.icons.withdraw.svg(width: AppSize.w22),
          title: context.l10n.termsOfService,
          onTap: () {
            launchUrlString(RemoteConfigService.instance.termsAndConditions);
          },
        ),
      ],
    );
  }

  Future<void> _handleLinkAccount(BuildContext context, AuthProvider auth) async {
    await auth.linkGoogleAccount();
    if (!context.mounted) return;
    if (auth.linkSuccess) {
      context.l10n.googleAccountLinked.showSuccessAlert();
    } else if (auth.linkErrorMessage != null) {
      auth.linkErrorMessage!.showErrorAlert();
    }
  }

  Widget _buildClippedHeader(BuildContext context, UserModel? user) {
    final themeColors = context.themeColors;
    return ClipPath(
      clipper: HeaderCurveClipper(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          bottom: AppSize.h60,
          top: AppSize.h10,
          left: AppSize.w20,
          right: AppSize.w20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeColors.backgroundColor,
              themeColors.primaryGradient2.withValues(alpha: 0.5),
              themeColors.primaryGradient1,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildProfileHeader(context, user),
            SizedBox(height: AppSize.h20),
            _buildStatsRow(context, user),
          ],
        ),
      ),
    );
  }
}
