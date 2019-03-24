import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/widgets/components/starsWidget.dart';

class SuccessModal extends StatelessWidget {
  Function onNextLessonPressed;
  int rating;
  SuccessModal({this.rating, this.onNextLessonPressed});

  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
    const ratingStyle = const TextStyle(fontSize: 22);
    final Map<int,Widget> ratingText = {
        1: Text(loc.rating1Text, style: ratingStyle),
        2: Text(loc.rating2Text, style: ratingStyle),
        3: Text(loc.rating3Text, style: ratingStyle),
      };
    return Dialog(
      insetAnimationDuration: Duration(milliseconds: 500),
      child: Container(
        // color: primaryColorLight,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StarsWidget(rating, size: 40),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.5),
              child: ratingText[rating]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(loc.nextLesson),
                  color: primaryColor,
                  textColor: Colors.white,
                  onPressed: this.onNextLessonPressed,
                ),
                FlatButton(
                  child: Text(loc.back),
                  textColor: Colors.black54,
                  onPressed: () => Navigator.pop(context),
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}