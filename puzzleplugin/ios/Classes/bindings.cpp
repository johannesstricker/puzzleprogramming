#include "bindings.h"
#include <puzzlelib/puzzlelib.h>
#include <puzzlelib/types.h>
#include <vector>

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

Coordinate_t createCoordinate(double x, double y) {
  Coordinate_t result;
  result.x = x;
  result.y = y;
  return result;
}

DetectedObject_t createDetectedObject(int id) {
  DetectedObject_t result;
  result.id = id;
  result.topLeft = createCoordinate(0, 0);
  result.topRight = createCoordinate(0, 0);
  result.bottomRight = createCoordinate(0, 0);
  result.bottomLeft = createCoordinate(0, 0);
  return result;
}

Coordinate_t convert(puzzle::Coordinate input) {
  return createCoordinate(input.x, input.y);
}

DetectedObject_t convert(puzzle::DetectedObject input) {
  DetectedObject_t result = createDetectedObject(input.id);
  result.topLeft = convert(input.topLeft);
  result.topRight = convert(input.topRight);
  result.bottomRight = convert(input.bottomRight);
  result.bottomLeft = convert(input.bottomLeft);
  return result;
}


extern "C" __attribute__((visibility("default"))) __attribute__((used))
DetectedObject_t detectObject32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow) {
  puzzle::DetectedObject object = puzzle::detectObjects32BGRA(imageBytes,
    imageWidth,
    imageHeight,
    bytesPerRow);
  return convert(object);
  // if (objects.size() > 0) {
  //   return convert(objects[0]);
  // }
  // return createDetectedObject(-1);
}