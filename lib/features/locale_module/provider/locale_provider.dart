import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:flutter/material.dart';

import '../model/locale_model.dart';

class LocaleProvider extends ChangeNotifier {
  static const List<LocaleModel> supportedLanguages = [
    LocaleModel(name: 'English', nativeName: 'English', code: 'en'),
    LocaleModel(name: 'Hindi', nativeName: 'हिन्दी', code: 'hi'),
    LocaleModel(name: 'Spanish', nativeName: 'Español', code: 'es'),
    LocaleModel(name: 'French', nativeName: 'Français', code: 'fr'),
    LocaleModel(name: 'Arabic', nativeName: 'العربية', code: 'ar'),
    LocaleModel(name: 'Portuguese', nativeName: 'Português', code: 'pt'),
    LocaleModel(name: 'German', nativeName: 'Deutsch', code: 'de'),
    LocaleModel(name: 'Chinese', nativeName: '中文', code: 'zh'),
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

  void selectLanguage(LocaleModel language) {
    _selectedLocale = Locale(language.code);
    Injector.instance<AppDB>().selectedLangauge = language.code;
    notifyListeners();
  }

  bool isSelected(LocaleModel language) =>
      _selectedLocale.languageCode == language.code;
}
