import 'package:flutter/material.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

class LearnPage extends StatelessWidget {
    Widget build(BuildContext context) {
      var loc = AppLocalizations.of(context);
      return Container(
        color: primaryColorLight,
        child: Center(
          child: Text(loc.notImplementedYet),
        ),
      );
    }
}