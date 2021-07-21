ADD_SUBDIRECTORY(aruco)

ADD_EXECUTABLE(puzzleprogramming)
TARGET_SOURCES(puzzleprogramming
  PRIVATE
    main.cpp
    math_equations.cpp
)
TARGET_LINK_LIBRARIES(puzzleprogramming
  PRIVATE
    opencv_aruco
)
TARGET_INCLUDE_DIRECTORIES(puzzleprogramming
  PRIVATE
    ${CMAKE_SOURCE_DIR}/src
)

# ADD_LIBRARY(puzzle SHARED)
# TARGET_SOURCES(puzzle
#   PUBLIC
#     static_lib.cpp
#     math_equations.cpp
# )
# TARGET_LINK_LIBRARIES(puzzle
#   PRIVATE
#     ${OpenCV_LIBS}
#     opencv_aruco
# )
# TARGET_INCLUDE_DIRECTORIES(puzzle
#   PRIVATE
#     ${CMAKE_SOURCE_DIR}/src/include
#     ${OpenCV_INCLUDE_DIRS}
#   PUBLIC
#     ${CMAKE_SOURCE_DIR}/src
# )

# # Disable bitcode, as it is only required on WatchOS and AppleTV and
# # fails to compile opencv
# SET_TARGET_PROPERTIES(puzzle PROPERTIES XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")
# SET_TARGET_PROPERTIES(puzzle PROPERTIES
#   FRAMEWORK TRUE
#   FRAMEWORK_VERSION C
#   MACOSX_FRAMEWORK_IDENTIFIER dev.johannesstricker.puzzle
#   VERSION 0.0.1
#   SOVERSION 0.0.1
#   PUBLIC_HEADER "include/static_lib.h"
#   XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
# )

# SET(IOS_INSTALL_COMBINED TRUE)
# SET(CMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH "NO")

# # See: https://github.com/leetal/ios-cmake/issues/12#issuecomment-421425541
# IF (CMAKE_IOS_INSTALL_COMBINED AND CMAKE_OSX_SYSROOT MATCHES "os")
#   SET_TARGET_PROPERTIES(puzzle PROPERTIES
#     XCODE_ATTRIBUTE_ARCHS[sdk=iphonesimulator*] x86_64
#     XCODE_ATTRIBUTE_VALID_ARCHS[sdk=iphonesimulator*] x86_64
#   )
# ENDIF()

# # INSTALL(TARGETS puzzle)
# INSTALL(TARGETS puzzle FRAMEWORK DESTINATION .)
# INSTALL(DIRECTORY include/
#         DESTINATION puzzle.framework/Headers
#         COMPONENT header_files
#         FILES_MATCHING PATTERN "*.h")

# # SET_TARGET_PROPERTIES(install PROPERTIES XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")