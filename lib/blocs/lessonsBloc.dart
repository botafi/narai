import 'dart:ui';

import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/blocs/localizationBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/models/lesson.dart';
import 'package:rxdart/rxdart.dart';
import 'package:narai/bloc/bloc.dart';

Lessons _lessonsInstance;

class LessonsBloc extends Bloc {
  final LessonApi _lessonApi;

  final Sink<void> requestLessons;
  final Sink<void> saveLessons;
  final Sink<String> requestLesson;

  final Stream<Lessons> lessons;
  final Stream<Lesson> lesson;
  final Stream<String> nextLesson;

  factory LessonsBloc(LessonApi lessonApi, InterpreterBloc interpreterBloc, LocalizationBloc localizationBloc) {
    final requestLessons = PublishSubject<void>();
    final lessons = BehaviorSubject<Lessons>();
    requestLessons.forEach((_) async {
      final currentLocale = await localizationBloc.locale.first;
      final l = await lessonApi.getLessons(currentLocale);
      _lessonsInstance = l;
      lessons.add(l);
    });
    requestLessons.add(null);
    final requestLesson = PublishSubject<String>();
    requestLesson.forEach((_) => interpreterBloc.reset.add(null));
    final lesson = BehaviorSubject<Lesson>();
    requestLesson
      .switchMap((name) => lessons.map((lessons) => lessons.lessons.firstWhere((lesson) => lesson.name == name, orElse: () => null)))
      .forEach((l) => lesson.add(l));
    
    final nextLesson = BehaviorSubject<String>(seedValue: null);
    lesson.asyncMap((l) async {
      final lessonsIn = await lessons.first;
      final nextIndex = lessonsIn.lessons.indexOf(l) + 1;
      return lessonsIn.lessons.length > nextIndex ? lessonsIn.lessons[nextIndex].name : null;
    })
    .forEach((nl) => nextLesson.add(nl));

    final saveLessons = PublishSubject<void>();
    saveLessons.forEach((_) async {
      Lessons lastLessons = lessons.value;
      await lessonApi.saveLessons(lastLessons);
      // lessons.add(lastLessons);
    });

    return LessonsBloc._(lessonApi, requestLessons, lessons, requestLesson, lesson, saveLessons, nextLesson);
  }
  LessonsBloc._(this._lessonApi, this.requestLessons, this.lessons, this.requestLesson, this.lesson, this.saveLessons, this.nextLesson);
  void dispose() {
    requestLessons.close();
    requestLesson.close();
  }
}