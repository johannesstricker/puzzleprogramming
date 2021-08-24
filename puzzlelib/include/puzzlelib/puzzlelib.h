#pragma once
#include "puzzlelib/types.h"

namespace puzzle {
  char* detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
  char* tokenToString(int tokenType, int value);
  DetectedObject detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
}