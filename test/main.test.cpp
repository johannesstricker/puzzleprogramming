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
        REQUIRE(result.has_value() == true);
        REQUIRE(result.value() == "14");
      }
    }
  }

  GIVEN("an image without any QR codes") {
    cv::Mat image = cv::imread("data/QRCodes/empty.png", cv::IMREAD_COLOR);
    WHEN("the image is decoded") {
      THEN("it returns an empty optional") {
        REQUIRE(decodeAndInterpret(image).has_value() == false);
      }
    }
  }
}

#include <opencv2/aruco.hpp>

TEST_CASE("interpret ArUco codes") {
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);

  GIVEN("an image with an ArUco marker") {
    cv::Mat markerImage;
    cv::aruco::drawMarker(dictionary, 23, 100, markerImage, 1);

    cv::Scalar color(255, 0, 0);
    cv::copyMakeBorder(markerImage, markerImage, 10, 10, 10, 10, cv::BORDER_CONSTANT, color);

    THEN("it correctly detects and decodes the ArUco marker") {
      std::vector<int> markerIds;
      std::vector<std::vector<cv::Point2f>> markerCorners, rejectedCandidates;
      cv::Ptr<cv::aruco::DetectorParameters> parameters = cv::aruco::DetectorParameters::create();
      cv::aruco::detectMarkers(markerImage, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);
      REQUIRE(markerIds.size() == 1);
      REQUIRE(markerIds.front() == 23);
    }
  }

  GIVEN("an image with multiple ArUco markers") {
    std::vector<int> codes = { 1, 7, 11 };
    cv::Mat imageWithMultipleMarkers;
    cv::Scalar backgroundColor(255, 0, 0);
    for (auto code : codes) {
      cv::Mat image;
      cv::aruco::drawMarker(dictionary, code, 100, image, 1);
      cv::copyMakeBorder(image, image, 10, 10, 10, 10, cv::BORDER_CONSTANT, backgroundColor);
      if (imageWithMultipleMarkers.empty()) {
        imageWithMultipleMarkers = image.clone();
      } else {
        cv::hconcat(imageWithMultipleMarkers, image, imageWithMultipleMarkers);
      }
    }

    THEN("it correctly detects and decodes all of the ArUco markers") {
      std::vector<int> markerIds;
      std::vector<std::vector<cv::Point2f>> markerCorners, rejectedCandidates;
      cv::Ptr<cv::aruco::DetectorParameters> parameters = cv::aruco::DetectorParameters::create();
      cv::aruco::detectMarkers(imageWithMultipleMarkers, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);
      REQUIRE_THAT(markerIds, Catch::Matchers::UnorderedEquals(codes));
    }
  }
}