#pragma once
#include <vector>
#include <sstream>
#include <memory>
#include <list>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv-contrib/aruco.hpp>

enum class Marker : int {
  Digit_0,
  Digit_1,
  Digit_2,
  Digit_3,
  Digit_4,
  Digit_5,
  Digit_6,
  Digit_7,
  Digit_8,
  Digit_9,
  OperatorAdd,
  OperatorSubtract,
  OperatorMultiply,
  OperatorDivide,
  LeftParenthesis,
  RightParenthesis
};

std::list<Marker> stringToMarkers(const std::string& input);

std::string toString(Marker marker);
std::vector<int> sortMarkersLTR(const std::vector<int>& markers, const std::vector<std::vector<cv::Point2f>>& corners);
std::list<Marker> detectAndDecodeArUco(const cv::Mat& image);
void createArUcoMarkers(const std::string& outputFolder, int size = 100);

struct Token {
  enum class ID : int {
    Number,
    OperatorAdd,
    OperatorSubtract,
    OperatorMultiply,
    OperatorDivide,
    LeftParenthesis,
    RightParenthesis
  };

  Token(Token::ID id, int value = 0);
  int precedence() const;
  std::string toString() const;

  ID id;
  int value;
};

class ASTNode {
public:
  virtual ~ASTNode() = default;
  virtual int value() const = 0;
};

class ASTOperatorAdd : public ASTNode {
public:
  ASTOperatorAdd(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand);
  virtual int value() const override;
private:
  std::unique_ptr<ASTNode> m_leftOperand, m_rightOperand;
};

class ASTOperatorSubtract : public ASTNode {
public:
  ASTOperatorSubtract(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand);
  virtual int value() const override;
private:
  std::unique_ptr<ASTNode> m_leftOperand, m_rightOperand;
};

class ASTOperatorMultiply : public ASTNode {
public:
  ASTOperatorMultiply(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand);
  virtual int value() const override;
private:
  std::unique_ptr<ASTNode> m_leftOperand, m_rightOperand;
};

class ASTOperatorDivide : public ASTNode {
public:
  ASTOperatorDivide(std::unique_ptr<ASTNode> leftOperand, std::unique_ptr<ASTNode> rightOperand);
  virtual int value() const override;
private:
  std::unique_ptr<ASTNode> m_leftOperand, m_rightOperand;
};

class ASTNumber : public ASTNode {
public:
  ASTNumber(int value);
  virtual int value() const override;
private:
  int m_value;
};

bool isDigitMarker(Marker code);

int digitValue(Marker code);

int concatDigits(const std::vector<int>& digits);

Token consumeNumber(std::list<Marker>& markers);

bool isOperatorMarker(Marker code);

Token consumeOperator(std::list<Marker>& markers);

std::list<Token> parseTokens(std::list<Marker> markers);

void resolveOperatorPrecedence(const Token& nextToken, std::list<Token>& outputQueue, std::list<Token>& operatorStack);

bool isOperatorToken(const Token& token);

std::list<Token> shuntingYardAlgorithm(std::list<Token> tokens);

std::list<Token> toReversePolishNotation(std::list<Token> tokens);

std::unique_ptr<ASTNode> consumeToken(std::list<Token>& tokens);

std::unique_ptr<ASTNode> parseAST(std::list<Token>& tokens);

std::unique_ptr<ASTNode> parseASTFromMarkers(std::list<Marker> markers);

std::string toString(const std::list<Token>& tokens);