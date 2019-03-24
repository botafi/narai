import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:narai/l10n/messages_all.dart';

class AppLocalizations {
  static const supportedLocales = [
    Locale('en', ''),
    Locale('cs', ''),
  ];
  static AppLocalizations instance; 
  static Locale currentLocale;

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      instance = AppLocalizations();
      currentLocale = locale;
      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appTitle {
    return Intl.message(
      'Narai',
      name: 'appTitle',
      desc: 'Name of the app - title',
    );
  }
  String get playground {
    return Intl.message(
      'Playground',
      name: 'playground',
      desc: 'Playground tab text',
    );
  }
  String get learn {
    return Intl.message(
      'Learn',
      name: 'learn',
      desc: 'Learn tab text',
    );
  }
  String get rating1Text {
    return Intl.message(
      'Good work!',
      name: 'rating1Text',
      desc: 'rating for 1 star',
    );
  }
  String get rating2Text {
    return Intl.message(
      "Well done!",
      name: 'rating2Text',
      desc: 'rating for 2 stars',
    );
  }
  String get rating3Text {
    return Intl.message(
      "Very nice!",
      name: 'rating3Text',
      desc: 'rating for 3 stars',
    );
  }
  String get lessons {
    return Intl.message(
      'Lessons',
      name: 'lessons',
      desc: 'Lessons tab text',
    );
  }
  String get lesson {
    return Intl.message(
      'Lesson',
      name: 'lesson',
      desc: 'Lesson tab text',
    );
  }
  String get nextLesson {
    return Intl.message(
      'Next lesson',
      name: 'nextLesson',
      desc: 'Next lesson button text',
    );
  }
  String get info {
    return Intl.message(
      'Information',
      name: 'info',
      desc: 'Info tab text',
    );
  }
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: 'Settings tab text',
    );
  }
  String get result {
    return Intl.message(
      'Result',
      name: 'result',
      desc: 'result of some operation',
    );
  }
  String get rerun {
    return Intl.message(
      'Run again',
      name: 'rerun',
      desc: 'Rerun program',
    );
  }
  String get run {
    return Intl.message(
      'Run',
      name: 'run',
      desc: 'Run program',
    );
  }
  String get scanCards {
    return Intl.message(
      'Scan cards',
      name: 'scanCards',
      desc: 'Scan cards',
    );
  }
  String get scanAdditionalCards {
    return Intl.message(
      'Scan additional cards',
      name: 'scanAdditionalCards',
      desc: 'Scan additional cards',
    );
  }
  String get cardsPreviewTitle {
    return Intl.message(
      'Cards',
      name: 'cardsPreviewTitle',
      desc: 'Cards preview title',
    );
  }
  String get cardsPreviewSubtitle {
    return Intl.message(
      'Preview of scanned cards - you can see your card program here. Make sure it\'s scanned correctly. On the right of the cards you can see what the line of cards equals to.',
      name: 'cardsPreviewSubtitle',
      desc: 'Cards preview title',
    );
  }
  String get resultsPreviewSubtitle {
    return Intl.message(
      'Result of running card program. You can see what you have returned and what should be the correct answer.',
      name: 'resultsPreviewSubtitle',
      desc: 'Results preview card subtitle',
    );
  }
  String get playgroundDescriptionSubtitle {
    return Intl.message(
      'You can try your card programs here! You can use RETURN to show results.',
      name: 'playgroundDescriptionSubtitle',
      desc: 'Playground output card subtitle',
    );
  }
  String get cards {
    return Intl.message(
      'Cards',
      name: 'cards',
      desc: 'Cards',
    );
  }
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: 'Back button',
    );
  }
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: 'Clear button',
    );
  }
  String get resultsPreviewEmpty {
    return Intl.message(
      'Run your card program and do something to see results here.',
      name: 'resultsPreviewEmpty',
      desc: 'Results preview card empty rows',
    );
  }
  String get cardsPreviewEmpty {
    return Intl.message(
      'Scan your cards to see them here.',
      name: 'cardsPreviewEmpty',
      desc: 'Cards preview card empty card program',
    );
  }
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: 'Success',
    );
  }
  String get error {
    return Intl.message(
      'Error! Try again!',
      name: 'error',
      desc: 'Error try again',
    );
  }
  String get variableNotDeclared {
    return Intl.message(
      'doesn\'t exist.',
      name: 'variableNotDeclared',
      desc: 'Variable is not declared',
    );
  }
  String lineNotCorrectPosition(int correctPosition) {
    return Intl.message(
      'Card row is not in correct place, should be row $correctPosition.',
      name: 'lineNotCorrectPosition',
      args: [correctPosition],
      examples: const {'correctPosition': 3},
      desc: 'Card line not correct position',
    );
  }
  String get lineNotFound {
    return Intl.message(
      'Cards not found or put together correctly.',
      name: 'lineNotFound',
      desc: 'Card line not found.',
    );
  }
  String returnNotCorrectPosition(Object result, int incorrectPosition, int correctPosition) {
    return Intl.message(
      '$result is not in correct place at $incorrectPosition, should be $correctPosition.',
      name: 'returnNotCorrectPosition',
      args: [result, incorrectPosition, correctPosition],
      examples: const {'correctPosition': 3, "result": 452},
      desc: 'Return not correct position',
    );
  }
  String returnNotFound(Object result) {
    return Intl.message(
      '$result not found.',
      name: 'returnNotFound',
      args: [result],
      examples: const {"result": 452},
      desc: 'Return line not found.',
    );
  }

  String get notImplementedYet {
    return Intl.message(
      'This feature hasn\'t been implemented yet. Coming soon!',
      name: 'notImplementedYet',
      desc: 'Nice text for not yet implemented feature.',
    );
  }

  String get cardsUnknowError {
    return Intl.message(
      'Error! \n Can\'t understand your card program! \n Please check your cards and try again!',
      name: 'cardsUnknowError',
      desc: 'Unknown card parsing or interpretation error',
    );
  }

  String cardsKnownError(int line) {
    return Intl.message(
      'Error in your card program! \n Can\'t understand line $line! \n Please check your cards and try again!',
      name: 'cardsKnownError',
      args: [line],
      examples: const {"line": 3},
      desc: 'Known card parsing or interpretation error on line..',
    );
  }

  String get manual {
    return Intl.message(
      'Manual',
      name: 'manual',
      desc: 'Manual',
    );
  }

  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: 'language',
    );
  }

  String get cs {
    return Intl.message(
      'Čeština',
      name: 'cs',
      desc: 'cs lang',
    );
  }

  String get en {
    return Intl.message(
      'English',
      name: 'en',
      desc: 'en lang',
    );
  }
}