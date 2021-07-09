#include <stdio.h>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/aruco.hpp>
#include "math_equations.h"

int main()
{
  createArUcoMarkers("./math_equations");
  printf("ArUco markers created.");
  return 0;
}