#pragma once
#include <vector>
#include "puzzlelib/types.h"

namespace puzzle {
  char* detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
  char* tokenToString(int tokenType, int value);
  std::vector<DetectedObject> detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
}