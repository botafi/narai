import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/models/result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:narai/bloc/bloc.dart';

class PlaygroundBloc extends Bloc {

  final Stream<List<Result>> results;

  factory PlaygroundBloc(InterpreterBloc interpreterBloc) {
    final returns = Observable(interpreterBloc.returns)
      .map((i) =>
        i
        .map((r) => Result(text: r.toString(), titleImage: "assets/cards/RETURN.png"))
        .toList()
    );
    final errors = Observable(interpreterBloc.interpretationErrors)
      .map((pIE) {
        if(pIE.qrLine != null) {
          return (Result(text: AppLocalizations.instance.cardsKnownError(pIE.qrLine.lineNum), type: ResultType.FAIL, color: "red"));
        } else {
          return (Result(text: AppLocalizations.instance.cardsUnknowError, type: ResultType.FAIL, color: "red"));
        }
      })
      .bufferWhen(interpreterBloc.interpretationDone);
    // final results = BehaviorSubject<List<Result>>();
    // results.addStream(Observable.merge([returns, errors]));
    return PlaygroundBloc._(returns);
  }
  PlaygroundBloc._(this.results);
  void dispose() {
  }
}