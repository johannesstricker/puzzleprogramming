#include "catch.hpp"
#include "puzzlelib/puzzlelib.h"
#include <opencv2/core.h>
#include <opencv2/imgcodecs.hpp>
#include <vector>
#include <map>

TEST_CASE("detectObjects") {
  GIVEN("an image with multiple aruco markers") {
    cv::Mat image = cv::imread("./data/images/equation.test.jpg");

    TEST("it returns an unordered list of detected objects") {
      auto objects = puzzle::detectObjects(image);
      std::vector<int> objectIds;
      std::transform(objects.begin(), objects.end(), std::back_inserter(objectIds), [](const DetectedObject& object) {
        return object.id;
      });

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

    TEST("it returns objects with the correct position relative to each other") {
      auto objects = puzzle::detectObjects(image);
      std::map<int, int> xPositions;
      for (auto& object : objects) {
        int centerX = (object.topLeft.x + object.topRight.x + object.bottomRight.x + object.bottomLeft.x) / 4.0;
        xPositions[object.id] = centerX;
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
  }
}
