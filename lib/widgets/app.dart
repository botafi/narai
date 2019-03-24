import 'package:narai/blocs/applicationBlocProvider.dart';
import 'package:narai/blocs/localizationBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/localization/appLocalizationsDelegate.dart';
import 'package:narai/platform/lessonApi.dart';
import 'package:narai/platform/mainPlatformApi.dart';
import 'package:narai/routing.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';
import 'package:narai/pages/homePage.dart';
import 'package:narai/etc/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ApplicationBlocProvider _applicationBlocProvider;
  AppLocalizationsDelegate _appLocalizationsDelegate;

  _setAppLocalizationsDelegate([Locale l]) {
    _appLocalizationsDelegate = AppLocalizationsDelegate(
        onLocaleLoad: (l) => _applicationBlocProvider.get<LocalizationBloc>().doLocaleLoad.add(l),
        onLocaleLoaded: (l) => _applicationBlocProvider.get<LocalizationBloc>().doLocaleLoaded.add(l),
        overridenLocale: l
    );
  }
  @override
  void initState() {
    super.initState();
    _applicationBlocProvider = ApplicationBlocProvider(mainPlatformApi, flutterLessonApi);

    _setAppLocalizationsDelegate();
    
    _applicationBlocProvider.get<LocalizationBloc>().onLoadLocale.forEach((l) => this.setState(() {
      _setAppLocalizationsDelegate(l);
      _appLocalizationsDelegate.load(l);
    }));

    _applicationBlocProvider.get<LocalizationBloc>().onDoLocaleLoaded.forEach((_) => this.setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBlocProviderWidget(
      applicationBlocProvider: _applicationBlocProvider,
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).appTitle,
        theme: theme,
        initialRoute: '/',
        home: HomePage(),
        onGenerateRoute: router.generator,
        localizationsDelegates: [
          _appLocalizationsDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _appLocalizationsDelegate.overridenLocale,
      )
    );
  }
}
