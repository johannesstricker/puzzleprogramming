FIND_PACKAGE(Catch2 REQUIRED)
FIND_PACKAGE(OpenCV REQUIRED)
LINK_DIRECTORIES(${OpenCV_LIB_DIR})

ADD_LIBRARY(puzzleprogramming STATIC)
TARGET_SOURCES(puzzleprogramming
  PRIVATE
    main.cpp
    PuzzleProgramming.def
)
TARGET_LINK_LIBRARIES(puzzleprogramming
  PRIVATE
    ${OpenCV_LIBS}
)
TARGET_INCLUDE_DIRECTORIES(puzzleprogramming
  PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${OpenCV_INCLUDE_DIRS}
)