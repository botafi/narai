import 'package:flutter/widgets.dart';
// import 'package:narai/blocs/interpreterBloc.dart';
// import 'package:narai/blocs/lessonsBloc.dart';
// import 'package:narai/etc/appLocalizations.dart';
// import 'package:narai/models/lesson.dart';
// import 'package:narai/widgets/applicationBlocProviderWidget.dart';
import 'package:narai/widgets/containers/qrCardsWidget.dart';

class LessonCardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var loc = AppLocalizations.of(context);
    // var interpreterBloc = ApplicationBlocProviderWidget.of<InterpreterBloc>(context);
    // var lessonsBloc = ApplicationBlocProviderWidget.of<LessonsBloc>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [ QRCardsWidget() ]
    );
  }

}