import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/blocs/lessonsBloc.dart';
import 'package:narai/etc/theme.dart';
// import 'package:narai/etc/appLocalizations.dart';
import 'package:narai/models/lesson.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

class LessonDescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var loc = AppLocalizations.of(context);
    // var interpreterBloc = ApplicationBlocProviderWidget.of<InterpreterBloc>(context);
    var lessonsBloc = ApplicationBlocProviderWidget.of<LessonsBloc>(context);
    return StreamBuilder(
      stream: lessonsBloc.lesson,
      builder: (BuildContext context, AsyncSnapshot<Lesson> snapshot) {
        if (snapshot.hasData) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 10),
                  child: Text(snapshot.data.title, style: TextStyle(fontSize: cardMainTitleFontSize), textAlign: TextAlign.left),
                ),
                Expanded(child: Markdown(data: snapshot.data.description))
              ]
            )
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

}