import 'dart:math';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/dashboard_module/inner_screens/spin_disc/model/spin_disc_sector.dart';
import 'package:flutter/material.dart';

class SpinDiscProvider with ChangeNotifier {
  static const int totalSectors = 8;
  
  final List<int> _sectorValues = [25, 30, 20, 22, 24, 26, 29, 27];
  
  late final List<SpinDiscSector> sectors;

  SpinDiscProvider() {
    _initializeSectors();
  }

  void _initializeSectors() {
    // Initialized in updateSectors
  }

  void updateSectors(BuildContext context) {
    sectors = List.generate(totalSectors, (i) {
      // 0, 1, 6, 7 are the upper half (Teal)
      // 2, 3, 4, 5 are the lower half (Purple)
      final bool isTopZone = (i <= 1 || i >= 6); 
      
      return SpinDiscSector(
        value: _sectorValues[i],
        gradient: isTopZone
            ? context.themeColors.primaryGradient
            : context.themeColors.primaryGradient,
      );
    });
  }

  bool _isSpinning = false;
  bool get isSpinning => _isSpinning;

  double _currentRotation = 0;
  double get currentRotation => _currentRotation;

  int? _lastWin;
  int? get lastWin => _lastWin;


  int computeWinFromAngle(double angleRadians) {
    const double sweep = 2 * pi / totalSectors;

    // Normalise angle to [0, 2π)
    final double norm    = ((angleRadians % (2 * pi)) + 2 * pi) % (2 * pi);
    // Sector index under pointer
    final double shifted = ((-norm) % (2 * pi) + 2 * pi) % (2 * pi);
    final int    idx     = (shifted / sweep).floor() % totalSectors;

    _lastWin = _sectorValues[idx];
    return _lastWin!;
  }


  double spin() {
    if (_isSpinning) return _currentRotation;

    _isSpinning = true;
    _lastWin = null;
    notifyListeners();

    const double sweep     = 360.0 / totalSectors;
    final double fullSpins = 7.0 + Random().nextInt(4); // 7–10 full rotations
    final int    winIdx    = Random().nextInt(totalSectors);

    final double midLocal   = winIdx * sweep + sweep / 2;
    final double jitter     = (Random().nextDouble() - 0.5) * sweep * 0.6;
    final double targetMod  = (360.0 - midLocal + jitter + 360.0) % 360.0;

    _currentRotation += fullSpins * 360.0 + targetMod;
    return _currentRotation;
  }

  void completeSpin() {
    _isSpinning = false;
    notifyListeners();
  }
}
