import 'package:flutter/cupertino.dart';

class PreferenceProvider extends ChangeNotifier {
  bool _soundEffects = true;
  bool _hapticFeedback = true;

  bool get soundEffects => _soundEffects;
  bool get hapticFeedback => _hapticFeedback;

  void toggleSoundEffects(bool value) {
    _soundEffects = value;
    notifyListeners();
  }

  void toggleHapticFeedback(bool value) {
    _hapticFeedback = value;
    notifyListeners();
  }
}
