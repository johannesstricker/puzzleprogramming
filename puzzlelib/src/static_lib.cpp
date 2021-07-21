#include "static_lib.h"
#include <string.h>
#include <memory>
#include <sstream>
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

  std::ostringstream buffer;
  try {
    auto markers = detectAndDecodeArUco(mat);
    auto tokens = parseTokens(markers);
    if (tokens.size() == 0) {
      std::string empty = "";
      return strdup(empty.c_str());
    }
    buffer << toString(tokens);
    auto tokensRPN = toReversePolishNotation(tokens);
    auto ast = parseAST(tokensRPN);
    if (ast == nullptr) {
      buffer << " = ?";
    } else {
      buffer << " = " << ast->value();
    }
    return strdup(buffer.str().c_str());
    // return strdup(toString(tokens).c_str());
  } catch(const std::exception& error) {
    std::string errorString(error.what());
    return strdup(errorString.c_str());
  }
}