#!/bin/bash
rm -rf build
rm -rf example/build
rm -rf example/ios/Pods
rm -rf example/ios/build
rm -rf example/ios/Podfile.lock
pushd example
flutter clean
flutter pub get
flutter run
popd