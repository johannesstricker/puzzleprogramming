#include "puzzlelib/puzzlelib.h"
#include <string.h>
#include <memory>
#include <sstream>
#include <vector>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv-contrib/aruco.hpp>
#include "math_equations.h"


std::vector<puzzle::DetectedObject> puzzle::detectObjects32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow) {
  cv::Mat sourceImage(imageHeight, imageWidth, CV_8UC4, imageBytes, bytesPerRow);
  cv::Mat image;
  cv::cvtColor(sourceImage, image, cv::COLOR_BGRA2GRAY, 1);

  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_4X4_50);
  std::vector<int> markerIds;
  std::vector<std::vector<cv::Point2f>> markerCorners, rejectedCandidates;
  cv::Ptr<cv::aruco::DetectorParameters> parameters = cv::aruco::DetectorParameters::create();
  cv::aruco::detectMarkers(image, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);

  std::vector<puzzle::DetectedObject> objects;
  for (int i = 0; i < markerIds.size(); i++) {
    puzzle::DetectedObject object;
    object.id = markerIds[i];
    std::vector<cv::Point2f>& corners = markerCorners[i];
    object.topLeft.x = corners[0].x; object.topLeft.y = corners[0].y;
    object.topRight.x = corners[1].x; object.topRight.y = corners[1].y;
    object.bottomRight.x = corners[2].x; object.bottomRight.y = corners[2].y;
    object.bottomLeft.x = corners[3].x; object.bottomLeft.y = corners[3].y;
    objects.push_back(object);
  }
  return objects;
}

char* puzzle::detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow) {
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

char* puzzle::tokenToString(int tokenId, int value) {
  Token token(static_cast<Token::ID>(tokenId), value);
  return strdup(token.toString().c_str());
}

std::list<Marker> detectAndDecodeArUco(const cv::Mat& image) {
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_4X4_50);
  std::vector<int> markerIds;
  std::vector<std::vector<cv::Point2f>> markerCorners, rejectedCandidates;
  cv::Ptr<cv::aruco::DetectorParameters> parameters = cv::aruco::DetectorParameters::create();
  cv::aruco::detectMarkers(image, dictionary, markerCorners, markerIds, parameters, rejectedCandidates);

  auto markerIdsSortedLTR = sortMarkersLTR(markerIds, markerCorners);
  std::list<Marker> output;
  for (auto id : markerIdsSortedLTR) {
    // TODO: sanitize
    output.push_back(static_cast<Marker>(id));
  }
  return output;
}