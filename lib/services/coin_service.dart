import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/utils/logger.dart';

class CoinService {
  CoinService._();

  static final _cloudStore = FirebaseFirestore.instance;
  static final _localStore = Injector.instance<AppDB>();

  static Future<void> addCoins(int amount) async {
    final currentUser = _localStore.userModel;
    if (currentUser == null) return;

    final updatedCoin  = currentUser.coin + amount;
    final updatedXp    = (updatedCoin / 10).roundToDouble();
    final updatedLevel = ((updatedXp / 200).floor() + 1).toDouble();

    _localStore.userModel = currentUser.copyWith(coin: updatedCoin, xp: updatedXp, level: updatedLevel);

    try {
      await _cloudStore.collection('users').doc(currentUser.userId).update({
        'coin' : updatedCoin,
        'xp'   : updatedXp,
        'level': updatedLevel,
      });
    } catch (e) {
      'CoinService.addCoins error: $e'.logD;
    }
  }
}
