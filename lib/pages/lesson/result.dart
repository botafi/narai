import 'package:flutter/widgets.dart';
import 'package:narai/blocs/lessonBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/models/result.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';
import 'package:narai/widgets/components/successModal.dart';
import 'package:narai/widgets/containers/resultsWidget.dart';

class LessonResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
    var lessonBloc = ApplicationBlocProviderWidget.of<LessonBloc>(context);
    return Column(
      children: [
        StreamBuilder<List<Result>>(
          initialData: [],
          stream: lessonBloc.result,
          builder: (BuildContext context, AsyncSnapshot<List<Result>> snapshot) => ResultsWidget(results: snapshot.data),
        ),
      ]
    );
  }

}