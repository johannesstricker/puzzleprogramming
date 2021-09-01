import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/services.dart';

class NativeCoordinate extends Struct {
  @Double()
  external double x;
  @Double()
  external double y;

  Coordinate clone() {
    return Coordinate(x, y);
  }
}

class Coordinate {
  final double x;
  final double y;

  Coordinate(this.x, this.y);
}

class NativeDetectedObject extends Struct {
  @Int32()
  external int id;
  external NativeCoordinate topLeft;
  external NativeCoordinate topRight;
  external NativeCoordinate bottomRight;
  external NativeCoordinate bottomLeft;

  DetectedObject clone() {
    return DetectedObject(id, topLeft.clone(), topRight.clone(),
        bottomRight.clone(), bottomLeft.clone());
  }
}

class DetectedObject {
  final int id;
  final Coordinate topLeft;
  final Coordinate topRight;
  final Coordinate bottomRight;
  final Coordinate bottomLeft;

  DetectedObject(
      this.id, this.topLeft, this.topRight, this.bottomRight, this.bottomLeft);
}

class NativeDetectedObjectList extends Struct {
  @Int32()
  external int size;
  external Pointer<NativeDetectedObject> data;
}

typedef DetectObjects32BGRAFunctionNative = NativeDetectedObjectList Function(
    Pointer<Uint8>, Int32, Int32, Int32);
typedef DetectObjects32BGRAFunction = NativeDetectedObjectList Function(
    Pointer<Uint8>, int, int, int);

typedef FreeDetectedObjectsFunctionNative = Void Function(
    Pointer<NativeDetectedObject>);
typedef FreeDetectedObjectsFunction = void Function(
    Pointer<NativeDetectedObject>);

class PuzzlePlugin {
  static const MethodChannel _channel = const MethodChannel('puzzle_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // TODO: offer multiple detectObjects functions but do conversion to the right format right here
  static Future<List<DetectedObject>> detectMultipleObjects32BGRA(
      Pointer<Uint8> bytes,
      int imageWidth,
      int imageHeight,
      int bytesPerRow) async {
    DynamicLibrary nativeLib = _getDynamicLibrary();
    final nativeFunction = nativeLib.lookupFunction<
        DetectObjects32BGRAFunctionNative,
        DetectObjects32BGRAFunction>("detectObjects32BGRA");

    final objects = nativeFunction(bytes, imageWidth, imageHeight, bytesPerRow);
    final List<DetectedObject> output = List<DetectedObject>.generate(
      objects.size,
      (i) => objects.data[i].clone(),
    );
    if (objects.size > 0) {
      freeDetectedObjects(objects.data);
    }
    return output;
  }

  static void freeDetectedObjects(Pointer<NativeDetectedObject> ptr) {
    DynamicLibrary nativeLib = _getDynamicLibrary();
    final nativeFunction = nativeLib.lookupFunction<
        FreeDetectedObjectsFunctionNative,
        FreeDetectedObjectsFunction>("freeDetectedObjects");
    nativeFunction(ptr);
  }

  // TODO: avoid calling this on every frame
  static DynamicLibrary _getDynamicLibrary() {
    final DynamicLibrary nativeEdgeDetection = Platform.isAndroid
        ? DynamicLibrary.open("lib_puzzlelib.so")
        : DynamicLibrary.process();
    return nativeEdgeDetection;
  }
}
