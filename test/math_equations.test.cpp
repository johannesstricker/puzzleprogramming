#include "catch.hpp"
#include "math_equations.h"

TEST_CASE("Marker") {
  REQUIRE(Marker::Digit_0 < Marker::Digit_1);
}

TEST_CASE("parse math equations") {
  SECTION("convert to string") {
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

  SECTION("addition") {
    std::list<Marker> equation = {
      Marker::Digit_1,
      Marker::Digit_0,
      Marker::OperatorAdd,
      Marker::Digit_9,
      Marker::OperatorAdd,
      Marker::Digit_5,
      Marker::Digit_2,
    };
    auto ast = parseASTFromMarkers(equation);
    REQUIRE(ast->value() == 71);
  }

  SECTION("subtraction") {
    std::list<Marker> equation = {
      Marker::Digit_9,
      Marker::Digit_7,
      Marker::OperatorSubtract,
      Marker::Digit_1,
      Marker::Digit_0
    };
    auto ast = parseASTFromMarkers(equation);
    REQUIRE(ast->value() == 87);
  }

  SECTION("multiplication") {
    std::list<Marker> equation = {
      Marker::Digit_2,
      Marker::OperatorAdd,
      Marker::Digit_7,
      Marker::OperatorMultiply,
      Marker::Digit_3,
      Marker::OperatorSubtract,
      Marker::Digit_1,
      Marker::Digit_0
    };
    auto ast = parseASTFromMarkers(equation);
    REQUIRE(ast->value() == 13);
  }

  SECTION("division") {
    std::list<Marker> equation = {
      Marker::Digit_2,
      Marker::Digit_2,
      Marker::OperatorMultiply,
      Marker::Digit_2,
      Marker::OperatorDivide,
      Marker::Digit_7
    };
    auto ast = parseASTFromMarkers(equation);
    REQUIRE(ast->value() == 6);
  }
}