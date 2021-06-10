#include "Interpreter.h"
#include <iostream>
#include <sstream>
#include <vector>
#include <iterator>
#include <stdexcept>
#include <map>
#include <functional>
#include <regex>
#include <list>

using TokenList = std::list<Token*>;

std::string OperatorPlus::toString() const
{
  return "+";
}

Token* OperatorPlus::operator()(const Number* leftOperand, const Number* rightOperand)
{
  return new Number(leftOperand->Value + rightOperand->Value);
}

std::string Number::toString() const
{
  std::ostringstream buffer;
  buffer << Value;
  return buffer.str();
}

Number* consumeNumber(TokenList& tokens)
{
  Token* token = tokens.front();
  tokens.pop_front();
  if (auto* num = dynamic_cast<Number*>(token); num != nullptr)
  {
    return num;
  }
  throw std::runtime_error("Expected number, got: " + token->toString());
}

OperatorPlus* consumeOperator(TokenList& tokens)
{
  Token* token = tokens.front();
  tokens.pop_front();
  if (auto* op = dynamic_cast<OperatorPlus*>(token); op != nullptr)
  {
    return op;
  }
  throw std::runtime_error("Expected operator+, got: " + token->toString());
}

Token* consumeExpression(TokenList& tokens)
{
  Number* leftOperand = consumeNumber(tokens);
  OperatorPlus* op = consumeOperator(tokens);
  Number* rightOperand = consumeNumber(tokens);
  return (*op)(leftOperand, rightOperand);
}

std::string interpret(const std::string& code)
{
  // 1) split into tokens
  std::istringstream buffer(code);
  std::vector<std::string> tokenStrings(std::istream_iterator<std::string>{buffer},
    std::istream_iterator<std::string>());

  // 2) identify each token
  TokenList tokens;
  for (auto& each : tokenStrings) {
    Token* token = lex(each);
    if (token == nullptr) {
      throw std::runtime_error("Unexpected token: " + each);
    }
    tokens.push_back(token);
  }

  // 3) build a syntax tree from the tokens
  // consume tokens one by one
  Token* result = consumeExpression(tokens);
  return result->toString();
}

Token* lex(const std::string& tokenString)
{
  using TokenConstructor = std::function<Token*(const std::smatch&)>;
  using LexerRule = std::pair<std::regex, TokenConstructor>;
  std::vector<LexerRule> rules = {
    {
      std::regex(R"(^\+$)"),
      [](const std::smatch&) -> Token* {
        return new OperatorPlus();
      }
    }, {
      std::regex(R"(^[0-9]+(\.[0-9]+)?$)"),
      [](const std::smatch& matches) -> Token* {
        return new Number(std::stod(matches.str(0)));
      }
    }
  };
  for (auto& [regex, constructorFn] : rules)
  {
    std::smatch matches;
    if (std::regex_match(tokenString, matches, regex))
    {
      return constructorFn(matches);
    }
  }
  return nullptr;
}

std::ostream& operator<<(std::ostream& outstream, const Token& token)
{
  outstream << token.toString();
  return outstream;
}

std::string join(const std::vector<std::string>& input)
{
  std::string output;
  for (auto& each : input)
  {
    if (!output.empty())
    {
      output += " ";
    }
    output += each;
  }
  return output;
}

#include <opencv2/objdetect.hpp>
#include <numeric>

std::optional<std::string> decodeAndInterpret(const cv::Mat& image)
{
  cv::QRCodeDetector qrDecoder = cv::QRCodeDetector::QRCodeDetector();
  std::vector<cv::String> decodedStrings;
  cv::Mat points;
  bool qrCodesFound = qrDecoder.detectAndDecodeMulti(image, decodedStrings, points);
  if (!qrCodesFound) return {};

  // sort QR codes left to right
  std::vector<int> indices(decodedStrings.size());
  std::iota(indices.begin(), indices.end(), 0);
  std::sort(indices.begin(), indices.end(), [&](int a, int b) {
    return points.at<float>(a, 0) < points.at<float>(b, 0);
  });
  std::vector<cv::String> stringsSortedLTR(decodedStrings.size());
  int destIdx = 0;
  for (auto sourceIdx : indices)
  {
    stringsSortedLTR[destIdx++] = decodedStrings[sourceIdx];
  }
  return interpret(join(stringsSortedLTR));
}