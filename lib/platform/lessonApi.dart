import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/models/lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class FlutterLessonApi implements LessonApi {
  Future<Lessons> getLessons(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lessonRatingsJson = prefs.getString("lessonRatings");
    return await rootBundle.loadStructuredData<Lessons>(
      "assets/lessons.json",
      (String lessonsJson) => compute<Tuple3<String,String,Locale>, Lessons>(FlutterLessonApi._decodeLessons, Tuple3(lessonsJson, lessonRatingsJson, locale))
    );
  }

  static Lessons _decodeLessons(Tuple3<String,String,Locale> params) {
    String lessonsJson = params.item1;
    String lessonRatingsJson = params.item2;
    Locale locale = params.item3;
    List<dynamic> lessons = json.decode(lessonsJson);
    List<dynamic> lessonRatings;
    if(lessonRatingsJson != null && lessonRatingsJson != "") {
      lessonRatings = json.decode(lessonRatingsJson);
    } else {
      lessonRatings = [];
    }
    lessons.forEach((l) => l.addAll(l[locale.languageCode]["title"] != null && l[locale.languageCode]["title"] != "" ? l[locale.languageCode] : l["en"]));
    return Lessons.fromJson(lessons, lessonRatings);
  }
  static String _encodeLessonRatings(Lessons lessons) {
    return json.encode(lessons.lessons.map((l) => l.lessonRating.toJson()).toList());
  }

  Future<void> saveLessons(Lessons lessons) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lessonsJson = await compute<Lessons, String>(FlutterLessonApi._encodeLessonRatings, lessons);
    await prefs.setString("lessonRatings", lessonsJson);
  }
}

FlutterLessonApi flutterLessonApi = FlutterLessonApi();