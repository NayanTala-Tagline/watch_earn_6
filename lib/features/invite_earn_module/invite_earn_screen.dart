import 'package:ad_manager/utils/anaytics_manager.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/invite_earn_module/provider/invite_earn_provider.dart';
import 'package:daily_cash/features/invite_earn_module/widgets/invite_earn_section_box.dart';
import 'package:daily_cash/features/invite_earn_module/widgets/invite_code_card.dart';
import 'package:daily_cash/gen/assets.gen.dart';
import 'package:daily_cash/routes/app_routes.dart';
import 'package:daily_cash/shared/models/user_model.dart';
import 'package:daily_cash/utils/app_dimens.dart';
import 'package:daily_cash/utils/routing_helper.dart';
import 'package:daily_cash/widgets/app_input_field.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InviteEarnScreen extends StatefulWidget {
  const InviteEarnScreen({super.key});

  @override
  State<InviteEarnScreen> createState() => _InviteEarnScreenState();
}

class _InviteEarnScreenState extends State<InviteEarnScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsManager.instance.logScreenView(screenName: 'refer_earn_screen');
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
        create: (context) => InviteEarnProvider(),
        child: Scaffold(
          backgroundColor: themeColors.backgroundColor,
          appBar: SharedAppBar(title: context.l10n.rewardsAndBonus, showLeading: false,),
          body: StreamBuilder(
            stream: Injector.instance<AppDB>().userListenable(),
            builder: (context, _) {
              final user = Injector.instance<AppDB>().userModel;
              final isGuest = user?.isGuest ?? true;
              final referredCode = user?.referredBy ?? '';
              final hasReferred = referredCode.isNotEmpty;
              final hasRated = user?.hasRated ?? false;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.w20,
                  vertical: AppDimens.h16,
                ),
                child: Column(
                  spacing: AppDimens.h10,
                  children: [
                    InviteEarnSectionBox(
                      icon: Assets.icons.award.svg(),
                      title: context.l10n.referAndEarn,
                      subtitle: isGuest
                          ? context.l10n.linkYourAccountToStartEarning
                          : 'Get ${InviteEarnProvider.referralReward} Coins per friend',
                      child: isGuest
                          ? _GuestLinkArea()
                          : _ShareInviteSection(user: user!),
                    ),
                    _FadedWhenGuest(
                      isGuest: isGuest,
                      child: InviteEarnSectionBox(
                        icon: Assets.icons.inviteEarn.svg(width: AppDimens.w24),
                        title: hasReferred
                            ? context.l10n.referralCodeApplied
                            : context.l10n.enterReferralCode,
                        subtitle: hasReferred
                            ? 'You earned ${InviteEarnProvider.referralReward} Coins!'
                            : 'Get ${InviteEarnProvider.referralReward} Coins bonus',
                        child: hasReferred
                            ? _InviteAppliedView(code: referredCode)
                            : const _EnterInviteCodeView(),
                      ),
                    ),
                    _FadedWhenGuest(
                      isGuest: isGuest,
                      child: InviteEarnSectionBox(
                        icon: Assets.icons.inviteEarn.svg(width: AppDimens.w24),
                        title: hasRated ? context.l10n.thanksForRating : context.l10n.rateUs,
                        subtitle: hasRated
                            ? context.l10n.yourFeedbackMeansWorld
                            : context.l10n.loveOurApp,
                        child: hasRated
                            ? const _ReviewedView()
                            : const _RatingButton(),
                      ),
                    ),
                    SizedBox(height: AppDimens.h20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Wraps a child to grey it out and block interaction when the user is a guest.
class _FadedWhenGuest extends StatelessWidget {
  final bool isGuest;
  final Widget child;
  const _FadedWhenGuest({required this.isGuest, required this.child});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isGuest ? 0.4 : 1.0,
      child: IgnorePointer(ignoring: isGuest, child: child),
    );
  }
}

/// Shown when the user is a guest: a single full-width Link Account card.
/// Tapping it pops back to the previous screen so they can link from profile.
class _GuestLinkArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.yourReferralCode,
          style: context.textTheme.labelMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w400,
            fontSize: AppDimens.sp12,
          ),
        ),
        SizedBox(height: AppDimens.h12),
        Row(
          children: [
            InviteCodeCard(
              icon: Assets.icons.duplicate.svg(width: AppDimens.w20),
              title: context.l10n.linkAccountForCode,
              titleColor: context.themeColors.secondaryGradient4,
              onTap: () {
                context.goNamed(AppRoutes.profile);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Shown for non-guest users: their referral code and a share-only card.
class _ShareInviteSection extends StatelessWidget {
  final UserModel user;
  const _ShareInviteSection({required this.user});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<InviteEarnProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.yourReferralCode,
          style: context.textTheme.labelMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w400,
            fontSize: AppDimens.sp12,
          ),
        ),
        SizedBox(height: AppDimens.h8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.w14,
            vertical: AppDimens.h12,
          ),
          decoration: BoxDecoration(
            color: context.themeColors.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimens.r12),
            border: Border.all(
              color: context.themeColors.secondaryGradient4.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Text(
            user.userId,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.themeColors.secondaryGradient4,
              fontWeight: FontWeight.w600,
              fontSize: AppDimens.sp14,
            ),
          ),
        ),
        SizedBox(height: AppDimens.h12),
        Row(
          children: [
            InviteCodeCard(
              icon: Assets.icons.expandArrow.svg(width: AppDimens.w20),
              title: context.l10n.shareYourCodeAndEarn,
              gradient: const LinearGradient(
                colors: [Color(0xFF424EFE), Color(0xFF9467FF)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              onTap: () => provider.shareReferralCode(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Text input + send button for entering a friend's referral code.
class _EnterInviteCodeView extends StatelessWidget {
  const _EnterInviteCodeView();

  @override
  Widget build(BuildContext context) {
    final themeColors = context.themeColors;
    return Consumer<InviteEarnProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.all(AppDimens.w8),
          decoration: BoxDecoration(
            color: themeColors.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimens.r12),
          ),
          child: Row(
            children: [
              Expanded(
                child: AppInputField(
                  controller: provider.refferalController,
                  cursorColor: themeColors.secondaryGradient4,
                  keyboardType: TextInputType.text,
                  hintText: context.l10n.enterFriendsCode,
                  suffixIcon: GestureDetector(
                    onTap: provider.isApplyingReferral
                        ? null
                        : () => provider.validateReferralCode(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeColors.secondaryGradient3,
                            themeColors.secondaryGradient4,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppDimens.r12),
                          topRight: Radius.circular(AppDimens.r12),
                          bottomRight: Radius.circular(AppDimens.r12),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.w14,
                          vertical: AppDimens.h10,
                        ),
                        child: provider.isApplyingReferral
                            ? SizedBox(
                                width: AppDimens.w24,
                                height: AppDimens.w24,
                                child: const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Assets.icons.expandArrow.svg(width: AppDimens.w24),
                      ),
                    ),
                  ),
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontSize: AppDimens.sp16,
                    fontWeight: FontWeight.w400,
                  ),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontSize: AppDimens.sp16,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return context.l10n.pleaseEnterReferralCode;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Shown after a referral code has been successfully applied.
class _InviteAppliedView extends StatelessWidget {
  final String code;
  const _InviteAppliedView({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w14,
        vertical: AppDimens.h14,
      ),
      decoration: BoxDecoration(
        color: context.themeColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.r12),
        border: Border.all(
          color: context.themeColors.secondaryGradient3.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimens.w36,
            height: AppDimens.w36,
            decoration: BoxDecoration(
              color: context.themeColors.secondaryGradient3.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check_rounded,
              color: context.themeColors.secondaryGradient3,
              size: AppDimens.w22,
            ),
          ),
          SizedBox(width: AppDimens.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.codeApplied,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeTextColors.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimens.sp14,
                  ),
                ),
                SizedBox(height: AppDimens.h2),
                Text(
                  code,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.themeTextColors.descriptionColor,
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<InviteEarnProvider>(
      builder: (context, provider, _) {
        return GestureDetector(
          onTap: provider.isRating ? null : () => provider.rateApp(),
          child: Container(
            width: double.infinity,
            height: AppDimens.h54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5E5CE6),
                  Color(0xFFFF2D55),
                  Color(0xFFFF9F0A),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(AppDimens.r18),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: provider.isRating
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    context.l10n.rateAndGetReward,
                    strutStyle: StrutStyle(
                      fontSize: AppDimens.sp16,
                      height: 1.1,
                      forceStrutHeight: true,
                    ),
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.themeTextColors.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: AppDimens.sp16,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _ReviewedView extends StatelessWidget {
  const _ReviewedView();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w14,
        vertical: AppDimens.h14,
      ),
      decoration: BoxDecoration(
        color: context.themeColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.r12),
        border: Border.all(
          color: context.themeColors.secondaryGradient3.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimens.w36,
            height: AppDimens.w36,
            decoration: BoxDecoration(
              color: context.themeColors.secondaryGradient3.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.star_rounded,
              color: context.themeColors.secondaryGradient3,
              size: AppDimens.w22,
            ),
          ),
          SizedBox(width: AppDimens.w12),
          Expanded(
            child: Text(
              context.l10n.youAlreadyRatedApp,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.themeTextColors.textColor,
                fontWeight: FontWeight.w600,
                fontSize: AppDimens.sp14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
