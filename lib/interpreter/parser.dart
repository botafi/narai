
import 'dart:collection';

import 'package:narai/interpreter/node.dart';
import 'package:narai/interpreter/operators.dart';
import 'package:narai/interpreter/parseError.dart';
import 'package:narai/interpreter/qr.dart';

class NativeFunctionDeclaration {
  final String functionName;
  final Map<String,Type> variables;
  final Function nativeFunction;
  const NativeFunctionDeclaration(this.functionName, this.variables, this.nativeFunction);
}

class Parser {
  static final tokenDivider = RegExp(r"(\+=|\*=|-=|\/=|=\+|=\*|=-|=\/|==|<=|>=|!=|&&|\|\||[ \/\+\-\*\^\(\)\=\<\>\:\n\!\,\;\&\|])");
  static final functionDeclarationRegExp = RegExp(r'^FUNC (?:(?:"([a-zA-Z0-9 ]+)")|(?:([a-zA-Z0-9]+)))+(?: VAR (?:(?:"([a-zA-Z0-9 ]+)")|(?:([a-zA-Z0-9]+)))+)?(?: VAR (?:(?:"([a-zA-Z0-9 ]+)")|(?:([a-zA-Z0-9]+)))+)?(?: VAR (?:(?:"([a-zA-Z0-9 ]+)")|(?:([a-zA-Z0-9]+)))+)?(?: VAR (?:(?:"([a-zA-Z0-9 ]+)")|(?:([a-zA-Z0-9]+)))+)?(?: VAR (?:(?:"([a-zA-Z0-9 ]+)")|(?:([a-zA-Z0-9]+)))+)?$');
  List<QRLine> qrLines = [];
  Node root = Node(type: NodeType.ROOT);
  List<List<String>> parsedExps = [];
  List<Node> nativeFunctions = [];
  List<Node> declaredFunctions = [];
  ListQueue<Node> scopeStack = ListQueue();
  List<String> parsedTokens = [];
  ListQueue<Node> parsingExp = ListQueue();
  ListQueue<Node> parsingOperators = ListQueue();
  bool parsed = false;
  QRLine lastQRLine;

  Parser() {
    this.scopeStack.add(this.root);
  }
  void clearParse() {
    parsedExps = [];
    declaredFunctions = List.from(nativeFunctions);
    root = Node(type: NodeType.ROOT);
    scopeStack = ListQueue.of([root]);
    parsedTokens = [];
    parsingExp = ListQueue();
    parsingOperators = ListQueue();
    parsed = false;
  }
  void clear() {
    nativeFunctions = [];
    qrLines = [];
    clearParse();
  }
  void parse() {
    if(!parsed) {
      clearParse();
      for(QRLine qrLine in qrLines)
        parsePart(qrLine);
      parsed = true;
    }
  }
  void parsePart(QRLine qrLine) {
    lastQRLine = qrLine;
    String part = qrLine.line.trim();
    String lastPart = part;
    ListQueue<QR> qrParts = ListQueue.from(qrLine.qrs); // TODO: connect node to exact QR
    while(part.length != 0) {
      lastPart = part;
      if(part[0] == STRING_CHAR) {
        int endIndex = part.indexOf(STRING_CHAR, 1);
        if(endIndex == -1 || endIndex == 1) {
          throw ParseInterpretError(message: "Parse error: String of zero length or not terminated", qrLine: qrLine);
        }
        var string = part.substring(1, endIndex);
        this.parsingExp.add(Node(type: NodeType.LITERAL, value: string, qrLine: lastQRLine)); // this.parseToken(part.substring(1, endIndex));
        this.parsedTokens.add(string);
        part = part.substring(endIndex + 1);
      } else if(part.indexOf(FUNCTION_DECLARATION) == 0) {
        var match = functionDeclarationRegExp.firstMatch(part);
        if(match == null) {
          throw ParseInterpretError(message: "Parse error: Bad function declaration syntax '$part'", qrLine: qrLine);
        }
        var declarationParams = match.groups(List<int>.generate(10,(i) => i + 1)).where((i) => i != null).toList();
        var node = Node(
          type: NodeType.FUNCTION_DECLARATION,
          parent: this.scopeStack.last,
          value: declarationParams.removeAt(0),
          parameters: declarationParams.map((d) => Node(type: NodeType.VARIABLE, value: d, qrLine: lastQRLine)).toList(),
          qrLine: lastQRLine
        );
        this.scopeStack.add(node);
        this.root.children.add(node);
        this.declaredFunctions.add(node);
        part = "";
      } else if(part.indexOf(REPEAT_STATEMENT) == 0) {
        var node = Node(
          type: NodeType.REPEAT,
          parent: this.scopeStack.last,
          qrLine: lastQRLine
        );
        this.scopeStack.last.children.add(node);
        this.scopeStack.add(node);
        part = part.replaceFirst(REPEAT_STATEMENT, "");
      } else if(part.indexOf(IF_STATEMENT) == 0) {
        var node = Node(
          type: NodeType.IF,
          parent: this.scopeStack.last,
          qrLine: lastQRLine
        );
        this.scopeStack.last.children.add(node);
        this.scopeStack.add(node);
        part = part.replaceFirst(IF_STATEMENT, "");
      } else if(part.indexOf(ELSEIF_STATEMENT) == 0) {
        var node = Node(
          type: NodeType.ELSEIF,
          parent: this.scopeStack.elementAt(this.scopeStack.length - 2),
          qrLine: lastQRLine
        );
        var lastScopeIf = this.scopeStack.removeLast();
        lastScopeIf.elseStatement = node;
        this.scopeStack.add(node);
        part = part.replaceFirst(ELSEIF_STATEMENT, "");
      } else if(part.indexOf(ELSE_STATEMENT) == 0) {
        var node = Node(
          type: NodeType.ELSE,
          parent: this.scopeStack.elementAt(this.scopeStack.length - 2),
          qrLine: lastQRLine
        );
        var lastScopeIf = this.scopeStack.removeLast();
        lastScopeIf.elseStatement = node;
        this.scopeStack.add(node);
        part = part.replaceFirst(ELSE_STATEMENT, "");
      } else if(part == END_STATEMENT) {
        this.scopeStack.removeLast();
        part = "";
      } else {
        int dividerIndex = part.indexOf(Parser.tokenDivider);
        if(dividerIndex == 0) {
          String matchedDivider = tokenDivider.firstMatch(part).group(0);
          this.parseToken(matchedDivider);
          part = part.replaceFirst(matchedDivider, "");
        } else if (dividerIndex == -1) {
          this.parseToken(part);
          part = "";
        } else {
          this.parseToken(part.substring(0, dividerIndex));
          part = part.substring(dividerIndex);
        }
      }
      part = part.trim();
    }

    while(parsingOperators.isNotEmpty) {
      parsingExp.add(parsingOperators.removeLast());
    }

    if(parsingExp.isNotEmpty) { // TODO: support more arguments like in last
      var nodeStack = ListQueue();
      for(var exp in parsingExp) {
        var params = _getNumOfParameters(exp, nodeStack.isNotEmpty ? nodeStack.first : null);
        print("params: $params");
        if(params != 0) {
          for (var i = 0; i < params; i++) {
            if(nodeStack.length < 1) {
              throw ParseInterpretError(message: "Parameters not supplied", qrLine: exp.qrLine);
            }
            var child = nodeStack.removeLast();
            child.parent = exp;
            exp.children.addFirst(child);
          }
          nodeStack.add(exp);
        } else {
          nodeStack.add(exp);
        }
      }
      if((scopeStack.last.type == NodeType.IF || scopeStack.last.type == NodeType.ELSEIF || scopeStack.last.type == NodeType.REPEAT) && (scopeStack.last.parameters == null || scopeStack.last.parameters.isEmpty)) {
        var node = nodeStack.removeLast();
        node.parent = scopeStack.last;
        scopeStack.last.parameters = [node];
      } else {
        var node = nodeStack.removeLast();
        node.parent = scopeStack.last;
        scopeStack.last.children.add(node);
      }
      parsingExp.clear();
    }

    print(root);
    parsedTokens.clear();
  }
  
  void parseToken(String token) {
    var tokenOperator = langOperators.firstWhere((o) => o.sign == token, orElse: () => null);
    var tokenFunction = declaredFunctions.firstWhere((n) => n.value == token, orElse: () => null);
    if(tokenFunction != null && ( this.parsedTokens.isEmpty || (this.parsedTokens.last != FUNCTION_CALL && this.parsedTokens.last != VARIABLE) )) {
      tokenOperator = langOperators.firstWhere((o) => o.sign == FUNCTION_CALL, orElse: () => tokenOperator);
    }
    Operator lastOperator;
    if(parsingOperators.isNotEmpty) { // TODO: isolate into function
      lastOperator = langOperators.firstWhere((o) => o.nodeType == parsingOperators.last.type, orElse: () => null);
    }
    if(tokenOperator != null) { // if the token is an operator, then:
      while (
        parsingOperators.isNotEmpty
        &&
        lastOperator != null
        &&
        (
          lastOperator.precedence > tokenOperator.precedence //           (there is an operator at the top of the operator stack with greater precedence)
          ||
          (lastOperator.precedence == tokenOperator.precedence && lastOperator.associativity == OperatorAssociativity.LEFT) //            or (the operator at the top of the operator stack has equal precedence and is left associative))
        )
        &&
        parsingOperators.last.value != '(' //           and (the operator at the top of the operator stack is not a left bracket):
      ) {
        parsingExp.add(parsingOperators.removeLast()); //         pop operators from the operator stack onto the output queue.
        if(parsingOperators.isNotEmpty) { // TODO: isolate into function
          lastOperator = langOperators.firstWhere((o) => o.nodeType == parsingOperators.last.type, orElse: () => null);
        }
      }
      if(tokenOperator.nodeType == NodeType.FUNCTION_CALL && token != FUNCTION_CALL) {
        this.parsingOperators.add(Node(type: NodeType.FUNCTION_CALL, value: token, qrLine: lastQRLine));
      } else {
        parsingOperators.add(Node(type: tokenOperator.nodeType, qrLine: lastQRLine)); //     push it onto the operator stack.
      }
    } else if(token == '(') { // if the token is a left bracket (i.e. "("), then:
      parsingOperators.add(Node(type: NodeType.HELPER, value: '(')); //     push it onto the operator stack.
    } else if(token == ')') { // if the token is a right bracket (i.e. ")"), then:
      while(parsingOperators.isNotEmpty && parsingOperators.last.value != '(') { //     while the operator at the top of the operator stack is not a left bracket:
        parsingExp.add(parsingOperators.removeLast()); //         pop the operator from the operator stack onto the output queue.
      }
      parsingOperators.removeLast(); //     pop the left bracket from the stack.
    } else { // if the token is a literal(number, string), then:
      this.parsingExp.add(Node(type: NodeType.LITERAL, value: token, qrLine: lastQRLine)); //  push it to the output queue.
    }
    this.parsedTokens.add(token);
  }

  int _getNumOfParameters(Node node, Node firstParam) {
    if(node.type == NodeType.FUNCTION_CALL) {
      if(node.value != null) { // function name as value on function call node
        return declaredFunctions.firstWhere((n) => n.value == node.value).parameters.length;
      } else if(node.children.isNotEmpty && node.children.first.type == NodeType.LITERAL) { // function name as first node child literal
        return declaredFunctions.firstWhere((n) => n.value == node.children.first.value).parameters.length;
      } else if(firstParam != null && firstParam.value != null) { // function name as next node literal
        return declaredFunctions.firstWhere((n) => n.value == firstParam.value).parameters.length + 1; // + 1 because function name needs to be included as child
      } else {
        throw ParseInterpretError(message: "Cant get number of parameters of function for $node, firstParameter: $firstParam", qrLine: node.qrLine);
      }
    } else if(node.type == NodeType.LITERAL) {
      return 0;
    } else {
      return langOperators.firstWhere((o) => o.nodeType == node.type).parameters;
    }
  }
  void setQRLines(Iterable<QRLine> qrLines) {
    if(qrLines != null)
      this.qrLines = qrLines.toList();
    this.clearParse();
  }
  void addQRLines(Iterable<QRLine> qrLines) {
    this.qrLines.addAll(qrLines);
    this.clearParse();
  }
  void addNativeFunctionNode(Node nativeFunction) {
    this.nativeFunctions.add(nativeFunction);
    this.clearParse();
  }
  void addNativeFunctionNodes(Iterable<Node> nativeFunctions) {
    this.nativeFunctions.addAll(nativeFunctions);
    this.clearParse();
  }
  void addNativeFunctionParams({String functionName, Map<String,Type> variables, Function nativeFunction}) {
    this.nativeFunctions.add(
      Node(
        type: NodeType.FUNCTION_DECLARATION,
        value: functionName,
        parameters: variables.entries.map((entry) => Node(type: NodeType.VARIABLE, variableType: entry.value, value: entry.key)),
        nativeFunc: nativeFunction
      )
    );
    this.clearParse();
  }
  void addNativeFunction(NativeFunctionDeclaration functionDeclaration) {
    this.nativeFunctions.add(
      Node(
        type: NodeType.FUNCTION_DECLARATION,
        value: functionDeclaration.functionName,
        parameters: functionDeclaration.variables.entries.map((entry) => Node(type: NodeType.VARIABLE, variableType: entry.value, value: entry.key)),
        nativeFunc: functionDeclaration.nativeFunction
      )
    );
    this.clearParse();
  }
}
