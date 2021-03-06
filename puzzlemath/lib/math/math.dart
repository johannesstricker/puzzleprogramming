import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:flutter/foundation.dart';

List<DetectedObject> sortObjectListLTR(List<DetectedObject> objects) {
  objects.sort((a, b) => a.topLeft.x.compareTo(b.topLeft.x));
  return objects;
}

enum Marker {
  Digit0,
  Digit1,
  Digit2,
  Digit3,
  Digit4,
  Digit5,
  Digit6,
  Digit7,
  Digit8,
  Digit9,
  OperatorAdd,
  OperatorSubtract,
  OperatorMultiply,
  OperatorDivide,
  LeftParenthesis,
  RightParenthesis,
  Start,
  End,
  Unknown,
}

List<Marker> stringToMarkers(String input) {
  const Map<String, Marker> mapping = {
    '0': Marker.Digit0,
    '1': Marker.Digit1,
    '2': Marker.Digit2,
    '3': Marker.Digit3,
    '4': Marker.Digit4,
    '5': Marker.Digit5,
    '6': Marker.Digit6,
    '7': Marker.Digit7,
    '8': Marker.Digit8,
    '9': Marker.Digit9,
    '+': Marker.OperatorAdd,
    '-': Marker.OperatorSubtract,
    '*': Marker.OperatorMultiply,
    '/': Marker.OperatorDivide,
    '(': Marker.LeftParenthesis,
    ')': Marker.RightParenthesis,
  };
  return input
      .split('')
      .map((char) => mapping[char] ?? Marker.Unknown)
      .toList();
}

Marker createMarker(int id) {
  return Marker.values[id];
}

bool isDigitMarker(Marker marker) {
  return marker.index >= Marker.Digit0.index &&
      marker.index <= Marker.Digit9.index;
}

bool isOperatorMarker(Marker marker) {
  return marker == Marker.OperatorAdd ||
      marker == Marker.OperatorSubtract ||
      marker == Marker.OperatorMultiply ||
      marker == Marker.OperatorDivide;
}

bool isParenthesisMarker(Marker marker) {
  return marker == Marker.LeftParenthesis || marker == Marker.RightParenthesis;
}

int digitValue(Marker marker) {
  if (marker.index < Marker.Digit0.index ||
      marker.index > Marker.Digit9.index) {
    throw ('Marker ${marker.toString()} is not a digit.');
  }
  return marker.index - Marker.Digit0.index;
}

int concatDigits(List<int> digits) {
  return int.parse(digits.map((i) => i.toString()).join(''));
}

enum TokenType {
  Number,
  OperatorAdd,
  OperatorSubtract,
  OperatorMultiply,
  OperatorDivide,
  LeftParenthesis,
  RightParenthesis,
}

class Token implements Comparable<Token> {
  final TokenType id;
  final int value;

  Token(this.id, [this.value = 0]);

  int precedence() {
    if (id == TokenType.OperatorAdd || id == TokenType.OperatorSubtract) {
      return 2;
    }
    if (id == TokenType.OperatorMultiply || id == TokenType.OperatorDivide) {
      return 3;
    }
    return 0;
  }

  @override
  int compareTo(Token other) {
    int byId = id.index.compareTo(other.id.index);
    if (byId == 0) {
      return value.compareTo(other.value);
    }
    return byId;
  }

  String toString() {
    if (id == TokenType.Number) {
      return value.toString();
    }
    if (id == TokenType.LeftParenthesis) {
      return "(";
    }
    if (id == TokenType.RightParenthesis) {
      return ")";
    }
    if (id == TokenType.OperatorAdd) {
      return "+";
    }
    if (id == TokenType.OperatorSubtract) {
      return "-";
    }
    if (id == TokenType.OperatorMultiply) {
      return "*";
    }
    if (id == TokenType.OperatorDivide) {
      return "/";
    }
    return "<unknown token>";
  }
}

class ConsumeResult {
  final Token token;
  final List<Marker> remainingMarkers;

  ConsumeResult(this.token, this.remainingMarkers);
}

class TokenParser {
  final List<Marker> markers;

  TokenParser(this.markers);

  Token? next() {
    if (markers.isEmpty) {
      return null;
    }
    if (isDigitMarker(markers.first)) {
      return _consumeNumber();
    }
    if (isOperatorMarker(markers.first)) {
      return _consumeOperator();
    }
    if (isParenthesisMarker(markers.first)) {
      return _consumeParenthesis();
    }
    markers.removeAt(0);
    return next();
  }

  List<Token> toList() {
    List<Token> tokens = [];
    Token? token = next();
    while (token != null) {
      tokens.add(token);
      token = next();
    }
    return tokens;
  }

  Token _consumeNumber() {
    final List<int> digits = [];
    while (markers.isNotEmpty && isDigitMarker(markers.first)) {
      digits.add(digitValue(markers.first));
      markers.removeAt(0);
    }
    final tokenValue = concatDigits(digits);
    return Token(TokenType.Number, tokenValue);
  }

  Token _consumeOperator() {
    Marker next = markers.first;
    markers.removeAt(0);
    switch (next) {
      case Marker.OperatorAdd:
        return Token(TokenType.OperatorAdd);
      case Marker.OperatorSubtract:
        return Token(TokenType.OperatorSubtract);
      case Marker.OperatorMultiply:
        return Token(TokenType.OperatorMultiply);
      case Marker.OperatorDivide:
        return Token(TokenType.OperatorDivide);
      default:
        throw ('Marker $next is not an operator type.');
    }
  }

  Token _consumeParenthesis() {
    Marker next = markers.first;
    markers.removeAt(0);
    switch (next) {
      case Marker.LeftParenthesis:
        return Token(TokenType.LeftParenthesis);
      case Marker.RightParenthesis:
        return Token(TokenType.RightParenthesis);
      default:
        throw ('Marker $next is not a parenthesis');
    }
  }
}

bool isNumberToken(Token token) {
  return token.id == TokenType.Number;
}

bool isOperatorToken(Token token) {
  return token.id == TokenType.OperatorAdd ||
      token.id == TokenType.OperatorSubtract ||
      token.id == TokenType.OperatorMultiply ||
      token.id == TokenType.OperatorDivide;
}

bool isLeftParenthesisToken(Token token) {
  return token.id == TokenType.LeftParenthesis;
}

bool isRightParenthesisToken(Token token) {
  return token.id == TokenType.RightParenthesis;
}

bool isParenthesisToken(Token token) {
  return isLeftParenthesisToken(token) || isRightParenthesisToken(token);
}

class _ReversePolishConverter {
  List<Token> _tokens = [];
  List<Token> _outputQueue = [];
  List<Token> _operatorStack = [];

  List<Token> convert(List<Token> tokens) {
    _tokens = tokens;
    return _shuntingYardAlgorithm();
  }

  List<Token> _shuntingYardAlgorithm() {
    _outputQueue = [];
    _operatorStack = [];
    while (_tokens.isNotEmpty) {
      Token nextToken = _tokens.first;
      _tokens.removeAt(0);
      if (isNumberToken(nextToken)) {
        _outputQueue.add(nextToken);
      } else if (isOperatorToken(nextToken)) {
        _resolveOperatorPrecedence(nextToken);
        _operatorStack.insert(0, nextToken);
      } else if (isLeftParenthesisToken(nextToken)) {
        _operatorStack.insert(0, nextToken);
      } else if (isRightParenthesisToken(nextToken)) {
        _resolveRightParenthesis();
      } else {
        throw ('Unknown token encountered.');
      }
    }
    while (_operatorStack.isNotEmpty) {
      Token nextToken = _operatorStack.first;
      _operatorStack.removeAt(0);
      if (isParenthesisToken(nextToken)) {
        throw ('Unexpected parenthesis encountered.');
      }
      _outputQueue.add(nextToken);
    }
    return _outputQueue;
  }

  void _resolveOperatorPrecedence(Token nextToken) {
    while (_operatorStack.isNotEmpty &&
        isOperatorToken(nextToken) &&
        nextToken.precedence() <= _operatorStack.first.precedence()) {
      _outputQueue.add(_operatorStack.first);
      _operatorStack.removeAt(0);
    }
  }

  void _resolveRightParenthesis() {
    while (true) {
      if (_operatorStack.isEmpty) {
        throw ('Missing left parenthesis.');
      }
      Token nextOperator = _operatorStack.first;
      _operatorStack.removeAt(0);
      if (isLeftParenthesisToken(nextOperator)) {
        break;
      }
      _outputQueue.add(nextOperator);
    }
  }
}

List<Token> toReversePolishNotation(List<Token> tokens) {
  _ReversePolishConverter converter = _ReversePolishConverter();
  return converter.convert(tokens);
}

// TODO: use double or generic type for AST

abstract class ASTNode {
  int value();
}

class ASTNumber implements ASTNode {
  final int _value;

  ASTNumber(this._value);

  @override
  int value() {
    return _value;
  }
}

class ASTOperatorAdd implements ASTNode {
  final ASTNode _leftOperand;
  final ASTNode _rightOperand;

  ASTOperatorAdd(this._leftOperand, this._rightOperand);

  @override
  int value() {
    return _leftOperand.value() + _rightOperand.value();
  }
}

class ASTOperatorSubtract implements ASTNode {
  final ASTNode _leftOperand;
  final ASTNode _rightOperand;

  ASTOperatorSubtract(this._leftOperand, this._rightOperand);

  @override
  int value() {
    return _leftOperand.value() - _rightOperand.value();
  }
}

class ASTOperatorMultiply implements ASTNode {
  final ASTNode _leftOperand;
  final ASTNode _rightOperand;

  ASTOperatorMultiply(this._leftOperand, this._rightOperand);

  @override
  int value() {
    return _leftOperand.value() * _rightOperand.value();
  }
}

class ASTOperatorDivide implements ASTNode {
  final ASTNode _leftOperand;
  final ASTNode _rightOperand;

  ASTOperatorDivide(this._leftOperand, this._rightOperand);

  @override
  int value() {
    return (_leftOperand.value() / _rightOperand.value()).round();
  }
}

class _ASTParser {
  List<Token> _tokens;

  _ASTParser(List<Token> tokens) : _tokens = toReversePolishNotation(tokens);

  ASTNode? parse() {
    if (_tokens.isEmpty) {
      return null;
    }
    try {
      return _consumeToken();
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  ASTNode _createNumberNode(Token token) {
    return ASTNumber(token.value);
  }

  ASTNode _createOperatorNode(Token token) {
    final rightOperand = _consumeToken();
    final leftOperand = _consumeToken();

    switch (token.id) {
      case TokenType.OperatorAdd:
        return ASTOperatorAdd(leftOperand, rightOperand);
      case TokenType.OperatorSubtract:
        return ASTOperatorSubtract(leftOperand, rightOperand);
      case TokenType.OperatorMultiply:
        return ASTOperatorMultiply(leftOperand, rightOperand);
      case TokenType.OperatorDivide:
        return ASTOperatorDivide(leftOperand, rightOperand);
      default:
        throw ('Failed to create operator node from non-operator token.');
    }
  }

  ASTNode _consumeToken() {
    if (_tokens.isEmpty) {
      throw ('Failed to parse AST. Missing token.');
    }
    Token nextToken = _tokens.last;
    _tokens.removeLast();
    if (isNumberToken(nextToken)) {
      return _createNumberNode(nextToken);
    }
    if (isOperatorToken(nextToken)) {
      return _createOperatorNode(nextToken);
    }
    throw ('Failed to parse abstract syntax tree. Unexpected token type.');
  }
}

ASTNode? parseAbstractSyntaxTree(List<Token> tokens) {
  _ASTParser parser = _ASTParser(tokens);
  return parser.parse();
}

class MathEquation {
  List<Marker> markers;
  List<Token> tokens;
  int? value;

  MathEquation({
    this.value,
    required this.tokens,
    required this.markers,
  });

  String toString() {
    if (tokens.length == 0) {
      return "<invalid equation>";
    }
    final equationString = tokens.map((token) => token.toString()).join('');
    return equationString;
  }
}

ASTNode? parseEquation(List<Marker> markers) {
  TokenParser parser = TokenParser(markers);
  final tokens = parser.toList();
  final ast = parseAbstractSyntaxTree(List.from(tokens));
  return ast;
}

int? parseAbstractSyntaxTreeFromObjects(List<DetectedObject> objects) {
  final markers = objects.map((obj) => createMarker(obj.id)).toList();
  return parseEquation(markers)?.value();
}
