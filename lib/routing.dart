import 'package:fluro/fluro.dart';
import 'package:narai/blocs/lessonsBloc.dart';
import 'package:narai/pages/homePage.dart';
import 'package:narai/pages/lessonPage.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

final router = Router();

void initRouter() {
  router.define(
    '/lesson',
    handler: Handler(handlerFunc: (context, parameters) {
      final name = parameters['name'][0];
      final lessonsBloc = ApplicationBlocProviderWidget.of<LessonsBloc>(context);
      lessonsBloc.requestLesson.add(name);
      return LessonPage(name: name);
    })
  );
  router.define(
    '/home',
    handler: Handler(handlerFunc: (context, parameters) {
      final screen = int.parse(parameters['screen'][0]);
      final lessonsBloc = ApplicationBlocProviderWidget.of<LessonsBloc>(context);
      lessonsBloc.requestLessons.add(null);
      return HomePage(screen: screen);
    })
  );
  router.define(
    '/',
    handler: Handler(handlerFunc: (context, parameters) {
      final screen = int.parse(parameters['screen'][0]);
      final lessonsBloc = ApplicationBlocProviderWidget.of<LessonsBloc>(context);
      lessonsBloc.requestLessons.add(null);
      return HomePage(screen: screen);
    })
  );
}