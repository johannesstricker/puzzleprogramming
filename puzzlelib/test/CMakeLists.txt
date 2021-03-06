FIND_PACKAGE(Catch2 REQUIRED)

ADD_EXECUTABLE(Tests)
TARGET_SOURCES(Tests
  PRIVATE
    main.test.cpp
    aruco.test.cpp
    puzzlelib.test.cpp
    ${CMAKE_SOURCE_DIR}/src/puzzlelib.cpp
)
TARGET_LINK_LIBRARIES(Tests
  PRIVATE
    Catch2::Catch2
    opencv_aruco

)
TARGET_INCLUDE_DIRECTORIES(Tests
  PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/src
)

ADD_CUSTOM_COMMAND(TARGET Tests POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/test/data ${CMAKE_CURRENT_BINARY_DIR}/data
)

SET_TARGET_PROPERTIES(Tests PROPERTIES XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")

INCLUDE(Catch)
CATCH_DISCOVER_TESTS(Tests)
