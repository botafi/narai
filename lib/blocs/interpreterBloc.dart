import 'package:narai/interpreter/interpreter.dart';
import 'package:narai/interpreter/parseError.dart';
import 'package:narai/interpreter/parser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:narai/bloc/bloc.dart';
import 'package:narai/interpreter/qr.dart';
import 'package:tuple/tuple.dart';

class InterpreterBloc extends Bloc {
  final QRApi _qrApi;
  final Parser parser;
  final Interpreter interpreter;

  final Sink<void> requestQRs;
  final Sink<bool> interpret;
  final Sink<void> reset;
  final Sink<MapEntry<String,Object>> setVarible;
  final Sink<Map<String,Object>> addVariables;
  final Sink<NativeFunctionDeclaration> addFunction;

  final Stream<void> qrsCaptured;
  final Stream<Iterable<QR>> qrs;
  final Stream<List<QRLine>> qrLines;
  final Stream<Object> interpretations;
  final Stream<void> interpretationDone;
  final Stream<List<Object>> interpretation;
  final Stream<Iterable<Return>> returns;
  final Stream<void> gotReturns;
  final Stream<Map<String,Object>> variablesState;
  final Stream<void> reseted;
  final Stream<ParseInterpretError> interpretationErrors;

  final Sink<Tuple2<String,List<Object>>> runFunction;
  final Stream<Object> runFunctionReturn;
  final Stream<List<Object>> runFunctionOutput;
  final Stream<void> runFunctionDone;

  factory InterpreterBloc(QRApi qrApi) {
    final parser = Parser();
    final interpreter = Interpreter(parser);

    final requestQRs = BehaviorSubject<void>();
    final interpret = BehaviorSubject<bool>();
    final reset = BehaviorSubject<void>();
    final reseted = PublishSubject<void>();
    final setVariable = PublishSubject<MapEntry<String,Object>>();
    final addVariables = PublishSubject<Map<String,Object>>();
    final addFunction = PublishSubject<NativeFunctionDeclaration>();
    final interpretationDone = PublishSubject<void>();
    final qrs = BehaviorSubject<Iterable<QR>>();
    final qrsCaptured = PublishSubject<Iterable<QR>>();
    final qrLines = BehaviorSubject<List<QRLine>>();

    final interpretationErrors = PublishSubject<ParseInterpretError>();

    final interpretations = BehaviorSubject<Object>();
    final variablesState = BehaviorSubject<Map<String,Object>>();
    Iterator<Object> interpreterIterable;
    interpret
      .forEach((bool all) {
        try {
          if(interpreterIterable == null || !interpreterIterable.moveNext()) {
            interpreterIterable = interpreter.interpretGen().iterator;
          }

          do { interpretations.add(interpreterIterable.current); variablesState.add(interpreter.getAllVariables()); }
            while(all && interpreterIterable.moveNext());

          if(interpreterIterable.current == null) {
            interpretationDone.add(null);
          }
        } catch (e, s) {
          if (!(e is ParseInterpretError)) {
            interpretationErrors.add(ParseInterpretError(message: e, stackTrace: s));
            interpretationDone.add(null);
            return;
          }
          interpretationErrors.add(e);
          if(e.qrLine != null) {
            qrLines.add(qrLines.value);
          }
          interpretationDone.add(null);
          print("Caught: $e");
          print("Stack: $s");
        }
    });

    final Observable<List<Object>> interpretation = interpretations
      .bufferTest((i) => i is Done);
    // final Observable<Iterable<Return>> returns = interpretation
    //   .map((l) =>
    //     l
    //     .where((o) => (o is Return))
    //     .map((o) => (o as Return))
    //   );
    final returns = BehaviorSubject<Iterable<Return>>();
    final gotReturns = PublishSubject<void>();
    returns.addStream(
    interpretation
      .map((l) =>
        l
        .where((o) => (o is Return))
        .map((o) => (o as Return))
      )
    );
    returns.forEach((rs) => gotReturns.add(null));

    requestQRs
      .debounce(Duration(milliseconds: 200))
      .forEach((_) async {
        qrs.add(await qrApi.getQRs());
        qrsCaptured.add(null);
      }); // hack, future needs to resolve imidietly or app crashes (flutter native call problem)
    // final Observable<Iterable<QRLine>> qrLines = qrs.map(QRLine.divideQRsToLines);
    
    qrs.forEach((qr) => qrLines.add(QRLine.divideQRsToLines(qr)));
    qrLines.forEach((ql) => parser.setQRLines(ql));

    interpretation.forEach((_) => qrLines.add(qrLines.value)); // republish last qrlines after interpretation

    setVariable.forEach((v) => interpreter.setGlobalVariable(v));
    addVariables.forEach((vs) => interpreter.addGlobalVariables(vs));
    addFunction.forEach((f) => parser.addNativeFunction(f));

    reset.forEach((_) {
      interpreterIterable = null;
      interpretations.add(Done());
      qrs.add([]);
      reseted.add(null);
    });

    final runFunction = PublishSubject<Tuple2<String,List<Object>>>();
    final runFunctionReturn = BehaviorSubject<Object>();
    final runFunctionOutput = BehaviorSubject<List<Object>>();
    final runFunctionDone = PublishSubject<void>();
    runFunction.forEach((a) {
      Iterable<Object> iter = interpreter.runFunction(a.item1, a.item2);
      List<Object> list = iter.toList();
      runFunctionOutput.add(list);
      runFunctionReturn.add(list[list.length - 1] ?? null);
      runFunctionDone.add(null);
    });

    return InterpreterBloc._(interpret, setVariable, addVariables, parser, interpreter, addFunction, returns, interpretations, qrApi, requestQRs, qrs, interpretationDone, interpretation, qrLines, reset, qrsCaptured, variablesState, reseted, gotReturns, runFunction, runFunctionReturn, runFunctionOutput, runFunctionDone, interpretationErrors);
  }

  InterpreterBloc._(this.interpret, this.setVarible, this.addVariables, this.parser, this.interpreter, this.addFunction, this.returns, this.interpretations, this._qrApi, this.requestQRs, this.qrs, this.interpretationDone, this.interpretation, this.qrLines, this.reset, this.qrsCaptured, this.variablesState, this.reseted, this.gotReturns, this.runFunction, this.runFunctionReturn, this.runFunctionOutput, this.runFunctionDone, this.interpretationErrors);
  
  void dispose() {
    requestQRs.close();
    interpret.close();
    setVarible.close();
    addVariables.close();
    addFunction.close();
  }
}