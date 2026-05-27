import 'dart:math';
import 'package:daily_cash/services/coin_service.dart';
import 'package:flutter/material.dart';

class ScratchPrizeProvider with ChangeNotifier {
  int _reward = 0;
  int get reward => _reward;

  bool _isClaimed = false;
  bool get isClaimed => _isClaimed;

  bool _isScratched = false;
  bool get isScratched => _isScratched;

  double _scratchProgress = 0.0;
  double get scratchProgress => _scratchProgress;

  ScratchPrizeProvider() {
    _generateRandomReward();
  }

  void _generateRandomReward() {
    // Reward between 25 and 30 coins as requested
    _reward = 25 + Random().nextInt(6);
    notifyListeners();
  }

  void updateProgress(double progress) {
    _scratchProgress = progress;
    if (progress > 40.0 && !_isScratched) {
      _isScratched = true;
      notifyListeners();
    }
  }

  /// Claims the reward and updates coins in Firestore + local Hive.
  /// [earnedCoins] overrides the shown reward when dynamic ad revenue is higher.
  Future<void> claimReward({int? earnedCoins}) async {
    if (_isClaimed) return;
    _isClaimed = true;
    notifyListeners();
    await CoinService.addCoins(earnedCoins ?? _reward);
  }

  void resetGame() {
    _isScratched     = false;
    _isClaimed       = false;
    _scratchProgress = 0.0;
    _generateRandomReward();
  }
}
