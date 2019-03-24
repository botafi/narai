import 'dart:collection';
import 'package:narai/interpreter/node.dart';
import 'package:narai/interpreter/parseError.dart';
import 'package:narai/interpreter/parser.dart';


class Done {}
class Return {
  Object value;
  Return(Object value) {
    this.value = value;
  }
  @override
    String toString() {
      return this.value.toString();
      // return "Return(${this.value})";
    }
}

class Interpreter {
  ListQueue<Node> scopes;
  Parser _parser;
  Node lastInterpretedNode;
  Node _rootNode;
  List<Node> _declaredFunctions = [];
  Map<String,Object> customVariables = {};
  Interpreter(Parser parser, [Map<String,Object> initialVariables]) {
    _parser = parser;
    _rootNode = _parser.root;
    scopes = ListQueue.from([_rootNode]);
    lastInterpretedNode = _rootNode;
    _declaredFunctions = _parser.declaredFunctions;
    if(initialVariables != null) {
      _rootNode.variables = Map.from(initialVariables);
      customVariables = initialVariables;
    }
  }

  Iterable<Object> interpretGen() sync* {
    _parser.parse();
    _rootNode = _parser.root;
    scopes = ListQueue.from([_rootNode]);
    lastInterpretedNode = _rootNode;
    _declaredFunctions = _parser.declaredFunctions;
    lastInterpretedNode = null;
    _rootNode.variables = Map.from(customVariables);
    yield* interpretNodeGen(_rootNode);
    yield Done();
  }

  Iterable<Object> interpretNodeGen(Node node) sync* {
    switch(node.type) {
      case NodeType.VARIABLE:
        var variableName = interpretNodeGen(node.children.elementAt(0)).single;
        final assigmentOps = [NodeType.EQUALS_OPERATOR, NodeType.ADD_EQUALS_OPERATOR, NodeType.SUBSTRACT_EQUALS_OPERATOR, NodeType.DIVIDE_EQUALS_OPERATOR, NodeType.MULTIPLY_EQUALS_OPERATOR];
        if(assigmentOps.contains(node.parent.type) && node.parent.children.elementAt(1) != node) {
          // node.qrLine.result = variableName;
          yield variableName;
        } else {
          var scope = scopes.lastWhere((s) => s.variables.containsKey(variableName), orElse: () => scopes.last);
          var result = scope.variables[variableName] ?? 0.0;
          node.qrLine.result = result;
          yield result; // TODO: undefined variable logic
        }
        break;
      case NodeType.EQUALS_OPERATOR:
        var variableName = interpretNodeGen(node.children.elementAt(0)).single;
        var variableValue = interpretNodeGen(node.children.elementAt(1)).single;
        var scope = scopes.lastWhere(
          (s) => s.variables.containsKey(variableName),
          orElse: () => scopes.lastWhere((s) => s.type == NodeType.ROOT || s.type == NodeType.FUNCTION_DECLARATION, orElse: () => scopes.first)
        );
        node.qrLine.result = variableValue;
        yield scope.variables[variableName] = variableValue;
        break;
      // TODO: extract to function ??
      case NodeType.ADD_EQUALS_OPERATOR:
        var variableName = interpretNodeGen(node.children.elementAt(0)).single;
        var variableValue = interpretNodeGen(node.children.elementAt(1)).single;
        var scope = scopes.lastWhere((s) => s.variables.containsKey(variableName), orElse: () => scopes.last);
        yield scope.variables[variableName] = _objectToNum(scope.variables[variableName]) + _objectToNum(variableValue);
        break;
      case NodeType.SUBSTRACT_EQUALS_OPERATOR:
        var variableName = interpretNodeGen(node.children.elementAt(0)).single;
        var variableValue = interpretNodeGen(node.children.elementAt(1)).single;
        var scope = scopes.lastWhere((s) => s.variables.containsKey(variableName), orElse: () => scopes.last);
        yield scope.variables[variableName] = _objectToNum(scope.variables[variableName]) - _objectToNum(variableValue);
        break;
      case NodeType.MULTIPLY_EQUALS_OPERATOR:
        var variableName = interpretNodeGen(node.children.elementAt(0)).single;
        var variableValue = interpretNodeGen(node.children.elementAt(1)).single;
        var scope = scopes.lastWhere((s) => s.variables.containsKey(variableName), orElse: () => scopes.last);
        yield scope.variables[variableName] = _objectToNum(scope.variables[variableName]) * _objectToNum(variableValue);
        break;
      case NodeType.DIVIDE_EQUALS_OPERATOR:
        var variableName = interpretNodeGen(node.children.elementAt(0)).single;
        var variableValue = interpretNodeGen(node.children.elementAt(1)).single;
        var scope = scopes.lastWhere((s) => s.variables.containsKey(variableName), orElse: () => scopes.last);
        yield scope.variables[variableName] = _objectToNum(scope.variables[variableName]) / _objectToNum(variableValue);
        break;
      case NodeType.ADD_OPERATOR:
        yield _interpretForNumOperation(node,0) + _interpretForNumOperation(node,1);
        break;
      case NodeType.SUBSTRACT_OPERATOR:
        yield _interpretForNumOperation(node,0) - _interpretForNumOperation(node,1);
        break;
      case NodeType.MULTIPLY_OPERATOR:
        yield _interpretForNumOperation(node,0) * _interpretForNumOperation(node,1);
        break;
      case NodeType.DIVIDE_OPERATOR:
        yield _interpretForNumOperation(node,0) / _interpretForNumOperation(node,1);
        break;
      case NodeType.OR_OPERATOR:
        yield _interpretForBoolOperation(node,0) || _interpretForBoolOperation(node,1);
        break;
      case NodeType.AND_OPERATOR:
        yield _interpretForBoolOperation(node,0) && _interpretForBoolOperation(node,1);
        break;
      case NodeType.IS_EQUAL_OPERATOR:
        yield interpretNodeGen(node.children.elementAt(0)).single == interpretNodeGen(node.children.elementAt(1)).single;
        break;
      case NodeType.IS_NOT_EQUAL_OPERATOR:
        yield interpretNodeGen(node.children.elementAt(0)).single != interpretNodeGen(node.children.elementAt(1)).single;
        break;
      case NodeType.IS_MORE_OPERATOR:
        yield _interpretForNumOperation(node,0) > _interpretForNumOperation(node,1);
        break;
      case NodeType.IS_MORE_OR_EQUAL_OPERATOR:
        yield _interpretForNumOperation(node,0) >= _interpretForNumOperation(node,1);
        break;
      case NodeType.IS_LESS_OPERATOR:
        yield _interpretForNumOperation(node,0) < _interpretForNumOperation(node,1);
        break;
      case NodeType.IS_LESS_OR_EQUAL_OPERATOR:
        yield _interpretForNumOperation(node,0) <= _interpretForNumOperation(node,1);
        break;
      case NodeType.NOT_OPERATOR:
        yield !_interpretForBoolOperation(node,0);
        break;
      case NodeType.LITERAL:
        yield double.tryParse(node.value) ?? node.value;
        break;
      case NodeType.ROOT:
        for(Node child in node.children) {
          if(child.type != NodeType.FUNCTION_DECLARATION) {
            yield* interpretNodeGen(child);
          }
        }
        break;
      case NodeType.REPEAT:
        var expressionVal = interpretNodeGen(node.parameters.elementAt(0)).single;
        if(expressionVal is bool) {
          while (expressionVal != false) {
            for(Node child in node.children) {
              yield* interpretNodeGen(child);
            }
            expressionVal = _objectToBool(interpretNodeGen(node.parameters.elementAt(0)).single);
          }
        } else {
          for(int i = 0; i < _objectToNum(interpretNodeGen(node.parameters.elementAt(0)).single); i++) {
            for(Node child in node.children) {
              yield* interpretNodeGen(child);
            }
          }
        }
        break;
      case NodeType.ELSE:
        for(Node child in node.children) {
          yield* interpretNodeGen(child);
        }
        break;
      case NodeType.IF:
      case NodeType.ELSEIF:
        if(_objectToBool(interpretNodeGen(node.parameters.elementAt(0)).single)) {
          for(Node child in node.children) {
            yield* interpretNodeGen(child);
          }
        } else if(node.elseStatement != null) {
          yield* interpretNodeGen(node.elseStatement);
        }
        break;
      case NodeType.FUNCTION_CALL:
        ListQueue<Node> functionCallChildren = ListQueue.from(node.children);
        var name = node.value ?? interpretNodeGen(functionCallChildren.removeFirst()).single;
        var function = _declaredFunctions.firstWhere((n) => n.value == name, orElse: () => null);
        if(function != null) {
          if(function.parameters.length != functionCallChildren.length) {
            throw ParseInterpretError(
              message:  "Missing or additional arguments for call of function $name, expected ${function.parameters.length}, got ${functionCallChildren.length}",
              qrLine: node.qrLine,
            );
          }
          Map<String,Object> arguments = Map.fromIterables(
            function.parameters.map((n) => n.value),
            List.generate(functionCallChildren.length, (i) => interpretNodeGen(functionCallChildren.elementAt(i)).single) // TODO: check if works, type check & cast
          );
          if(function.nativeFunc != null) {
            yield function.nativeFunc.call(arguments);
          } else {
            function = function.clone();
            function.variables = arguments;
            scopes.add(function);
            final interpreted = function.children.map((child) {
              final results = interpretNodeGen(child);
              if (results.isNotEmpty) {
                return results.last;
              }
            }).toList();
            function.variables = {};
            scopes.removeLast();
            var returnVal = interpreted.firstWhere((i) => i is Return, orElse: () => interpreted.last);
            yield returnVal is Return ? returnVal.value : returnVal;
          }
        } else {
          throw ParseInterpretError(
              message: "Call of non-existent function $name",
              qrLine: node.qrLine,
            );
        }
        break;
      case NodeType.RETURN:
        var result = Return(interpretNodeGen(node.children.first).single);
        node.qrLine.result = result;
        yield result;
        break;
      default:
        break;
    }
    lastInterpretedNode = node;
  }
  bool _objectToBool(Object val) {
    if(val is bool) {
      return val;
    } else if (val is String) {
      return val.length != 0;
    } else if (val is num) {
      return val != 0;
    } else if (val == null) {
      return false;
    } else {
      return true;
    }
  }
  double _objectToNum(Object val) {
    if(val is bool) {
      return val == true ? 1.0 : 0.0;
    } else if (val is String) {
      return double.tryParse(val) ?? (val.length != 0 ? 1.0 : 0.0);
    } else if (val is num) {
      return val.toDouble();
    } else if (val == null) {
      return 0.0;
    } else {
      return 1.0;
    }
  }
  double _interpretForNumOperation(Node node, int index) {
    return _objectToNum(interpretNodeGen(node.children.elementAt(index)).single);
  }
  bool _interpretForBoolOperation(Node node, int index) {
    return _objectToBool(interpretNodeGen(node.children.elementAt(index)).single);
  }
  void unsetGlobalVariable(String name) {
    scopes.first.variables.remove(name);
    customVariables.remove(name);
  }
  void setGlobalVariableParams(String name, Object value) {
    scopes.first.variables[name] = value;
    customVariables[name] = value;
  }
  void addGlobalVariables(Map<String,Object> variables) {
    scopes.first.variables.addAll(variables);
    customVariables.addAll(variables);
  }
  Object getGlobalVariable(String name, Object value) {
    return scopes.first.variables[name];
  }
  Object getVariable(String name, Object value) {
    return scopes.lastWhere((s) => s.variables.containsKey(name))?.variables[name];
  }
  Map<String,Object> getAllVariables() {
    return scopes.map((s) => s.variables).reduce((m1, m2) => Map.from(m1)..addAll(m2));
  }
  void setGlobalVariable(MapEntry<String,Object> entry) {
    scopes.first.variables[entry.key] = entry.value;
    customVariables[entry.key] = entry.value;
  }
  void overwriteGlobalVariables(Map<String,Object> variables) {
    scopes.first.variables = Map.from(variables);
    customVariables = variables;
  }
  Iterable<Object> runFunction(String func, List<Object> arguments) {
    return interpretNodeGen(
      Node(
        type: NodeType.FUNCTION_CALL,
        value: func,
        children: ListQueue<Node>.from(arguments.map((arg) => Node(type: NodeType.LITERAL, value: arg)))
      )
    );
  }
  Object runFunctionLastRet(String func, List<Object> arguments) {
    return runFunction(func, arguments).last;
  }
}