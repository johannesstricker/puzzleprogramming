#pragma once

namespace puzzle {
  char* detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
  char* tokenToString(int tokenType, int value);
}