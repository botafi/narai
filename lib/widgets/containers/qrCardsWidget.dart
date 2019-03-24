
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/interpreter/interpreter.dart';
import 'package:narai/interpreter/qr.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

class QRCardsWidget extends StatelessWidget {
  EdgeInsets getMargin(QR qr, QRLine qrLine, List<QRLine> qrLines) {
    // TODO: implement scope depth - let parser/interpreter assign it to qr line
    final operators = const ["+", "-", "*", "/", "^", "<", ">", "!", "=", "RETURN"];
    // final scopeOpeners = const ["IF", "FUNC"];
    final isFirst = qrLine.qrs.first == qr;
    final isOperator = operators.contains(qr.statement);
    // final index = qrLines.indexOf(qrLine);
    if(isFirst && isOperator)
      return EdgeInsets.only( right: 7 );
    else if(!isFirst && isOperator)
      return EdgeInsets.symmetric( horizontal: 7 );
    else if(isFirst)
      return EdgeInsets.only( left: 10 );
    else
      return EdgeInsets.only();
  }
  Widget buildEmpty(BuildContext context) {
    var loc = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: primaryColorLight,
          margin: EdgeInsets.only(top: 18),
          elevation: 3,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Text(loc.cardsPreviewEmpty, style: TextStyle(fontSize: 16, color: Colors.white))
          )
        )
      ]
    );
  }
  Widget buildCards(BuildContext context) {
    var interpreterBloc = ApplicationBlocProviderWidget.of<InterpreterBloc>(context);
    return StreamBuilder<List<QRLine>>(
      stream: interpreterBloc.qrLines,
      builder: (BuildContext context, AsyncSnapshot<List<QRLine>> snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data.length == 0) {
            return buildEmpty(context);
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: snapshot.data.map((QRLine qrLine) =>
                  Container(
                    color: qrLine.error != null ? Colors.redAccent.shade100 : null,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    margin: EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: qrLine.qrs.map((QR qr) =>
                        Container(
                          margin: getMargin(qr, qrLine, snapshot.data),
                          child: Image.asset(
                            qr.toAsset(),
                            height: 45,
                          )
                        ) as Widget
                      ).toList()
                        ..add(
                          Container(
                            margin: EdgeInsets.only(left: 4),
                            child: Text(qrLine.result != null ? qrLine.result.toString() : "", style: TextStyle(color: qrLine.result is Return ? primaryColorLight : Colors.black45, fontSize: 30))
                          )
                        )
                    )
                  )
                ).toList()
              )
            )
          );
        } else {
          return buildEmpty(context);
        }
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
    var interpreterBloc = ApplicationBlocProviderWidget.of<InterpreterBloc>(context);
    return Expanded(
      flex: 3,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(loc.cardsPreviewTitle, style: TextStyle(fontSize: cardTitleFontSize))
              ),
              subtitle: Text(loc.cardsPreviewSubtitle),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: this.buildCards(context)
              )
            )
          ]
        )
      )
    );
  }
}