import 'package:narai/interpreter/operators.dart';

class QR {
  static const ID_DIVIDER = ";";
  String value;
  String id;
  String statement;
  int line;
  int linePosition;
  QR({this.value, this.line, this.linePosition}) {
    var parts = this.value.split(ID_DIVIDER);
    this.id = parts[0];
    this.statement = parts[1];
  }
  String toAsset() {
    String name = this.statement;
    Operator op = langOperators.singleWhere((o) => o.sign == this.statement, orElse: () => null);
    if(op != null && name != VARIABLE && name != FUNCTION_CALL) {
      name = op.nodeType.toString()
      .replaceFirst("NodeType.", "")
      .replaceFirst("_OPERATOR", "");
    } else {
      switch (name) {
        case " ":
          name = "SPACE";
          break;
        case "(":
          name = "LEFT_BRACKET";
          break;
        case ")":
          name = "RIGHT_BRACKET";
          break;
        case "!":
          name = "NOT";
          break;
      }
    }
    return "assets/cards/$name.png";
  }
  factory QR.fromJSON(Map<String,dynamic> qr) {
    return QR(value: qr["value"], line: qr["line"], linePosition: qr["linePosition"]);
  }
  @override
  String toString() {
    return "QR(id: $id, statement: $statement, line: $line, linePosition: $linePosition)";
  }
}

abstract class QRApi {
  Future<Iterable<QR>> getQRs();
}

class QRLine {
  final List<QR> qrs;
  final String line;
  final int lineNum;
  Object result;
  Object error;
  factory QRLine(Iterable<QR> qrsIt) {
    final operators = const ["+", "-", "*", "/", "^", "<", ">", "!"];
    final nr = RegExp(r'^[0-9.]*$');
    final qrs = qrsIt.toList();
    final lineNum = qrs.first.line;
    final statements = qrs.map((qr) => qr.statement).toList();
    String line = "";
    for(int i = 0; i < statements.length; i++) {
      String statement = statements[i];
      int ni = i+1;
      if(
      ni < statements.length
      && !(nr.hasMatch(statement) && nr.hasMatch(statements[ni])) // not number
      && !(statement == "ELSE" && statements[ni] == "IF") // ELSE|IF
      && !(operators.contains(statement) && statements[ni] == "=")
      && !(statement == "=" && operators.contains(statements[ni]))
      ){
        line += "$statement ";
      } else {
        line += statement;
      }
    }
    return QRLine._(qrs, line, lineNum);
  }
  QRLine._(this.qrs, this.line, this.lineNum);
  static List<QRLine> divideQRsToLines(Iterable<QR> qrs) {
    if(qrs.isNotEmpty) {
      var lines = qrs.last.line;
      return List.generate(lines, (i) => QRLine(qrs.where((qr) => qr.line == i+1)));
    } else {
      return [];
    }
  }
}
