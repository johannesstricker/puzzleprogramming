#include "bindings.h"
#include <puzzlelib/puzzlelib.h>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int avoidCodeStripping(void) {
  return 0;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
char* detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow) {
  return puzzle::detectAndDecodeArUco32BGRA(imageBytes, imageWidth, imageHeight, bytesPerRow);
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
char* tokenToString(int tokenId, int value) {
  return puzzle::tokenToString(tokenId, value);
}