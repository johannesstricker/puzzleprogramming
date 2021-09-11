#pragma once

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct Coordinate Coordinate;
typedef struct DetectedObject DetectedObject;

struct DetectedObjectList {
  int size;
  struct DetectedObject* data;
};

int avoidCodeStripping(void);
struct DetectedObjectList detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
void freeDetectedObjects(struct DetectedObject* ptr);

#ifdef __cplusplus
}
#endif