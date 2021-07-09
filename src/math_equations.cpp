#include "math_equations.h"
#include <stdexcept>

Token::Token(Token::ID id, int value)
: id(id),
  value(value)
{
  // empty
}

int Token::precedence() const {
  if (id == ID::OperatorAdd || id == ID::OperatorSubtract) return 2;
  return 0;
}


ASTOperatorAdd::ASTOperatorAdd(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand)
: m_leftOperand(std::move(leftOperand)),
  m_rightOperand(std::move(rightOperand))
{
  // empty
}

int ASTOperatorAdd::value() const {
  return m_leftOperand->value() + m_rightOperand->value();
}


ASTOperatorSubtract::ASTOperatorSubtract(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand)
: m_leftOperand(std::move(leftOperand)),
  m_rightOperand(std::move(rightOperand))
{
  // empty
}

int ASTOperatorSubtract::value() const {
  return m_rightOperand->value() - m_leftOperand->value();
}


ASTNumber::ASTNumber(int value)
: m_value(value)
{
  // empty
}

int ASTNumber::value() const {
  return m_value;
}

bool isDigitMarker(Marker marker) {
  return marker >= Marker::Digit_0 && marker <= Marker::Digit_9;
}

int digitValue(Marker marker) {
  return static_cast<int>(marker) - static_cast<int>(Marker::Digit_0);
}

int concatDigits(const std::vector<int>& digits) {
  std::ostringstream buffer;
  for (auto digit : digits) { buffer << digit; }
  return std::stoi(buffer.str());
}

Token consumeNumber(std::list<Marker>& markers) {
  std::vector<int> digits;
  while (!markers.empty() && isDigitMarker(markers.front())) {
    Marker nextMarker = markers.front();
    markers.pop_front();
    digits.push_back(digitValue(nextMarker));
  }
  return Token(Token::ID::Number, concatDigits(digits));
}

bool isOperatorMarker(Marker marker) {
  return marker >= Marker::OperatorAdd && marker <= Marker::OperatorSubtract;
}

Token consumeOperator(std::list<Marker>& markers) {
  Marker nextMarker = markers.front();
  markers.pop_front();
  switch (nextMarker) {
    case Marker::OperatorAdd: return Token(Token::ID::OperatorAdd);
    case Marker::OperatorSubtract: return Token(Token::ID::OperatorSubtract);
    default: throw std::runtime_error("Failed to consume operator: unknown operator type.");
  }
}

std::list<Token> parseTokens(std::list<Marker> markers) {
  std::list<Token> tokens;

  while (!markers.empty()) {
    Marker nextMarker = markers.front();

    if (isDigitMarker(nextMarker)) {
      tokens.push_back(consumeNumber(markers));
    } else if (isOperatorMarker(nextMarker)) {
      tokens.push_back(consumeOperator(markers));
    } else {
      throw std::runtime_error("Encountered unknown marker code.");
    }
  }
  return tokens;
}

void resolveOperatorPrecedence(const Token& nextToken, std::list<Token>& outputQueue, std::list<Token>& operatorStack) {
  while (!operatorStack.empty() && nextToken.precedence() < operatorStack.front().precedence()) {
    outputQueue.push_back(operatorStack.front());
    operatorStack.pop_front();
  }
}

std::list<Token> shuntingYardAlgorithm(std::list<Token> tokens) {
  // Shunting-yard algorithm: convert infix notation to reverse polish notation
  std::list<Token> outputQueue;
  std::list<Token> operatorStack;
  while (!tokens.empty()) {
    Token nextToken = tokens.front();
    tokens.pop_front();
    if (nextToken.id == Token::ID::Number) {
      outputQueue.push_back(nextToken);
    } else if (nextToken.id >= Token::ID::OperatorAdd && nextToken.id <= Token::ID::OperatorSubtract) {
      resolveOperatorPrecedence(nextToken, outputQueue, operatorStack);
      operatorStack.push_front(nextToken);
    } else {
      throw std::runtime_error("Failed to convert to reverse polish notation: unknown token encountered.");
    }
  }
  while (!operatorStack.empty()) {
    outputQueue.push_back(operatorStack.front());
    operatorStack.pop_front();
  }
  return outputQueue;
}

std::list<Token> toReversePolishNotation(std::list<Token> tokens) {
  return shuntingYardAlgorithm(tokens);
}

std::unique_ptr<ASTNode> parseAST(std::list<Token>& tokens) {
  if (tokens.empty()) return nullptr;

  auto nextToken = tokens.back();
  tokens.pop_back();
  if (nextToken.id == Token::ID::Number) {
    return std::make_unique<ASTNumber>(nextToken.value);
  }
  if (nextToken.id == Token::ID::OperatorAdd) {
    return std::make_unique<ASTOperatorAdd>(std::move(parseAST(tokens)),
      std::move(parseAST(tokens)));
  }
  if (nextToken.id == Token::ID::OperatorSubtract) {
    return std::make_unique<ASTOperatorSubtract>(std::move(parseAST(tokens)),
      std::move(parseAST(tokens)));
  }
  throw std::runtime_error("Failed to parse AST: unknown token encountered.");
  return nullptr;
}

std::unique_ptr<ASTNode> parseASTFromMarkers(std::list<Marker> markers) {
  if (markers.empty()) return nullptr;
  auto tokens = toReversePolishNotation(parseTokens(markers));
  return parseAST(tokens);
};
