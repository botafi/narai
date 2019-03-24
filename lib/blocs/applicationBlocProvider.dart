import 'package:narai/bloc/bloc.dart';
import 'package:narai/bloc/blocProvider.dart';
import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/blocs/lessonBloc.dart';
import 'package:narai/blocs/lessonsBloc.dart';
import 'package:narai/blocs/localizationBloc.dart';
import 'package:narai/blocs/playgroundBloc.dart';
import 'package:narai/interpreter/qr.dart';
import 'package:narai/models/lesson.dart';

class ApplicationBlocProvider extends BlocProvider {
  factory ApplicationBlocProvider(QRApi qrApi, LessonApi lessonApi) {
    final localizationBloc = LocalizationBloc();
    final interpreterBloc = InterpreterBloc(qrApi);
    final playgroundBloc = PlaygroundBloc(interpreterBloc);
    final lessonsBloc = LessonsBloc(lessonApi, interpreterBloc, localizationBloc);
    final lessonBloc = LessonBloc(lessonsBloc, interpreterBloc);
    return ApplicationBlocProvider._([ localizationBloc, interpreterBloc, playgroundBloc, lessonsBloc, lessonBloc ]);
  }
  ApplicationBlocProvider._([Iterable<Bloc> blocs]) : super(blocs);
}