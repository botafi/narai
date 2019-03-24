
import 'dart:ui';

import 'package:narai/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class LocalizationBloc extends Bloc {

  final Sink<Locale> loadLocale;
  final Stream<Locale> onLoadLocale;

  final Sink<Locale> doLocaleLoad;
  final Sink<Locale> doLocaleLoaded;
  final Stream<Locale> onDoLocaleLoad;
  final Stream<Locale> onDoLocaleLoaded;

  final Stream<Locale> locale;

  factory LocalizationBloc() {
    final loadLocale = PublishSubject<Locale>(); 
    final onLoadLocale = loadLocale as Observable<Locale>;

    final doLocaleLoad = PublishSubject<Locale>();
    final doLocaleLoaded = PublishSubject<Locale>();

    final onDoLocaleLoad = doLocaleLoad as Observable<Locale>;
    final onDoLocaleLoaded = doLocaleLoaded as Observable<Locale>;

    final locale = BehaviorSubject<Locale>();
    Observable<Locale>.merge([onLoadLocale, onDoLocaleLoad, onDoLocaleLoaded]).forEach((l) => locale.add(l));

    return LocalizationBloc._(loadLocale, onDoLocaleLoad, onDoLocaleLoaded, locale, doLocaleLoad, doLocaleLoaded, onLoadLocale);
  }

  LocalizationBloc._(this.loadLocale, this.onDoLocaleLoad, this.onDoLocaleLoaded, this.locale, this.doLocaleLoad, this.doLocaleLoaded, this.onLoadLocale);

  void dispose() {
    this.loadLocale.close();
    this.doLocaleLoad.close();
    this.doLocaleLoaded.close();
  }
}