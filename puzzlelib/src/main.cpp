#include <stdio.h>
#include "puzzlelib/puzzlelib.h"

int main()
{
  puzzle::createObjectMarkerImages();
  printf("ArUco markers created.");
  return 0;
}