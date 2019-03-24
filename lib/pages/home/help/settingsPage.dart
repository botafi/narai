import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:narai/blocs/localizationBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

class SettingsPage extends StatelessWidget {
    Widget build(BuildContext context) {
      final loc = AppLocalizations.of(context);
      final localizationBloc = ApplicationBlocProviderWidget.of<LocalizationBloc>(context);
      return ListView(
          children: <Widget>[
            ListTile(
                title: Text(loc.settings, style: TextStyle(fontSize: cardMainTitleFontSize))
            ),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(loc.language, style: TextStyle(fontSize: cardTitleFontSize)),
                    StreamBuilder<Locale>(
                      stream: localizationBloc.locale,
                      builder: (BuildContext context, AsyncSnapshot<Locale> snapshot) =>
                        DropdownButton<Locale>(
                          items: AppLocalizations.supportedLocales.map((l) => DropdownMenuItem<Locale>(value: l, child: Text(Intl.message(l.languageCode, name: l.languageCode)))).toList(),
                          value: snapshot.data,
                          onChanged: (sl) => localizationBloc.loadLocale.add(sl),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
    }
}