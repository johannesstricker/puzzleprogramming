#!/bin/sh

mkdir -p build/arm64-ios
pushd build/arm64-ios
cmake -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
      -DVCPKG_DEFAULT_TRIPLET="arm64-ios" \
      -DVCPKG_TARGET_TRIPLET="arm64-ios" \
      -G Xcode \
      ../..
cmake --build . --target install
popd

# mkdir -p build/ios-arm64
# pushd build/ios-arm64
# cmake -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
#       -DVCPKG_DEFAULT_TRIPLET="ios-arm64" \
#       -DVCPKG_TARGET_TRIPLET="ios-arm64" \
#       -G Xcode \
#       ../..
# cmake --build .
# popd

# mkdir -p build/ios-x86_64
# pushd build/ios-x86_64
# cmake -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
#       -DVCPKG_DEFAULT_TRIPLET="ios-x86_64" \
#       -DVCPKG_TARGET_TRIPLET="ios-x86_64" \
#       -G Xcode \
#       ../..
# cmake --build .
# popd

# # this is the command to create a fat library
# lipo -create build/ios-arm64/src/Debug/
# lipo -create ./SwifteriOS-sim.framework/SwifteriOS ./SwifteriOS-dev.framework/SwifteriOS -output ./SwifteriOS