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
  struct DetectedObject_t data[25];
};

int avoidCodeStripping(void);
char* detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
char* tokenToString(int tokenType, int value);
struct DetectedObject_t detectObject32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
struct DetectedObjectList_t detectMultipleObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);

#ifdef __cplusplus
}
#endif