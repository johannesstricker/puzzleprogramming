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


ADD_LIBRARY(puzzle STATIC)
TARGET_SOURCES(puzzle
  PRIVATE
    static_lib.cpp
    math_equations.cpp
)
TARGET_LINK_LIBRARIES(puzzle
  PUBLIC
    ${OpenCV_LIBS}
    opencv_aruco_static
)
TARGET_INCLUDE_DIRECTORIES(puzzle
  PUBLIC
    ${CMAKE_SOURCE_DIR}/src
    ${OpenCV_INCLUDE_DIRS}
)

# SET(IOS_INSTALL_COMBINED TRUE)

# See: https://github.com/leetal/ios-cmake/issues/12#issuecomment-421425541
# IF (CMAKE_IOS_INSTALL_COMBINED AND CMAKE_OSX_SYSROOT MATCHES "os")
#   SET_TARGET_PROPERTIES(puzzle PROPERTIES
#     XCODE_ATTRIBUTE_ARCHS[sdk=iphonesimulator*] x86_64
#     XCODE_ATTRIBUTE_VALID_ARCHS[sdk=iphonesimulator*] x86_64
#   )
# ENDIF()

INSTALL(TARGETS puzzle)