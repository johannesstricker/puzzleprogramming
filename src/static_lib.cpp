#include "static_lib.h"
#include <string.h>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include "math_equations.h"

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int avoid_code_stripping() {
  return 0;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
char* detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow) {
  cv::Mat src(imageHeight, imageWidth, CV_8UC4, imageBytes, bytesPerRow);
  cv::Mat mat;
  cv::cvtColor(src, mat, cv::COLOR_BGRA2GRAY, 1);

  if (mat.size().width == 0 || mat.size().height == 0) {
    std::string error("Error: invalid image size.");
    return strdup(error.c_str());
  }

  try {
    auto markers = detectAndDecodeArUco(src);
    auto tokens = parseTokens(markers);
    return strdup(toString(tokens).c_str());
  } catch(const std::exception& error) {
    std::string errorString(error.what());
    return strdup(errorString.c_str());
  }

}