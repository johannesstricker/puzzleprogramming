#define CATCH_CONFIG_MAIN
#include "catch.hpp"
#include "Interpreter.h"

TEST_CASE("interpret mathematical expressions") {
  GIVEN("a string representing a mathematical expression") {
    WHEN("the string is interpreted") {
      THEN("it outputs the result of the mathematical expression") {
        std::string expression = "10 + 5";
        REQUIRE(interpret(expression) == "15");
      }
    }
  }

  GIVEN("a string containing an invalid token") {
    WHEN("the string is interpreted") {
      THEN("the interpreter raises an error") {
        std::string expression = "10 X 5";
        REQUIRE_THROWS_WITH(interpret(expression), "Unexpected token: X");
      }
    }
  }
}