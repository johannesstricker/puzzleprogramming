#include <stdio.h>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/aruco.hpp>

int main()
{
  cv::Mat markerImage;
  cv::Ptr<cv::aruco::Dictionary> dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_4X4_50);
  cv::aruco::drawMarker(dictionary, 23, 100, markerImage, 1);
  cv::imshow("ArUco", markerImage);
  cv::waitKey(1);
  cv::imwrite("./aruco.png", markerImage);
  printf("Hello world from C++");
  return 0;
}