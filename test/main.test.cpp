#define CATCH_CONFIG_MAIN
#include "catch.hpp"
#include "Interpreter.h"
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>

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

TEST_CASE("interpret QR codes") {
  GIVEN("an image with a mathematical expression encoded in multiple QR codes") {
    cv::Mat image = cv::imread("data/QRCodes/9+5.png", cv::IMREAD_COLOR);
    WHEN("the image is decoded") {
      THEN("it outputs the result of the mathematical expression") {
        auto result = decodeAndInterpret(image);
        REQUIRE(result.has_value());
        REQUIRE(result.value() == "14");
      }
    }
  }
}