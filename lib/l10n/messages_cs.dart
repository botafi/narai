// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a cs locale. All the
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
  get localeName => 'cs';

  static m0(line) => "Máš chyby ve svém programu! \n Nerozumím lince ${line}! \n Zkontroluj svůj program z kartiček a zkus to znovu!";

  static m1(correctPosition) => "Řádek kartiček není na správném místě. Měl by být na místě ${correctPosition}.";

  static m2(result, incorrectPosition, correctPosition) => "${result} není na správném místě (${incorrectPosition}.), měl by být ${correctPosition}.";

  static m3(result) => "${result} nenalezen.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appTitle" : MessageLookupByLibrary.simpleMessage("Narai"),
    "back" : MessageLookupByLibrary.simpleMessage("Zpět"),
    "cards" : MessageLookupByLibrary.simpleMessage("Kartičky"),
    "cardsKnownError" : m0,
    "cardsPreviewEmpty" : MessageLookupByLibrary.simpleMessage("Naskenuj své karty, abys je tady viděl."),
    "cardsPreviewSubtitle" : MessageLookupByLibrary.simpleMessage("Přehled oskenovaných kartiček - můžeš tady vidět svůj program. Zkontroluj si, jestli je správně naskenovaný. Napravo od kartiček můžeš vidět výsledky z spuštění tvého programu. Můžeš je využít pro kontrolu."),
    "cardsPreviewTitle" : MessageLookupByLibrary.simpleMessage("Kartičky"),
    "cardsUnknowError" : MessageLookupByLibrary.simpleMessage("Chyba! \n Nerozumím tvému programu! \n Zkontroluj svůj program z kartiček a zkus to znovu!"),
    "clear" : MessageLookupByLibrary.simpleMessage("Vyčistit"),
    "cs" : MessageLookupByLibrary.simpleMessage("Čeština"),
    "en" : MessageLookupByLibrary.simpleMessage("Angličtina"),
    "error" : MessageLookupByLibrary.simpleMessage("Chyba! Zkus to znovu!"),
    "info" : MessageLookupByLibrary.simpleMessage("Informace"),
    "language" : MessageLookupByLibrary.simpleMessage("Jazyk"),
    "learn" : MessageLookupByLibrary.simpleMessage("Výuka"),
    "lesson" : MessageLookupByLibrary.simpleMessage("Lekce"),
    "lessons" : MessageLookupByLibrary.simpleMessage("Lekce"),
    "lineNotCorrectPosition" : m1,
    "lineNotFound" : MessageLookupByLibrary.simpleMessage("Kartičky nenalezeny, nebo byly poskládány špatně."),
    "manual" : MessageLookupByLibrary.simpleMessage("Manuál"),
    "nextLesson" : MessageLookupByLibrary.simpleMessage("Další lekce"),
    "notImplementedYet" : MessageLookupByLibrary.simpleMessage("Tahle funkce ještě není úplně hotová. Bude brzy!"),
    "playground" : MessageLookupByLibrary.simpleMessage("Hřiště"),
    "playgroundDescriptionSubtitle" : MessageLookupByLibrary.simpleMessage("Tady můžeš vyzkoušet svůj program!\nPouží kartičku RETURN pro zobrazení hodnot."),
    "rating1Text" : MessageLookupByLibrary.simpleMessage("Dobrá práce!"),
    "rating2Text" : MessageLookupByLibrary.simpleMessage("Skvělá práce!"),
    "rating3Text" : MessageLookupByLibrary.simpleMessage("Skvělé!"),
    "rerun" : MessageLookupByLibrary.simpleMessage("Spustit znovu"),
    "result" : MessageLookupByLibrary.simpleMessage("Výsledek"),
    "resultsPreviewEmpty" : MessageLookupByLibrary.simpleMessage("Spusť svůj program a udělej v něm něco, abys tu viděl výsledky."),
    "resultsPreviewSubtitle" : MessageLookupByLibrary.simpleMessage("Zde jsou výsledky spuštění tvého programu z kartiček. Můžeš zde vidět, co je vráceno anebo také hodnocení tvého programu."),
    "returnNotCorrectPosition" : m2,
    "returnNotFound" : m3,
    "run" : MessageLookupByLibrary.simpleMessage("Spustit"),
    "scanAdditionalCards" : MessageLookupByLibrary.simpleMessage("Doskenovat další kartičky"),
    "scanCards" : MessageLookupByLibrary.simpleMessage("Skenovat kartičky"),
    "settings" : MessageLookupByLibrary.simpleMessage("Nastavení"),
    "success" : MessageLookupByLibrary.simpleMessage("Úspěch"),
    "variableNotDeclared" : MessageLookupByLibrary.simpleMessage("neexistuje.")
  };
}
