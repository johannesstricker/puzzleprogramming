#include "math_equations.h"
#include <stdexcept>
#include <numeric>
#include <algorithm>

std::string toString(Marker marker) {
  if (isDigitMarker(marker)) return std::to_string(digitValue(marker));
  switch (marker) {
    case Marker::OperatorAdd: return "PLUS";
    case Marker::OperatorSubtract: return "SUBTRACT";
    case Marker::OperatorMultiply: return "MULTIPLY";
    case Marker::OperatorDivide: return "DIVIDE";
    default: throw std::runtime_error("Failed to convert marker to string: unknown marker type.");
  }
}

std::vector<int> sortMarkersLTR(const std::vector<int>& markers, const std::vector<std::vector<cv::Point2f>>& corners) {
  std::vector<int> indices(markers.size());
  std::iota(indices.begin(), indices.end(), 0);
  std::sort(indices.begin(), indices.end(), [&](int a, int b) {
    return corners[a][0].x < corners[b][0].x;
  });
  std::vector<int> markersSortedLTR(markers.size());
  int destIdx = 0;
  for (auto sourceIdx : indices)
  {
    markersSortedLTR[destIdx++] = markers[sourceIdx];
  }
  return markersSortedLTR;
}

std::list<Marker> detectAndDecodeArUco(const cv::Mat& image) {
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_4X4_50);
  std::vector<int> markerIds;
  std::vector<std::vector<cv::Point2f>> markerCorners, rejectedCandidates;
  cv::Ptr<cv::aruco::DetectorParameters> parameters = cv::aruco::DetectorParameters::create();
  cv::aruco::detectMarkers(image, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);

  auto markerIdsSortedLTR = sortMarkersLTR(markerIds, markerCorners);
  std::list<Marker> output;
  for (auto id : markerIdsSortedLTR) {
    // TODO: sanitize
    output.push_back(static_cast<Marker>(id));
  }
  return output;
}

void createArUcoMarkers(const std::string& outputFolder, int size) {
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_4X4_50);
  for (int code = static_cast<int>(Marker::Digit_0); code <= static_cast<int>(Marker::OperatorDivide); code++) {
    cv::Mat image;
    cv::aruco::drawMarker(dictionary, code, size, image, 1);

    Marker marker = static_cast<Marker>(code);
    std::string fileName = toString(marker) + ".png";
    std::string filePath = fileName;
    cv::imwrite(filePath, image);
  }
}

Token::Token(Token::ID id, int value)
: id(id),
  value(value)
{
  // empty
}

int Token::precedence() const {
  if (id == ID::OperatorAdd || id == ID::OperatorSubtract) return 2;
  if (id == ID::OperatorMultiply || id == ID::OperatorDivide) return 3;
  return 0;
}

std::string Token::toString() const {
  switch (id) {
    case ID::OperatorAdd: return "+";
    case ID::OperatorSubtract: return "-";
    case ID::OperatorMultiply: return "*";
    case ID::OperatorDivide: return "/";
    default: return std::to_string(value);
  }
}


ASTOperatorAdd::ASTOperatorAdd(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand)
: m_leftOperand(std::move(leftOperand)),
  m_rightOperand(std::move(rightOperand))
{
  // empty
}

int ASTOperatorAdd::value() const {
  return m_rightOperand->value() + m_leftOperand->value();
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


ASTOperatorMultiply::ASTOperatorMultiply(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand)
: m_leftOperand(std::move(leftOperand)),
  m_rightOperand(std::move(rightOperand))
{
  // empty
}

int ASTOperatorMultiply::value() const {
  return m_leftOperand->value() * m_rightOperand->value();
}


ASTOperatorDivide::ASTOperatorDivide(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand)
: m_leftOperand(std::move(leftOperand)),
  m_rightOperand(std::move(rightOperand))
{
  // empty
}

int ASTOperatorDivide::value() const {
  return m_rightOperand->value() / m_leftOperand->value();
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
  return marker >= Marker::OperatorAdd && marker <= Marker::OperatorDivide;
}

Token consumeOperator(std::list<Marker>& markers) {
  Marker nextMarker = markers.front();
  markers.pop_front();
  switch (nextMarker) {
    case Marker::OperatorAdd: return Token(Token::ID::OperatorAdd);
    case Marker::OperatorSubtract: return Token(Token::ID::OperatorSubtract);
    case Marker::OperatorMultiply: return Token(Token::ID::OperatorMultiply);
    case Marker::OperatorDivide: return Token(Token::ID::OperatorDivide);
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

bool isOperatorToken(const Token& token) {
  return token.id >= Token::ID::OperatorAdd && token.id <= Token::ID::OperatorDivide;
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
    } else if (isOperatorToken(nextToken)) {
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

std::unique_ptr<ASTNode> consumeToken(std::list<Token>& tokens) {
  if (tokens.empty()) throw std::runtime_error("Failed to consume token.");
  auto nextToken = tokens.back();
  tokens.pop_back();
  if (nextToken.id == Token::ID::Number) {
    return std::make_unique<ASTNumber>(nextToken.value);
  }
  if (nextToken.id == Token::ID::OperatorAdd) {
    return std::make_unique<ASTOperatorAdd>(consumeToken(tokens), consumeToken(tokens));
  }
  if (nextToken.id == Token::ID::OperatorSubtract) {
    return std::make_unique<ASTOperatorSubtract>(consumeToken(tokens), consumeToken(tokens));
  }
  if (nextToken.id == Token::ID::OperatorMultiply) {
    return std::make_unique<ASTOperatorMultiply>(consumeToken(tokens), consumeToken(tokens));
  }
  if (nextToken.id == Token::ID::OperatorDivide) {
    return std::make_unique<ASTOperatorDivide>(consumeToken(tokens), consumeToken(tokens));
  }
  throw std::runtime_error("Failed to parse AST: unknown token encountered.");
}

std::unique_ptr<ASTNode> parseAST(std::list<Token>& tokens) {
  if (tokens.empty()) return nullptr;
  return consumeToken(tokens);
}

std::unique_ptr<ASTNode> parseASTFromMarkers(std::list<Marker> markers) {
  if (markers.empty()) return nullptr;
  auto tokens = toReversePolishNotation(parseTokens(markers));
  return parseAST(tokens);
};

std::string toString(const std::list<Token>& tokens) {
  std::ostringstream buffer;
  for (auto token : tokens) {
    buffer << token.toString() << " ";
  }
  std::string output = buffer.str();
  return output.substr(0, output.size() - 1);
}