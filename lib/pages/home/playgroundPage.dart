import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:narai/blocs/playgroundBloc.dart';
import 'package:narai/models/result.dart';
import 'package:narai/widgets/containers/qrCardsWidget.dart';
import 'package:narai/widgets/containers/resultsWidget.dart';
import 'package:real_rich_text/real_rich_text.dart';
import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

class PlaygroundPage extends StatelessWidget {
    Widget build(BuildContext context) {
      var loc = AppLocalizations.of(context);
      var playgroundBloc = ApplicationBlocProviderWidget.of<PlaygroundBloc>(context);
      var interpreterBloc = ApplicationBlocProviderWidget.of<InterpreterBloc>(context);
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ListTile(
                      title: Text(loc.playground, style: TextStyle(fontSize: cardMainTitleFontSize)),
                      subtitle: RealRichText([
                        TextSpan(text: loc.playgroundDescriptionSubtitle.split("RETURN")[0]),
                        ImageSpan(
                          AssetImage("assets/cards/RETURN.png"),
                          imageHeight: 23,
                          imageWidth: 48,
                        ),
                        TextSpan(text: loc.playgroundDescriptionSubtitle.split("RETURN")[1]),
                      ]),
                    ),
                    QRCardsWidget(),
                    StreamBuilder<List<Result>>(
                      initialData: [],
                      stream: playgroundBloc.results,
                      builder: (BuildContext context, AsyncSnapshot<List<Result>> snapshot) => ResultsWidget(results: snapshot.data),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton.icon(
                            color: primaryColor,
                            colorBrightness: secondaryColorBrightness,
                            icon: const Icon(Icons.photo_camera),
                            label: Text(loc.scanCards),
                            onPressed: () => interpreterBloc.requestQRs.add(null),
                          ),
                          RaisedButton.icon(
                            color: secondaryGreen,
                            colorBrightness: secondaryGreenBrightness,
                            label: Text(loc.run),
                            // icon: Container(child: const Icon(FontAwesomeIcons.code, size: 20), padding: const EdgeInsets.only(right: 5, bottom: 2)),
                            icon: const Icon(FontAwesomeIcons.play, size: 17),
                            onPressed: () => interpreterBloc.interpret.add(true),
                          )
                        ],
                      )
                    )
                  ],
                ),
            )
          )
        ],
      );
    }
}