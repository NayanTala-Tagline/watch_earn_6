import 'package:ad_manager/ad_manager.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class RevenueHelper {
  /// Sends ad impression revenue data to Firebase
  static Future<void> sendAdImpressionRevenueToFirebase({
    required double valueMicros,
    required String currencyCode,
    required PrecisionType precision,
    required String adUnitId,
  }) async {
    final firebaseAnalytics = FirebaseAnalytics.instance;
    final revenueAmount = microsToCurrency(valueMicros);

    final eventParams = {
      'currency': currencyCode,
      'value': revenueAmount,
      'formatted_revenue': revenueAmount.toStringAsFixed(6),
      'precision': precision.index,
      'ad_unit_id': adUnitId,
    };

    await firebaseAnalytics.logEvent(name: 'ad_impression', parameters: eventParams);
  }

  static double microsToCurrency(double micros) => micros / 1_000_000.0;
}
