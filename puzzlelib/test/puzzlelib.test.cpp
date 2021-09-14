#include "puzzlelib/puzzlelib.h"
#include "catch.hpp"
#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <vector>
#include <map>
#include <iostream>

#include <filesystem>

using namespace puzzle;

std::vector<int> getObjectIDs(const std::vector<DetectedObject>& objects) {
  std::vector<int> objectIDs;
  std::transform(objects.begin(), objects.end(), std::back_inserter(objectIDs), [](const DetectedObject& object) {
    return object.id;
  });
  return objectIDs;
}

TEST_CASE("detectObjects") {
  GIVEN("an image with multiple aruco markers") {
    auto imagePath = std::filesystem::current_path() / "data" / "images" / "equation_light_background.test.jpg";
    cv::Mat image = cv::imread(imagePath.string(), cv::IMREAD_COLOR);

    THEN("it returns an unordered list of detected objects") {
      auto objects = puzzle::detectObjects(image);
      std::vector<int> objectIds = getObjectIDs(objects);
      std::vector<int> expectedObjectIds{
        static_cast<int>(Marker::Start),
        static_cast<int>(Marker::LeftParenthesis),
        static_cast<int>(Marker::Digit_8),
        static_cast<int>(Marker::OperatorAdd),
        static_cast<int>(Marker::Digit_9),
        static_cast<int>(Marker::RightParenthesis),
        static_cast<int>(Marker::OperatorDivide),
        static_cast<int>(Marker::Digit_2),
        static_cast<int>(Marker::End)
      };
      REQUIRE_THAT(objectIds, Catch::Matchers::UnorderedEquals(expectedObjectIds));
    }

    THEN("it returns objects with the correct position relative to each other") {
      auto objects = puzzle::detectObjects(image);
      std::map<Marker, double> xPositions;
      for (auto& object : objects) {
        double centerX = (object.topLeft.x + object.topRight.x + object.bottomRight.x + object.bottomLeft.x) / 4.0;
        xPositions[static_cast<Marker>(object.id)] = centerX;
      }

      REQUIRE(xPositions[Marker::Start] < xPositions[Marker::LeftParenthesis]);
      REQUIRE(xPositions[Marker::LeftParenthesis] < xPositions[Marker::Digit_8]);
      REQUIRE(xPositions[Marker::Digit_8] < xPositions[Marker::OperatorAdd]);
      REQUIRE(xPositions[Marker::OperatorAdd] < xPositions[Marker::Digit_9]);
      REQUIRE(xPositions[Marker::Digit_9] < xPositions[Marker::RightParenthesis]);
      REQUIRE(xPositions[Marker::RightParenthesis] < xPositions[Marker::OperatorDivide]);
      REQUIRE(xPositions[Marker::OperatorDivide] < xPositions[Marker::Digit_2]);
      REQUIRE(xPositions[Marker::Digit_2] < xPositions[Marker::End]);
    }
  }

  // TODO: preprocess image to be able to detect markers regardless of background
  // GIVEN("an image with multiple aruco markes on dark background") {
  //   auto imagePath = std::filesystem::current_path() / "data" / "images" / "equation_dark_background.test.jpg";
  //   cv::Mat image = cv::imread(imagePath.string(), cv::IMREAD_COLOR);

  //   THEN("it returns an unordered list of detected objects") {
  //     auto objects = puzzle::detectObjects(image);
  //     std::vector<int> objectIds = getObjectIDs(objects);
  //     std::vector<int> expectedObjectIds{
  //       static_cast<int>(Marker::Start),
  //       static_cast<int>(Marker::Digit_5),
  //       static_cast<int>(Marker::Digit_6),
  //       static_cast<int>(Marker::OperatorAdd),
  //       static_cast<int>(Marker::Digit_3),
  //       static_cast<int>(Marker::Digit_0),
  //       static_cast<int>(Marker::OperatorMultiply),
  //       static_cast<int>(Marker::Digit_4),
  //       static_cast<int>(Marker::End)
  //     };
  //     REQUIRE_THAT(objectIds, Catch::Matchers::UnorderedEquals(expectedObjectIds));
  //   }
  // }
}
