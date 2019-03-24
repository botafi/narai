import 'package:narai/interpreter/node.dart';

const STRING_CHAR = '"';
const FUNCTION_DECLARATION = "FUNC";
const END_STATEMENT = "END";
const RETURN_STATEMENT = "RETURN";
const FUNCTION_CALL = "CALL";
const VARIABLE = "VAR";
const REPEAT_STATEMENT = "REPEAT";
const IF_STATEMENT = "IF";
const ELSEIF_STATEMENT = "ELSEIF";
const ELSE_STATEMENT = "ELSE";
class Operator {
  final String sign; final int precedence; final OperatorAssociativity associativity; final NodeType nodeType; final int parameters;
  const Operator(this.sign, this.precedence, this.associativity, this.nodeType, this.parameters);
}
enum OperatorAssociativity {
  LEFT,
  RIGTH
}
const List<Operator> langOperators = const [
    Operator(FUNCTION_CALL, -4, OperatorAssociativity.RIGTH, NodeType.FUNCTION_CALL, null),
    Operator(RETURN_STATEMENT, -5, OperatorAssociativity.RIGTH, NodeType.RETURN, 1),
    Operator("=", -3, OperatorAssociativity.RIGTH, NodeType.EQUALS_OPERATOR, 2),
    Operator("+=", -3, OperatorAssociativity.LEFT, NodeType.ADD_EQUALS_OPERATOR, 2),Operator("=+", -3, OperatorAssociativity.LEFT, NodeType.ADD_EQUALS_OPERATOR, 2),
    Operator("-=", -3, OperatorAssociativity.LEFT, NodeType.SUBSTRACT_EQUALS_OPERATOR, 2),Operator("=-", -3, OperatorAssociativity.LEFT, NodeType.SUBSTRACT_EQUALS_OPERATOR, 2),
    Operator("*=", -3, OperatorAssociativity.LEFT, NodeType.MULTIPLY_EQUALS_OPERATOR, 2),Operator("=*", -3, OperatorAssociativity.LEFT, NodeType.MULTIPLY_EQUALS_OPERATOR, 2),
    Operator("/=", -3, OperatorAssociativity.LEFT, NodeType.DIVIDE_EQUALS_OPERATOR, 2),Operator("=/", -3, OperatorAssociativity.LEFT, NodeType.DIVIDE_EQUALS_OPERATOR, 2),
    Operator("||", -2, OperatorAssociativity.LEFT, NodeType.OR_OPERATOR, 2),
    Operator("&&", -1, OperatorAssociativity.LEFT, NodeType.AND_OPERATOR, 2),
    Operator("==", 0, OperatorAssociativity.LEFT, NodeType.IS_EQUAL_OPERATOR, 2),
    Operator("!=", 0, OperatorAssociativity.LEFT, NodeType.IS_NOT_EQUAL_OPERATOR, 2),
    Operator(">", 1, OperatorAssociativity.LEFT, NodeType.IS_MORE_OPERATOR, 2),
    Operator("<", 1, OperatorAssociativity.LEFT, NodeType.IS_LESS_OPERATOR, 2),
    Operator(">=", 1, OperatorAssociativity.LEFT, NodeType.IS_MORE_OR_EQUAL_OPERATOR, 2),Operator("=>", 1, OperatorAssociativity.LEFT, NodeType.IS_MORE_OR_EQUAL_OPERATOR, 2),
    Operator("<=", 1, OperatorAssociativity.LEFT, NodeType.IS_LESS_OR_EQUAL_OPERATOR, 2),Operator("=<", 1, OperatorAssociativity.LEFT, NodeType.IS_LESS_OR_EQUAL_OPERATOR, 2),
    Operator("-", 2, OperatorAssociativity.LEFT, NodeType.SUBSTRACT_OPERATOR, 2),
    Operator("+", 2, OperatorAssociativity.LEFT, NodeType.ADD_OPERATOR, 2),
    Operator("*", 3, OperatorAssociativity.LEFT, NodeType.MULTIPLY_OPERATOR, 2),
    Operator("/", 3, OperatorAssociativity.LEFT, NodeType.DIVIDE_OPERATOR, 2),
    Operator("^", 4, OperatorAssociativity.RIGTH, NodeType.POWER_OPERATOR, 2),
    Operator("!", 5, OperatorAssociativity.RIGTH, NodeType.NOT_OPERATOR, 1),
    Operator(VARIABLE, 6, OperatorAssociativity.RIGTH, NodeType.VARIABLE, 1),
];