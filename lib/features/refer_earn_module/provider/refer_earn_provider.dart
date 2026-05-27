import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/shared/models/user_model.dart';
import 'package:daily_cash/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class ReferEarnProvider extends ChangeNotifier {
  final AppDB _db = Injector.instance<AppDB>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final InAppReview _inAppReview = InAppReview.instance;

  static const int referralReward = 1000;
  static const int rateReward = 1000;

  final TextEditingController refferalController = TextEditingController();

  bool _isApplyingReferral = false;
  bool get isApplyingReferral => _isApplyingReferral;

  bool _isRating = false;
  bool get isRating => _isRating;

  String? _errorText;
  String? get errorText => _errorText;

  UserModel? get _currentUser => _db.userModel;
  String get referralCode => _currentUser?.userId ?? '';

  /// Validate, look up the referrer, and credit both users.
  Future<void> validateReferralCode() async {
    if (_isApplyingReferral) return;

    final user = _currentUser;
    if (user == null) {
      'Something went wrong. Please try again.'.showErrorAlert();
      return;
    }

    if (user.isGuest) {
      'Please link your account first'.showErrorAlert();
      return;
    }

    if (user.referredBy != null && user.referredBy!.isNotEmpty) {
      'You have already used a referral code'.showInfoAlert();
      return;
    }

    final code = refferalController.text.trim();
    if (code.isEmpty) {
      _errorText = 'Please enter a referral code';
      notifyListeners();
      return;
    }

    if (code == user.userId) {
      _errorText = "You can't use your own referral code";
      notifyListeners();
      "You can't use your own referral code".showErrorAlert();
      return;
    }

    _errorText = null;
    _isApplyingReferral = true;
    notifyListeners();

    try {
      final referrerRef = _firestore.collection('users').doc(code);
      final selfRef = _firestore.collection('users').doc(user.userId);

      late double newSelfCoins;
      await _firestore.runTransaction((tx) async {
        final referrerSnap = await tx.get(referrerRef);
        if (!referrerSnap.exists) {
          throw _ReferralException('Invalid referral code');
        }

        final selfSnap = await tx.get(selfRef);
        if (!selfSnap.exists) {
          throw _ReferralException('Something went wrong. Please try again.');
        }

        final selfData = selfSnap.data()!;
        final referrerData = referrerSnap.data()!;

        final existingRef = selfData['referred_by'] as String?;
        if (existingRef != null && existingRef.isNotEmpty) {
          throw _ReferralException('You have already used a referral code');
        }

        final selfCoins =
            (selfData['coin'] as num).toDouble() + referralReward;
        final referrerCoins =
            (referrerData['coin'] as num).toDouble() + referralReward;
        newSelfCoins = selfCoins;

        tx.update(selfRef, {
          'referred_by': code,
          'coin': selfCoins,
        });
        tx.update(referrerRef, {
          'coin': referrerCoins,
        });
      });

      // Reflect new state locally so the screen rebuilds.
      _db.userModel = user.copyWith(
        referredBy: code,
        coin: newSelfCoins,
      );

      refferalController.clear();
      'Referral applied! +$referralReward coins'.showSuccessAlert();
    } on _ReferralException catch (e) {
      _errorText = e.message;
      e.message.showErrorAlert();
    } catch (e) {
      e.logE;
      _errorText = 'Could not apply referral. Please try again.';
      'Could not apply referral. Please try again.'.showErrorAlert();
    } finally {
      _isApplyingReferral = false;
      notifyListeners();
    }
  }

  /// Share the user's referral code via the system share sheet.
  Future<void> shareReferralCode() async {
    final code = referralCode;
    if (code.isEmpty) return;
    final text =
        'Join me on Daily Cash and earn coins! Use my referral code: $code';
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (e) {
      e.logE;
    }
  }

  /// Open the in-app review (or fall back to the store listing) and credit
  /// the user once. Subsequent calls are no-ops.
  Future<void> rateApp() async {
    if (_isRating) return;
    final user = _currentUser;
    if (user == null || user.hasRated) return;

    _isRating = true;
    notifyListeners();

    try {
      final available = await _inAppReview.isAvailable();
      if (available) {
        await _inAppReview.requestReview();
      } else {
        await _inAppReview.openStoreListing();
      }

      final newCoins = user.coin + rateReward;

      // Persist to Firestore for non-guest users; guests update locally only
      // and the value will carry over when they link their account.
      if (!user.isGuest) {
        await _firestore.collection('users').doc(user.userId).update({
          'coin': newCoins,
          'has_rated': true,
        });
      }

      _db.userModel = user.copyWith(
        coin: newCoins,
        hasRated: true,
      );

      'Thanks for rating! +$rateReward coins'.showSuccessAlert();
    } catch (e) {
      e.logE;
      'Could not open rating. Please try again.'.showErrorAlert();
    } finally {
      _isRating = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    refferalController.dispose();
    super.dispose();
  }
}

class _ReferralException implements Exception {
  final String message;
  _ReferralException(this.message);
}
