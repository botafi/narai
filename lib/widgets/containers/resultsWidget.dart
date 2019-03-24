
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/blocs/playgroundBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/interpreter/qr.dart';
import 'package:narai/models/result.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

class ResultsWidget extends StatelessWidget {
  GlobalKey _listHolderKey = GlobalKey();
  final Iterable<Result> results;
  ResultsWidget({ Key key, @required this.results }) : super(key: key);

  Iterable<Widget> buildCardRowChildren(Result r) sync* {
    if(r.titleImage != null) {
      yield Image.asset(r.titleImage, height: 30);
    }
    if(r.title != null) {
      yield Text(r.title, style: TextStyle(fontSize: 27, color: Colors.black87, fontWeight: FontWeight.w300));
    }
    yield Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        r.textImage != null ? Image.asset(r.textImage, height: 30) : Container(height: 0, width: 0),
        Text(r.text, style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.w300))
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    const colors = {
      "red": secondaryColorLight,
      "blue": primaryColorLight,
      "green": secondaryGreen,
      "orange": secondaryOrange,
      "grey": Colors.grey,
    };
    var loc = AppLocalizations.of(context);
    return Expanded(
      flex: 2,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(loc.result, style: TextStyle(fontSize: cardTitleFontSize))
              ),
              subtitle: Text(loc.resultsPreviewSubtitle),
            ),
            Expanded(
              child: Container(
                key: this._listHolderKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: (results != null && results.isNotEmpty) ? results.map((r) =>
                            Row(
                              // mainAxisSize: MainAxisSize.max,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  constraints: BoxConstraints(minWidth: 340),
                                  child: Card(
                                      color: colors[r.color],
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: this.buildCardRowChildren(r).toList()
                                        )
                                      )
                                    )
                                )
                              ]
                            )
                          ).toList() : [
                            Card(
                              color: primaryColorLight,
                              margin: EdgeInsets.only(top: 18),
                              elevation: 3,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: Text(loc.resultsPreviewEmpty, style: TextStyle(fontSize: 16, color: Colors.white))
                              )
                            ),
                          ],
                        )
                      ]
                    )
                  )
                )
              )
            )
          ]
        )
      ),
    );
  }
}