#include "catch.hpp"
#include "math_equations.h"

TEST_CASE("Marker") {
  REQUIRE(Marker::Digit_0 < Marker::Digit_1);
}

TEST_CASE("stringToMarkers") {
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
  std::string input = "012345 6789+-*/()";
  REQUIRE(stringToMarkers(input) == expectedEquation);
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

int solveEquation(const std::string& input) {
  auto ast = parseASTFromMarkers(stringToMarkers(input));
  return ast->value();
}

TEST_CASE("solve math equations") {
  REQUIRE(solveEquation("10+9+52") == 71);
  REQUIRE(solveEquation("97-10") == 87);
  REQUIRE(solveEquation("2+7*3-10") == 13);
  REQUIRE(solveEquation("22*2/7") == 6);
  REQUIRE(solveEquation("(8+2)/2") == 5);
  REQUIRE(solveEquation("10*(4/2+8)") == 100);
  REQUIRE(solveEquation("5*(40/(2+2))") == 50);
}