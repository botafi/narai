import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/blocs/lessonsBloc.dart';
import 'package:narai/controllers/lessonController.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/models/lesson.dart';
import 'package:narai/models/result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:narai/bloc/bloc.dart';


class LessonBloc extends Bloc {
  final LessonController _lessonController;

  final Sink<void> run;

  final Stream<List<Result>> result;
  final Stream<int> rating;
  final Stream<int> success;
  final Stream<void> ran;

  factory LessonBloc(LessonsBloc lessonsBloc, InterpreterBloc interpreterBloc) {
    final run = PublishSubject<void>(); 
    final lessonController = LessonController(interpreterBloc: interpreterBloc);

    lessonsBloc.lesson.forEach((l) => lessonController.lesson = l);

    final results = PublishSubject<Result>();
    run.forEach((_) => lessonController.run().forEach((r) => results.add(r)));
    // run.forEach((_) => results.addStream(lessonController.run()));
    // final results = run.switchMap((_) => lessonController.run()); // TODO: runs run multiple times critical
    final resultBuffer = results.bufferTest((r) => r.type == ResultType.SUCCESS || r.type == ResultType.FAIL);
    final ran = PublishSubject<void>();
    results.where((r) => r.type == ResultType.SUCCESS || r.type == ResultType.FAIL).forEach(ran.add);
    interpreterBloc.interpretationErrors.forEach((pIE) {
      if(pIE.qrLine != null) {
        results.add(Result(text: AppLocalizations.instance.cardsKnownError(pIE.qrLine.lineNum), type: ResultType.FAIL, color: "red"));
      } else {
        results.add(Result(text: AppLocalizations.instance.cardsUnknowError, type: ResultType.FAIL, color: "red"));
      }
      ran.add(null);
    });

    final result = BehaviorSubject<List<Result>>();
    // result.addStream(resultBuffer);
    resultBuffer.forEach(result.add);
    final rating = result.map(lessonController.rate);
    final success = rating.where((r) => r != 0);

    success.forEach((_) {
      lessonsBloc.saveLessons.add(null);
    });

    interpreterBloc.reseted.forEach((_) => result.add([]));

    return LessonBloc._(run, lessonController, result, ran, rating, success);
  }

  LessonBloc._(this.run, this._lessonController, this.result, this.ran, this.rating, this.success);

  void dispose() {
    this.run.close();
  }
}
