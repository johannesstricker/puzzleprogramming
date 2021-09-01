#include "bindings.h"
#include <puzzlelib/puzzlelib.h>
#include <vector>
#include <cstring>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int avoidCodeStripping(void) {
  return 0;
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
DetectedObjectList_t detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow) {
  std::vector<puzzle::DetectedObject> objects = puzzle::detectObjects32BGRA(imageBytes,
    imageWidth,
    imageHeight,
    bytesPerRow);

  int size = objects.size() > 25 ? 25 : objects.size();

  DetectedObjectList_t result;
  result.size = size;
  result.data = new DetectedObject_t[size];

  for (int i = 0; i < size; i++) {
    result.data[i].id = objects[i].id;
    result.data[i].topLeft = convert(objects[i].topLeft);
    result.data[i].topRight = convert(objects[i].topRight);
    result.data[i].bottomRight = convert(objects[i].bottomRight);
    result.data[i].bottomLeft = convert(objects[i].bottomLeft);
  }

  return result;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void freeDetectedObjects(DetectedObject_t* ptr) {
  delete[] ptr;
}