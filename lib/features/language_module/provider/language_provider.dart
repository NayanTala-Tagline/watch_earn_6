import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:flutter/material.dart';

import '../model/language_model.dart';

class LanguageProvider extends ChangeNotifier {
  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(name: 'English', nativeName: 'English', code: 'en'),
    LanguageModel(name: 'Hindi', nativeName: 'हिन्दी', code: 'hi'),
    LanguageModel(name: 'Spanish', nativeName: 'Español', code: 'es'),
    LanguageModel(name: 'French', nativeName: 'Français', code: 'fr'),
    LanguageModel(name: 'Arabic', nativeName: 'العربية', code: 'ar'),
    LanguageModel(name: 'Portuguese', nativeName: 'Português', code: 'pt'),
    LanguageModel(name: 'German', nativeName: 'Deutsch', code: 'de'),
    LanguageModel(name: 'Chinese', nativeName: '中文', code: 'zh'),
  ];

  Locale _selectedLocale = Locale(
    Injector.instance<AppDB>().selectedLangauge ?? 'en',
  );

  Locale get selectedLocale => _selectedLocale;

  String get selectedLanguageName => supportedLanguages
      .firstWhere(
        (l) => l.code == _selectedLocale.languageCode,
        orElse: () => supportedLanguages.first,
      )
      .name;

  void selectLanguage(LanguageModel language) {
    _selectedLocale = Locale(language.code);
    Injector.instance<AppDB>().selectedLangauge = language.code;
    notifyListeners();
  }

  bool isSelected(LanguageModel language) =>
      _selectedLocale.languageCode == language.code;
}
