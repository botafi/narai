
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:narai/interpreter/qr.dart';

enum NodeType {
  ROOT,
  LITERAL,
  VARIABLE,
  ADD_OPERATOR,
  SUBSTRACT_OPERATOR,
  POWER_OPERATOR,
  MULTIPLY_OPERATOR,
  DIVIDE_OPERATOR,
  ADD_EQUALS_OPERATOR,
  SUBSTRACT_EQUALS_OPERATOR,
  MULTIPLY_EQUALS_OPERATOR,
  DIVIDE_EQUALS_OPERATOR,
  POWER_EQUALS_OPERATOR,
  EQUALS_OPERATOR,
  IS_EQUAL_OPERATOR,
  IS_NOT_EQUAL_OPERATOR,
  IS_LESS_OR_EQUAL_OPERATOR,
  IS_MORE_OR_EQUAL_OPERATOR,
  IS_LESS_OPERATOR,
  IS_MORE_OPERATOR,
  NOT_OPERATOR,
  OR_OPERATOR,
  AND_OPERATOR,
  FUNCTION_CALL,
  FUNCTION_DECLARATION,
  IF,
  ELSE,
  ELSEIF,
  REPEAT,
  END,
  RETURN,
  HELPER
}

class Node {
  NodeType type;
  Node parent;
  Node elseStatement;
  ListQueue<Node> children;
  List<Node> parameters;
  String value;
  Type variableType;
  Function nativeFunc;
  Type returnType;
  int line;
  int position;
  QR qr;
  QRLine qrLine;
  Map<String,Object> variables; 
  Node({
      @required this.type,
      this.parent,
      this.children,
      this.parameters,
      this.value,
      this.elseStatement,
      this.variableType,
      this.nativeFunc,
      this.returnType,
      this.variables,
      this.line,
      this.position,
      this.qr,
      this.qrLine
  }) {
    if(this.children == null) {
      this.children = ListQueue();
    }
    if(this.variables == null) {
      this.variables = {};
    }
    if(this.parameters == null) {
      this.parameters = [];
    }
  }
  Node.positional(
      this.type,
      this.parent,
      this.children,
      this.parameters,
      this.value,
      this.elseStatement,
      this.variableType,
      this.nativeFunc,
      this.returnType,
      this.variables,
      this.line,
      this.position,
      this.qr,
      this.qrLine
  ) {
    if(this.children == null) {
      this.children = ListQueue();
    }
    if(this.variables == null) {
      this.variables = {};
    }
    if(this.parameters == null) {
      this.parameters = [];
    }
  }
  @override
  String toString() {
      var string = "${this.type.toString().split(".")[1]} ";
      if(this.parameters != null && this.parameters.isNotEmpty)
        string += "[${this.parameters.map((n) => n.toString()).join(", ")}]";
      if(this.value != null)
        string += "('${this.value}') ";
      if(this.children.isNotEmpty)
        string += "{ ${this.children.map((n) => n.toString()).join(", ")}}";
      if(this.elseStatement != null)
        string += " ${this.elseStatement}";
      return string;
    }
  Node clone() {
    return Node.positional(
      type,
      parent,
      children,
      parameters,
      value,
      elseStatement,
      variableType,
      nativeFunc,
      returnType,
      variables,
      line,
      position,
      qr,
      qrLine
    );
  }
}