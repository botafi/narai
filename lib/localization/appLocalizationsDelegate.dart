import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:narai/localization/appLocalizations.dart';

typedef _OnLocaleFunc = void Function(Locale locale);

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final _OnLocaleFunc onLocaleLoad;
  final _OnLocaleFunc onLocaleLoaded;
  final Locale overridenLocale;
  AppLocalizationsDelegate({this.onLocaleLoaded, this.onLocaleLoad, this.overridenLocale});

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.map((l) => l.languageCode).contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    if((overridenLocale == null && AppLocalizations.currentLocale == locale) || (overridenLocale != null && AppLocalizations.currentLocale == overridenLocale)) {
      return AppLocalizations.instance;
    }
    if(this.onLocaleLoad != null) {
      this.onLocaleLoad(locale);
    }
    AppLocalizations instance = await AppLocalizations.load(locale);
    if(this.onLocaleLoaded != null) {
      this.onLocaleLoaded(locale);
    }
    return instance;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}