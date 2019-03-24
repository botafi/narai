import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/widgets/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LessonApi {
  Future<Lessons> getLessons(Locale locale);
  Future<void> saveLessons(Lessons lessons);
}

class Lessons {
  List<Lesson> _lessons = [];
  int gotStars;
  set lessons(List<Lesson> lessons) {
    this._lessons = lessons ?? [];
    calculateGotStars();
  }
  List<Lesson> get lessons {
    return this._lessons;
  }
  Lessons([List<Lesson> lessons]) {
    this.lessons = lessons;
  }
  void calculateGotStars() {
    this.gotStars = this.lessons.length != 0 ? this.lessons.map((lesson) => lesson.rating).reduce((a, v) => a + v) : 0;
  }
  factory Lessons.fromJson(List<dynamic> lessonsDyn, List<dynamic> lessonRatingsDyn) {
    Lessons lessons = Lessons();
    List<Lesson> lessonsList = lessonsDyn.map((dynamic lessonDyn) {
      Lesson lesson = Lesson.fromJson(lessonDyn);
      LessonRating lessonRating = LessonRating(name: lesson.name, lesson: lesson);
      if(lessonRatingsDyn.length != 0) {
        dynamic lessonRatingDyn = lessonRatingsDyn.firstWhere((lessonRatingDyn) => lessonRatingDyn["name"] == lesson.name, orElse: () => null);
        if(lessonRatingDyn != null) {
          lessonRating = LessonRating.fromJson(lessonRatingDyn);
        }
      }
      lesson.lessonRating = lessonRating;
      lesson.lessons = lessons;
      return lesson;
    }).toList();
    lessons.lessons = lessonsList;
    return lessons;
  }
}

class LessonRating {
  String name;
  int rating;
  Lesson lesson;
  LessonRating({
    @required this.name,
    this.rating = 0,
    this.lesson
  });
  factory LessonRating.fromJson(Map<String,dynamic> lessonRating) {
    return LessonRating(name: lessonRating["name"], rating: lessonRating["rating"]);
  }
  Map<String, dynamic> toJson() =>
    {
      'name': name,
      'rating': rating,
    };
}
class LessonTest {
  Map<String,String> expectVariables;
  List<Object> expectReturns;
  List<Object> expectOutput;
  List<String> expectLines;
  List<Map<String,Object>> expectFunctions;
  Map<String,String> injectVariables;
  bool checkOrder = true;
  LessonTest({
    this.expectVariables,
    this.injectVariables,
    this.expectLines,
    this.expectOutput,
    this.expectFunctions,
    this.expectReturns,
    this.checkOrder = true
  });
  factory LessonTest.fromJson(Map<String,dynamic> lessonTest) {
    return LessonTest(
      expectReturns: List<String>.from(lessonTest["expectReturns"]),
      expectLines: List<String>.from(lessonTest["expectLines"]),
      expectOutput: List<String>.from(lessonTest["expectOutput"]),
      expectVariables: Map<String,String>.fromIterable(lessonTest["expectVariables"], key: (element) => element["name"], value: (element) => element["value"]),
      expectFunctions: List<Map<String, dynamic>>.from(lessonTest["expectFunctions"]).map((ef) => Map<String,Object>.from(ef)).toList(),
      injectVariables: lessonTest["injectVariables"] != null ? Map<String,String>.fromIterable(lessonTest["injectVariables"], key: (element) => element["name"], value: (element) => element["value"]) : null,
    );
  }
}
class Lesson {
  int get rating {
    return this.lessonRating.rating;
  }
  bool get unlocked {
    return this.lessons.gotStars >= this.requiredStars;
  }
  LessonRating lessonRating;
  Lessons lessons;
  int maxStars;
  int requiredStars;
  String name;
  String title;
  String shortDescription;
  String description;
  List<LessonTest> lessonTests;
  Lesson({
    @required this.name,
    @required this.title,
    this.shortDescription = "",
    this.maxStars = 3,
    this.requiredStars = 0,
    this.description = "",
    this.lessonRating,
    this.lessonTests
  }) {
    if(this.lessonRating == null) {
      this.lessonRating = LessonRating(name: this.name, lesson: this);
    }
  }
  factory Lesson.fromJson(Map<String,dynamic> lesson) {
    return Lesson(
      name: lesson["name"], title: lesson["title"], shortDescription: lesson["shortDescription"],
      maxStars: lesson["maxStars"], requiredStars: lesson["requiredStars"], description: lesson["description"],
      lessonTests: List<Map<String, dynamic>>.from(lesson["lessonTests"]).map((lt) => LessonTest.fromJson(lt)).toList()
    );
  }
}
