#pragma once

#ifdef __cplusplus
extern "C"
{
#endif

int avoid_code_stripping();
char* detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);

#ifdef __cplusplus
}
#endif