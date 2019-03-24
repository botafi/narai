import 'package:flutter/material.dart';
import 'package:narai/blocs/lessonsBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/models/lesson.dart';
import 'package:narai/routing.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';
import 'package:narai/widgets/components/lessonCardWidget.dart';
import 'package:rxdart/rxdart.dart';

class LessonsPage extends StatelessWidget {
    Widget build(BuildContext context) {
      final loc = AppLocalizations.of(context);
      final lessonsBloc = ApplicationBlocProviderWidget.of<LessonsBloc>(context);
      return StreamBuilder<Lessons>(
        stream: lessonsBloc.lessons,
        builder: (BuildContext context, AsyncSnapshot<Lessons> snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.lessons.length,
                itemBuilder: (BuildContext context, int index) {
                  final lesson = snapshot.data.lessons[index];
                  return GestureDetector(
                    key: Key(lesson.name),
                    onTap: lesson.unlocked ? () => router.navigateTo(context, "/lesson?name=${lesson.name}") : null,
                    child: LessonCardWidget(lesson)
                  );
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      );
    }
}