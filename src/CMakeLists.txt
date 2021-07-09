ADD_SUBDIRECTORY(aruco)

FIND_PACKAGE(Catch2 REQUIRED)
FIND_PACKAGE(OpenCV REQUIRED)
LINK_DIRECTORIES(${OpenCV_LIB_DIR})

ADD_EXECUTABLE(puzzleprogramming)
TARGET_SOURCES(puzzleprogramming
  PRIVATE
    main.cpp
    math_equations.cpp
)
TARGET_LINK_LIBRARIES(puzzleprogramming
  PRIVATE
    ${OpenCV_LIBS}
    opencv_aruco
)
TARGET_INCLUDE_DIRECTORIES(puzzleprogramming
  PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${OpenCV_INCLUDE_DIRS}
)