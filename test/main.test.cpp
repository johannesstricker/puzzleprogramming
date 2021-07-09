#define CATCH_CONFIG_MAIN
#include "catch.hpp"
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/aruco.hpp>

void addBorderAroundImage(cv::Mat& inout, int padding = 10) {
  cv::Scalar color(255, 0, 0);
  cv::copyMakeBorder(inout, inout, padding, padding, padding, padding, cv::BORDER_CONSTANT, color);
}

cv::Mat createMarkerImage(int code, int markerSize = 100, int padding = 10) {
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);
  cv::Mat image;
  cv::aruco::drawMarker(dictionary, code, markerSize, image, 1);
  addBorderAroundImage(image, padding);
  return image;
}

void requireDetectedMarkersMatch(const cv::Mat& image, const std::vector<int>& expectedMarkers) {
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);
  std::vector<int> markerIds;
  std::vector<std::vector<cv::Point2f>> markerCorners, rejectedCandidates;
  cv::Ptr<cv::aruco::DetectorParameters> parameters = cv::aruco::DetectorParameters::create();
  cv::aruco::detectMarkers(image, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);
  REQUIRE_THAT(markerIds, Catch::Matchers::UnorderedEquals(expectedMarkers));
}

TEST_CASE("detect and decode ArUco codes") {
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);

  GIVEN("an image with an ArUco marker") {
    cv::Mat markerImage = createMarkerImage(23);

    THEN("it correctly detects and decodes the ArUco marker") {
      requireDetectedMarkersMatch(markerImage, { 23 });
    }
  }

  GIVEN("an image with multiple ArUco markers") {
    std::vector<int> codes = { 1, 7, 11 };
    cv::Mat markerImage;
    for (auto code : codes) {
      if (markerImage.empty()) {
        markerImage = createMarkerImage(code);
      } else {
        cv::hconcat(markerImage, createMarkerImage(code), markerImage);
      }
    }

    THEN("it correctly detects and decodes all of the ArUco markers") {
      requireDetectedMarkersMatch(markerImage, codes);
    }

    GIVEN("and with a warped perspective") {
      int imageWidth = markerImage.cols;
      int imageHeight = markerImage.rows;
      std::vector<cv::Point2f> from = {
        cv::Point2f(10, 10),
        cv::Point2f(imageWidth - 10, 10),
        cv::Point2f(10, imageHeight - 10),
        cv::Point2f(imageWidth - 10, imageHeight - 10)
      };
      std::vector<cv::Point2f> to = {
        cv::Point2f(0, 10),
        cv::Point2f(imageWidth - 20, 10),
        cv::Point2f(10, imageHeight - 10),
        cv::Point2f(imageWidth - 10, imageHeight - 10)
      };
      auto transformationMatrix = cv::getPerspectiveTransform(from, to);
      cv::warpPerspective(markerImage, markerImage, transformationMatrix, cv::Size(imageWidth, imageHeight));
      addBorderAroundImage(markerImage, 10);

      THEN("it correctly detects and decodes all of the ArUco markers") {
        requireDetectedMarkersMatch(markerImage, codes);
      }
    }
  }
}