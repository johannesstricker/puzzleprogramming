
ADD_LIBRARY(opencv_aruco OBJECT)
TARGET_SOURCES(opencv_aruco
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/src/apriltag_quad_thresh.cpp
    ${CMAKE_CURRENT_LIST_DIR}/src/aruco.cpp
    ${CMAKE_CURRENT_LIST_DIR}/src/charuco.cpp
    ${CMAKE_CURRENT_LIST_DIR}/src/dictionary.cpp
    ${CMAKE_CURRENT_LIST_DIR}/src/zmaxheap.cpp
)
TARGET_LINK_LIBRARIES(opencv_aruco
  PRIVATE
    ${OpenCV_LIBS}
)
TARGET_INCLUDE_DIRECTORIES(opencv_aruco
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/src
    ${OpenCV_INCLUDE_DIRS}
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/include
)
TARGET_LINK_DIRECTORIES(opencv_aruco
  PRIVATE
    ${OpenCV_LIB_DIR}
)

SET_TARGET_PROPERTIES(opencv_aruco PROPERTIES XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")
