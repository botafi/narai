// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'en';

  static m0(line) => "Error in your card program! \n Can\'t understand line ${line}! \n Please check your cards and try again!";

  static m1(correctPosition) => "Card row is not in correct place, should be row ${correctPosition}.";

  static m2(result, incorrectPosition, correctPosition) => "${result} is not in correct place at ${incorrectPosition}, should be ${correctPosition}.";

  static m3(result) => "${result} not found.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appTitle" : MessageLookupByLibrary.simpleMessage("Narai"),
    "back" : MessageLookupByLibrary.simpleMessage("Back"),
    "cards" : MessageLookupByLibrary.simpleMessage("Cards"),
    "cardsKnownError" : m0,
    "cardsPreviewEmpty" : MessageLookupByLibrary.simpleMessage("Scan your cards to see them here."),
    "cardsPreviewSubtitle" : MessageLookupByLibrary.simpleMessage("Preview of scanned cards - you can see your card program here. Make sure it\'s scanned correctly. On the right of the cards you can see what the line of cards equals to."),
    "cardsPreviewTitle" : MessageLookupByLibrary.simpleMessage("Cards"),
    "cardsUnknowError" : MessageLookupByLibrary.simpleMessage("Error! \n Can\'t understand your card program! \n Please check your cards and try again!"),
    "clear" : MessageLookupByLibrary.simpleMessage("Clear"),
    "cs" : MessageLookupByLibrary.simpleMessage("Čeština"),
    "en" : MessageLookupByLibrary.simpleMessage("English"),
    "error" : MessageLookupByLibrary.simpleMessage("Error! Try again!"),
    "info" : MessageLookupByLibrary.simpleMessage("Information"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "learn" : MessageLookupByLibrary.simpleMessage("Learn"),
    "lesson" : MessageLookupByLibrary.simpleMessage("Lesson"),
    "lessons" : MessageLookupByLibrary.simpleMessage("Lessons"),
    "lineNotCorrectPosition" : m1,
    "lineNotFound" : MessageLookupByLibrary.simpleMessage("Cards not found or put together correctly."),
    "manual" : MessageLookupByLibrary.simpleMessage("Manual"),
    "nextLesson" : MessageLookupByLibrary.simpleMessage("Next lesson"),
    "notImplementedYet" : MessageLookupByLibrary.simpleMessage("This feature hasn\'t been implemented yet. Coming soon!"),
    "playground" : MessageLookupByLibrary.simpleMessage("Playground"),
    "playgroundDescriptionSubtitle" : MessageLookupByLibrary.simpleMessage("You can try your card programs here! You can use RETURN to show results."),
    "rating1Text" : MessageLookupByLibrary.simpleMessage("Good work!"),
    "rating2Text" : MessageLookupByLibrary.simpleMessage("Well done!"),
    "rating3Text" : MessageLookupByLibrary.simpleMessage("Very nice!"),
    "rerun" : MessageLookupByLibrary.simpleMessage("Run again"),
    "result" : MessageLookupByLibrary.simpleMessage("Result"),
    "resultsPreviewEmpty" : MessageLookupByLibrary.simpleMessage("Run your card program and do something to see results here."),
    "resultsPreviewSubtitle" : MessageLookupByLibrary.simpleMessage("Result of running card program. You can see what you have returned and what should be the correct answer."),
    "returnNotCorrectPosition" : m2,
    "returnNotFound" : m3,
    "run" : MessageLookupByLibrary.simpleMessage("Run"),
    "scanAdditionalCards" : MessageLookupByLibrary.simpleMessage("Scan additional cards"),
    "scanCards" : MessageLookupByLibrary.simpleMessage("Scan cards"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "success" : MessageLookupByLibrary.simpleMessage("Success"),
    "variableNotDeclared" : MessageLookupByLibrary.simpleMessage("doesn\'t exist.")
  };
}
