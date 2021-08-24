#pragma once

namespace puzzle {
  struct Coordinate {
    double x;
    double y;
  };

  struct DetectedObject {
    int id;
    Coordinate topLeft;
    Coordinate topRight;
    Coordinate bottomRight;
    Coordinate bottomLeft;
  };
}