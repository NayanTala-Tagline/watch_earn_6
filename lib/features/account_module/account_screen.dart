import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/access_module/provider/access_provider.dart';
import 'package:daily_cash/features/account_module/widgets/header_arc_clipper.dart';
import 'package:daily_cash/features/account_module/widgets/account_option_tile.dart';
import 'package:daily_cash/features/account_module/widgets/account_stat_card.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/shared/models/user_model.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
        RoutingHelper().handleBackPress(context);
      },
      child: ChangeNotifierProvider(
        create: (_) => AccessProvider(),
        child: Scaffold(
          backgroundColor: themeColors.backgroundColor,
          body: SafeArea(
            child: StreamBuilder(
              stream: Injector.instance<AppDB>().userListenable(),
              builder: (context, _) {
                final user = Injector.instance<AppDB>().userModel;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimens.h20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildClippedHeader(context, user),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
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
          width: AppDimens.w72,
          height: AppDimens.w72,
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
                    fontSize: AppDimens.sp34,
                  ),
                ),
        ),
        SizedBox(height: AppDimens.h16),
        Text(
          name,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.themeTextColors.textColor,
            fontWeight: FontWeight.w700,
            fontSize: AppDimens.sp20,
          ),
        ),
        SizedBox(height: AppDimens.h4),
        Text(
          'Lv ${user?.level.toStringAsFixed(1) ?? '1.0'}',
          style: context.textTheme.labelLarge?.copyWith(
            color: context.themeTextColors.descriptionColor,
            fontWeight: FontWeight.w400,
            fontSize: AppDimens.sp14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, UserModel? user) {
    final coins = user?.coin ?? 0;
    final xp    = user?.xp.toInt() ?? 0;
    return Row(
      spacing: AppDimens.w12,
      children: [
        AccountStatCard(
          value: '${coins.toInt()}',
          label: context.l10n.coins,
          color: context.themeColors.primaryGradient1.withValues(alpha: 0.2),
        ),
        AccountStatCard(
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
            fontSize: AppDimens.sp16,
          ),
        ),
        SizedBox(height: AppDimens.h16),
        if (user?.isGuest ?? true)
          Consumer<AccessProvider>(
            builder: (context, auth, _) => AccountOptionTile(
              icon: auth.isLinkLoading
                  ? SizedBox(
                      width: AppDimens.w22,
                      height: AppDimens.w22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.themeColors.secondaryGradient4,
                      ),
                    )
                  : Assets.navIcons.house.svg(width: AppDimens.w22),
              title: context.l10n.linkGoogleAccount,
              onTap: auth.isLinkLoading ? null : () => _handleLinkAccount(context, auth),
            ),
          ),
        AccountOptionTile(
          icon: Assets.navIcons.account.svg(width: AppDimens.w22),
          title: context.l10n.settings,
          onTap: () => RoutingHelper().navigateWithAdCheck(
              context, () => context.pushNamed(AppRoutes.settings)),
        ),
        AccountOptionTile(
          icon: Assets.icons.award.svg(width: AppDimens.w22),
          title: context.l10n.referAndEarn,
          onTap: () => RoutingHelper().navigateWithAdCheck(
              context, () => context.goNamed(AppRoutes.referEarn)),
        ),
        // AccountOptionTile(
        //   icon: Assets.icons.rankings.svg(width: AppDimens.w22),
        //   title: 'Achievement',
        //   onTap: () => RoutingHelper().navigateWithAdCheck(
        //       context, () => context.pushNamed(AppRoutes.achievement)),
        // ),
        AccountOptionTile(
          icon: Assets.icons.profileIcons.help.svg(width: AppDimens.w22),
          title: context.l10n.support,
          onTap: () => RoutingHelper().navigateWithAdCheck(
              context, () => context.pushNamed(AppRoutes.support)),
        ),
        AccountOptionTile(
          icon: Assets.icons.cashout.svg(width: AppDimens.w22),
          title: context.l10n.privacyPolicy,
          onTap: () {
            launchUrlString(RemoteSettingsService.instance.privacyPolicyUrl);
          },
        ),
        AccountOptionTile(
          icon: Assets.icons.cashout.svg(width: AppDimens.w22),
          title: context.l10n.termsOfService,
          onTap: () {
            launchUrlString(RemoteSettingsService.instance.termsAndConditions);
          },
        ),
      ],
    );
  }

  Future<void> _handleLinkAccount(BuildContext context, AccessProvider auth) async {
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
      clipper: HeaderArcClipper(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          bottom: AppDimens.h60,
          top: AppDimens.h10,
          left: AppDimens.w20,
          right: AppDimens.w20,
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
            SizedBox(height: AppDimens.h20),
            _buildStatsRow(context, user),
          ],
        ),
      ),
    );
  }
}
