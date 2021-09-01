#include "bindings.h"
#include <vector>
#include <cstring>
#include <puzzlelib/puzzlelib.h>

using namespace puzzle;

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int avoidCodeStripping(void) {
  return 0;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
DetectedObjectList detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow) {
  std::vector<DetectedObject> objects = puzzle::detectObjects32BGRA(imageBytes,
    imageWidth,
    imageHeight,
    bytesPerRow);

  DetectedObjectList result;
  result.size = objects.size();
  result.data = new DetectedObject[result.size];

  for (int i = 0; i < result.size; i++) {
    result.data[i] = objects[i];
  }

  return result;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void freeDetectedObjects(DetectedObject* ptr) {
  delete[] ptr;
}