#include "catch.hpp"
#include "math_equations.h"

TEST_CASE("digit markers are strictly ordered") {
  REQUIRE(Marker::Digit_0 < Marker::Digit_1);
  REQUIRE(Marker::Digit_1 < Marker::Digit_2);
  REQUIRE(Marker::Digit_2 < Marker::Digit_3);
  REQUIRE(Marker::Digit_3 < Marker::Digit_4);
  REQUIRE(Marker::Digit_4 < Marker::Digit_5);
  REQUIRE(Marker::Digit_5 < Marker::Digit_6);
  REQUIRE(Marker::Digit_6 < Marker::Digit_7);
  REQUIRE(Marker::Digit_7 < Marker::Digit_8);
  REQUIRE(Marker::Digit_8 < Marker::Digit_9);
}

TEST_CASE("digitValue") {
  REQUIRE(digitValue(Marker::Digit_0) == 0);
  REQUIRE(digitValue(Marker::Digit_1) == 1);
  REQUIRE(digitValue(Marker::Digit_2) == 2);
  REQUIRE(digitValue(Marker::Digit_3) == 3);
  REQUIRE(digitValue(Marker::Digit_4) == 4);
  REQUIRE(digitValue(Marker::Digit_5) == 5);
  REQUIRE(digitValue(Marker::Digit_6) == 6);
  REQUIRE(digitValue(Marker::Digit_7) == 7);
  REQUIRE(digitValue(Marker::Digit_8) == 8);
  REQUIRE(digitValue(Marker::Digit_9) == 9);
  REQUIRE_THROWS_WITH(digitValue(Marker::OperatorAdd), "Failed to get digit value: marker is not a digit.");
}

TEST_CASE("stringToMarkers") {
  std::string input = "012345 6789+-*/()";
  std::list<Marker> expectedEquation = {
    Marker::Digit_0,
    Marker::Digit_1,
    Marker::Digit_2,
    Marker::Digit_3,
    Marker::Digit_4,
    Marker::Digit_5,
    Marker::Digit_6,
    Marker::Digit_7,
    Marker::Digit_8,
    Marker::Digit_9,
    Marker::OperatorAdd,
    Marker::OperatorSubtract,
    Marker::OperatorMultiply,
    Marker::OperatorDivide,
    Marker::LeftParenthesis,
    Marker::RightParenthesis
  };
  REQUIRE(stringToMarkers(input) == expectedEquation);
}

TEST_CASE("parse tokens from markers") {
  std::list<Marker> input = {
    Marker::Digit_9,
    Marker::Digit_7,
    Marker::OperatorAdd,
    Marker::Digit_5,
    Marker::OperatorMultiply,
    Marker::LeftParenthesis,
    Marker::Digit_2,
    Marker::OperatorSubtract,
    Marker::Digit_2,
    Marker::Digit_3,
    Marker::RightParenthesis
  };
  std::list<Token> expectedOutput = {
    Token(Token::ID::Number, 97),
    Token(Token::ID::OperatorAdd),
    Token(Token::ID::Number, 5),
    Token(Token::ID::OperatorMultiply),
    Token(Token::ID::LeftParenthesis),
    Token(Token::ID::Number, 2),
    Token(Token::ID::OperatorSubtract),
    Token(Token::ID::Number, 23),
    Token(Token::ID::RightParenthesis)
  };
  REQUIRE(parseTokens(input) == expectedOutput);
}

TEST_CASE("convert tokens to string") {
  std::list<Marker> equation = {
    Marker::Digit_1,
    Marker::Digit_0,
    Marker::OperatorAdd,
    Marker::Digit_7,
    Marker::OperatorMultiply,
    Marker::Digit_1,
    Marker::OperatorSubtract,
    Marker::Digit_8,
    Marker::OperatorDivide,
    Marker::Digit_3
  };
  auto tokens = parseTokens(equation);
  REQUIRE(toString(tokens) == "10 + 7 * 1 - 8 / 3");
}

TEST_CASE("OperatorAdd") {
  ASTOperatorAdd node(std::make_unique<ASTNumber>(10), std::make_unique<ASTNumber>(5));
  REQUIRE(node.value() == 15);
}

TEST_CASE("OperatorSubtract") {
  ASTOperatorSubtract node(std::make_unique<ASTNumber>(97), std::make_unique<ASTNumber>(10));
  REQUIRE(node.value() == 87);
}

TEST_CASE("OperatorMultiply") {
  ASTOperatorMultiply node(std::make_unique<ASTNumber>(2), std::make_unique<ASTNumber>(13));
  REQUIRE(node.value() == 26);
}

TEST_CASE("OperatorDivide") {
  ASTOperatorDivide node(std::make_unique<ASTNumber>(99), std::make_unique<ASTNumber>(3));
  REQUIRE(node.value() == 33);
}

TEST_CASE("shunting yard algorithm") {
  SECTION("97-10") {
    std::list<Token> input = {
      Token(Token::ID::Number, 97),
      Token(Token::ID::OperatorSubtract),
      Token(Token::ID::Number, 10)
    };
    std::list<Token> expectedOutput = {
      Token(Token::ID::Number, 97),
      Token(Token::ID::Number, 10),
      Token(Token::ID::OperatorSubtract)
    };
    REQUIRE(shuntingYardAlgorithm(input) == expectedOutput);
  }

  SECTION("(10-1)/3") {
    std::list<Token> input = {
      Token(Token::ID::LeftParenthesis),
      Token(Token::ID::Number, 10),
      Token(Token::ID::OperatorSubtract),
      Token(Token::ID::Number, 1),
      Token(Token::ID::RightParenthesis),
      Token(Token::ID::OperatorDivide),
      Token(Token::ID::Number, 3)
    };
    std::list<Token> expectedOutput = {
      Token(Token::ID::Number, 10),
      Token(Token::ID::Number, 1),
      Token(Token::ID::OperatorSubtract),
      Token(Token::ID::Number, 3),
      Token(Token::ID::OperatorDivide)
    };
    REQUIRE(shuntingYardAlgorithm(input) == expectedOutput);
  }
}

int solveEquation(const std::string& input) {
  auto ast = parseASTFromMarkers(stringToMarkers(input));
  return ast->value();
}

TEST_CASE("solve math equations") {
  REQUIRE(solveEquation("(10-1)/3") == 3);
  REQUIRE(solveEquation("10+9+52") == 71);
  REQUIRE(solveEquation("97-10") == 87);
  REQUIRE(solveEquation("2+7*3-10") == 13);
  REQUIRE(solveEquation("22*2/7") == 6);
  REQUIRE(solveEquation("(8+2)/2") == 5);
  REQUIRE(solveEquation("10*(4/2+8)") == 100);
  REQUIRE(solveEquation("5*(40/(2+2))") == 50);
}