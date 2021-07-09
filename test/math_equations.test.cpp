#include "catch.hpp"
#include "math_equations.h"

TEST_CASE("Marker") {
  REQUIRE(Marker::Digit_0 < Marker::Digit_1);
}

TEST_CASE("parse math equations") {
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
}