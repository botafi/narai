import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/models/lesson.dart';
import 'package:narai/widgets/components/starsWidget.dart';

class LessonCardWidget extends StatelessWidget {
  Lesson lesson;
  LessonCardWidget(this.lesson);
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
      const Map<int,Widget> ratingIcon = const {
        1: const Icon(Icons.done, color: Colors.greenAccent),
        2: const Icon(Icons.done, color: Colors.greenAccent),
        3: const Icon(Icons.done_all, color: Colors.greenAccent),
      };
      const ratingStyle = const TextStyle(fontWeight: FontWeight.bold);
      final Map<int,Widget> ratingText = {
        1: Text(loc.rating1Text, style: ratingStyle),
        2: Text(loc.rating2Text, style: ratingStyle),
        3: Text(loc.rating3Text, style: ratingStyle),
      };
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.5),
      child: Container(
        decoration: BoxDecoration(color: lesson.unlocked ? Colors.white : Colors.black12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.5),
          leading: Container(
            padding: const EdgeInsets.only(right: 5.5),
            decoration: const BoxDecoration(
              border: const Border(
                right: const BorderSide(width: 1.0, color: Colors.black12)
              )
            ),
            child: lesson.rating != 0 ? ratingIcon[lesson.rating] : lesson.unlocked ? Container(width: 0, height: 0) : const Icon(Icons.lock),
          ),
          title: Text(
            lesson.title,
            style: const TextStyle(fontSize: cardTitleFontSize),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  StarsWidget(lesson.rating),
                  Container(
                    child: lesson.rating != 0 ? ratingText[lesson.rating] : Container(width: 0, height: 0),
                    margin: const EdgeInsets.only(left: 3)
                  ),
                ],
              ),
              Text(lesson.shortDescription),
            ]
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: lesson.unlocked ? primaryColorLight : Colors.black12, size: 30.0)),
      ),
    );
  }
}