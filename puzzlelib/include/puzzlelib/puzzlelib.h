#pragma once
#include <vector>

namespace cv {
  class Mat;
}

struct Coordinate {
  double x;
  double y;
};

struct DetectedObject {
  int id;
  Coordinate topLeft;
  Coordinate topRight;
  Coordinate bottomRight;
  Coordinate bottomLeft;
};

namespace puzzle {
  enum class Marker : int {
    Digit_0,
    Digit_1,
    Digit_2,
    Digit_3,
    Digit_4,
    Digit_5,
    Digit_6,
    Digit_7,
    Digit_8,
    Digit_9,
    OperatorAdd,
    OperatorSubtract,
    OperatorMultiply,
    OperatorDivide,
    LeftParenthesis,
    RightParenthesis,
    Start,
    End
  };

  std::vector<DetectedObject> detectObjects(const cv::Mat& image);
  std::vector<DetectedObject> detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
  void createObjectMarkerImages(int size = 100);
  std::string markerToString(Marker marker);
}