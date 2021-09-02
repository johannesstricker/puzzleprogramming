ADD_SUBDIRECTORY(aruco)

ADD_EXECUTABLE(puzzleprogramming)
TARGET_SOURCES(puzzleprogramming
  PRIVATE
    main.cpp
    puzzlelib.cpp
)
TARGET_LINK_LIBRARIES(puzzleprogramming
  PRIVATE
    opencv_aruco
)
TARGET_INCLUDE_DIRECTORIES(puzzleprogramming
  PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/src
)
