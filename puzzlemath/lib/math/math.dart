import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'dart:ffi';

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
  End
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
    while (!markers.isEmpty && isDigitMarker(markers.first)) {
      digits.add(digitValue(markers.first));
      markers.removeAt(0);
    }
    final tokenValue = concatDigits(digits);
    return Token(TokenType.Number, tokenValue);
  }

  Token _consumeOperator() {
    switch (markers.first) {
      case Marker.OperatorAdd:
        return Token(TokenType.OperatorAdd);
      case Marker.OperatorSubtract:
        return Token(TokenType.OperatorSubtract);
      case Marker.OperatorMultiply:
        return Token(TokenType.OperatorMultiply);
      case Marker.OperatorDivide:
        return Token(TokenType.OperatorDivide);
      default:
        throw ('Marker ${markers.first} is not an operator type.');
    }
  }

  Token _consumeParenthesis() {
    switch (markers.first) {
      case Marker.LeftParenthesis:
        return Token(TokenType.LeftParenthesis);
      case Marker.RightParenthesis:
        return Token(TokenType.RightParenthesis);
      default:
        throw ('Marker ${markers.first} is not a parenthesis');
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
    while (!_tokens.isEmpty) {
      Token nextToken = _tokens.first;
      _tokens.removeAt(0);
      if (isNumberToken(nextToken)) {
        _outputQueue.add(nextToken);
      } else if (isOperatorToken(nextToken)) {
        _resolveOperatorPrecedence(nextToken);
        _outputQueue.insert(0, nextToken);
      } else if (isLeftParenthesisToken(nextToken)) {
        _outputQueue.insert(0, nextToken);
      } else if (isRightParenthesisToken(nextToken)) {
        _resolveRightParenthesis();
      } else {
        throw ('Unknown token encountered.');
      }
    }
    while (!_operatorStack.isEmpty) {
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
    while (!_operatorStack.isEmpty &&
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
