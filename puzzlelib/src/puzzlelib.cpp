#include "puzzlelib/puzzlelib.h"
#include <string.h>
#include <vector>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv-contrib/aruco.hpp>

using namespace puzzle;

std::vector<DetectedObject> puzzle::detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow) {
  cv::Mat sourceImage(imageHeight, imageWidth, CV_8UC4, imageBytes, bytesPerRow);
  return detectObjects(sourceImage);
}

std::vector<DetectedObject> puzzle::detectObjects(const cv::Mat& sourceImage) {
  if (sourceImage.empty()) {
    return std::vector<DetectedObject>();
  }

  cv::Mat image;
  cv::cvtColor(sourceImage, image, cv::COLOR_BGRA2GRAY, 1);
  // NOTE: if detection is not good enough, use adaptive threshold

  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_4X4_50);
  std::vector<int> markerIds;
  std::vector<std::vector<cv::Point2f>> markerCorners, rejectedCandidates;
  cv::Ptr<cv::aruco::DetectorParameters> parameters = cv::aruco::DetectorParameters::create();
  cv::aruco::detectMarkers(image, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);

  std::vector<DetectedObject> objects;
  for (int i = 0; i < markerIds.size(); i++) {
    DetectedObject object;
    object.id = markerIds[i];
    std::vector<cv::Point2f>& corners = markerCorners[i];
    object.topLeft.x = corners[0].x; object.topLeft.y = corners[0].y;
    object.topRight.x = corners[1].x; object.topRight.y = corners[1].y;
    object.bottomRight.x = corners[2].x; object.bottomRight.y = corners[2].y;
    object.bottomLeft.x = corners[3].x; object.bottomLeft.y = corners[3].y;
    objects.push_back(object);
  }
  return objects;
}

void puzzle::createObjectMarkerImages(int size) {
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_4X4_50);
  for (int code = static_cast<int>(Marker::Digit_0); code <= static_cast<int>(Marker::End); code++) {
    cv::Mat image;
    cv::aruco::drawMarker(dictionary, code, size, image, 1);

    Marker marker = static_cast<Marker>(code);
    std::string fileName = markerToString(marker) + ".png";
    std::string filePath = fileName;
    cv::imwrite(filePath, image);
  }
}

std::string puzzle::markerToString(Marker marker) {
  switch (marker) {
    case Marker::OperatorAdd: return "OPERATOR_ADD";
    case Marker::OperatorSubtract: return "OPERATOR_SUBTRACT";
    case Marker::OperatorMultiply: return "OPERATOR_MULTIPLY";
    case Marker::OperatorDivide: return "OPERATOR_DIVIDE";
    case Marker::LeftParenthesis: return "LEFT_PARENTHESIS";
    case Marker::RightParenthesis: return "RIGHT_PARENTHESIS";
    case Marker::Start: return "START";
    case Marker::End: return "END";
    default: {
      int value = static_cast<int>(marker) - static_cast<int>(Marker::Digit_0);
      return "DIGIT_" + std::to_string(value);
    }
  }
}