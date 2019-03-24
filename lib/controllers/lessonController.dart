
import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/blocs/lessonBloc.dart';
import 'package:narai/blocs/lessonsBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/models/lesson.dart';
import 'package:narai/models/result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

// Future<T> getOne<T>(Stream<T> source) async {
//   await for (T value in source) {
//     return value;
//   }
//   return null;
// }

class LessonController {
  bool success = true;
  bool ran = false;

  Lesson _lesson;
  Lesson get lesson => _lesson;
  set lesson(Lesson lesson) {
    _lesson = lesson;
    success = true;
    ran = false;
  }

  AppLocalizations get locs => AppLocalizations.instance;

  final InterpreterBloc interpreterBloc;
  LessonsBloc lessonsBloc;
  LessonBloc lessonBloc;
  LessonController({this.lessonBloc, this.lessonsBloc, this.interpreterBloc});

  Stream<Result> expectVariables(Map<String,String> expectVariables, LessonTest lessonTest) async* {
    this.interpreterBloc.interpret.add(true);
    await this.interpreterBloc.interpretationDone.first;
    var vars = await this.interpreterBloc.variablesState.first;
    var expectedVars = expectVariables.entries;
    for (var expectedVar in expectedVars) {
      String name = expectedVar.key.toLowerCase();
      String assetName = "assets/cards/$name.png";
      if(!vars.containsKey(name)) {
        success = false;
        yield Result(type: ResultType.BAD, color: "orange", textImage: assetName, text: locs.variableNotDeclared);
      } else if(vars[name] != double.parse(expectedVar.value)) {
        yield Result(type: ResultType.BAD, color: "orange", textImage: assetName, text: "≠ ${expectedVar.value}");
        success = false;
      } else {
        yield Result(type: ResultType.GOOD, color: "blue", textImage: assetName, text: "= ${expectedVar.value}");
      }
    }
  }

  Stream<Result> expectFunctions(List<Map<String,Object>> expectFunctions, LessonTest lessonTest) async* {
    for(Map<String,Object> test in expectFunctions) {
      List<Object> args = ["variable1", "variable2", "variable3"]
        .map((k) => test[k])
        .where((v) => v != null && v != "")
        .map((v) => double.parse(v))
        .toList();
      interpreterBloc.runFunction.add(Tuple2(test["name"] as String, args));
      await interpreterBloc.runFunctionDone.first;
      Object result = await interpreterBloc.runFunctionReturn.first;
      if(result == double.parse(test["result"])) {
        yield Result(type: ResultType.GOOD, color: "blue", titleImage: "assets/cards/RETURN.png", text: result);
      } else {
        yield Result(type: ResultType.BAD, color: "orange", titleImage: "assets/cards/RETURN.png", text: result);
      }
    }
  }

  Stream<Result> expectLines(List<String> expectLines, LessonTest lessonTest) async* {
    var lines = (await this.interpreterBloc.qrLines.first).map((ql) => ql.line).toList();
    for (var i = 0; i < expectLines.length; i++) {
      var index = lines.indexOf(expectLines[i]);
      if(index >= i || (index != -1 && lessonTest.checkOrder == false)) {
        yield Result(type: ResultType.GOOD, color: "blue", text: expectLines[i]); // TODO: add qrline
      } else if(index != -1) {
        success = false;
        yield Result(type: ResultType.BAD, color: "orange", text: locs.lineNotCorrectPosition(i + 1)); // TODO: add expected qrline image, expected position
      } else {
        success = false;
        yield Result(type: ResultType.BAD, color: "orange", text: locs.lineNotFound); // TODO: add expected qrline image, expected position
      }
    }
  }

  Stream<Result> expectReturns(List<String> expectReturns, LessonTest lessonTest) async* {
    this.interpreterBloc.interpret.add(true);
    await this.interpreterBloc.gotReturns.first;
    var returns = (await this.interpreterBloc.returns.first).map((r) => r.value).toList();
    for (var ret in returns) {
      yield Result(type: ResultType.INFO, color: "grey", titleImage: "assets/cards/RETURN.png", text: ret.toString());
    }
    for (var i = 0; i < expectReturns.length; i++) {
      var index = -1;
      for(var j = i; j < returns.length; j++) {
        if((double.tryParse(expectReturns[i]) ?? expectReturns[i]) == returns[j]) {
          index = j;
          break;
        }
      }
      if(index == i) {
        yield Result(type: ResultType.GOOD, color: "blue", titleImage: "assets/cards/RETURN.png", text: expectReturns[i]);
      } else if(index != -1) {
        success = false;
        yield Result(type: ResultType.BAD, color: "orange", titleImage: "assets/cards/RETURN.png", text: locs.returnNotCorrectPosition(expectReturns[i], index + 1, i + 1));// TODO: add where it should be after, before return
      } else {
        success = false;
        yield Result(type: ResultType.BAD, color: "orange", titleImage: "assets/cards/RETURN.png", text: locs.returnNotFound(expectReturns[i]));// TODO: expected return
      }
    }
  }

  Stream<Result> expectOutput(List<String> expectOutput, LessonTest lessonTest) async* {
    this.interpreterBloc.interpret.add(true);
    await this.interpreterBloc.interpretationDone.first;
    var returns = (await this.interpreterBloc.interpretation.first).toList();
    for (var i = 0; i < expectOutput.length; i++) {
      var index = -1;
      for(var j = i; j < returns.length; j++) {
        if(double.parse(expectOutput[i]) == returns[j]) {
          index = j;
          break;
        }
      }
      if(index <= i) {
        yield Result(type: ResultType.GOOD, color: "blue", text: expectOutput[i]);
      } else if(index != -1) {
        success = false;
        yield Result(type: ResultType.BAD, color: "orange", text: locs.returnNotCorrectPosition(expectOutput[i], index + 1, i + 1));// TODO: add where it should be after, before return
      } else {
        success = false;
        yield Result(type: ResultType.BAD, color: "orange", text: locs.returnNotFound(expectOutput[i]));// TODO: expected return
      }
    }
  }

  Stream<Result> run() async* {
    print("run func");
    ran = false;
    success = true;
    for (LessonTest lessonTest in lesson.lessonTests) {

      if(lessonTest.injectVariables != null && lessonTest.injectVariables.isNotEmpty && lessonTest.injectVariables["name"] != "") {
        this.interpreterBloc.addVariables.add(lessonTest.injectVariables.map((k, v) => MapEntry<String, Object>(k, double.tryParse(v) ?? v)));
      }

      if(lessonTest.expectVariables != null && lessonTest.expectVariables.isNotEmpty && lessonTest.expectVariables["name"] != "") {
        yield* this.expectVariables(lessonTest.expectVariables, lessonTest);
      }

      if(lessonTest.expectFunctions != null && lessonTest.expectFunctions.isNotEmpty && lessonTest.expectFunctions.first.isNotEmpty && lessonTest.expectFunctions.first["name"] != "") {
        yield* this.expectFunctions(lessonTest.expectFunctions, lessonTest);
      }

      if(lessonTest.expectLines != null && lessonTest.expectLines.isNotEmpty && lessonTest.expectLines.first != "") {
        yield* this.expectLines(lessonTest.expectLines, lessonTest);
      }

      if(lessonTest.expectOutput != null && lessonTest.expectOutput.isNotEmpty && lessonTest.expectOutput.first != "") {
        yield* this.expectOutput(lessonTest.expectOutput, lessonTest);
      }

      if(lessonTest.expectReturns != null && lessonTest.expectReturns.isNotEmpty && lessonTest.expectReturns.first != "") {
        yield* this.expectReturns(lessonTest.expectReturns, lessonTest);
      }

    }
    if(success) {
      yield Result(type: ResultType.SUCCESS, color: "green", text: locs.success);
    } else {
      yield Result(type: ResultType.FAIL, color: "red", text: locs.error);
    }
    ran = true;
  }

  int rate(Iterable<Result> results) {
    if(!ran) {
      return 0;
    }
    int errors = results.where((r) => r.type == ResultType.FAIL).length;
    int successes = results.where((r) => r.type == ResultType.SUCCESS).length;

    int rating = 0;
    if (errors == 0 && successes > 0) { // if (results.firstWhere((r) => r.type == ResultType.FAIL, orElse: () => null) == null && results.firstWhere((r) => r.type == ResultType.SUCCESS, orElse: () => null) != null) {
      rating = 3;
    } else {
      rating = 0;
    }

    if(rating > lesson.lessonRating.rating) {
      lesson.lessonRating.rating = rating;
    }

    return rating;
  }

}