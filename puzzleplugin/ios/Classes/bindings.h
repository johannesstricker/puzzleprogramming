#pragma once

#ifdef __cplusplus
extern "C"
{
#endif

struct Coordinate_t {
  double x;
  double y;
};

struct DetectedObject_t {
  int id;
  struct Coordinate_t topLeft;
  struct Coordinate_t topRight;
  struct Coordinate_t bottomRight;
  struct Coordinate_t bottomLeft;
};

struct DetectedObjectList_t {
  int size;
  struct DetectedObject_t* data;
};

int avoidCodeStripping(void);
struct DetectedObjectList_t detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
void freeDetectedObjects(struct DetectedObject_t* ptr);

#ifdef __cplusplus
}
#endif