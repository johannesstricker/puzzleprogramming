import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:ffi/ffi.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';

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

// NOTE: on iOS the image format is 32BGRA; on Android it's YUV_420_888
class ImageBuffer {
  Pointer<Uint8> data;
  int width;
  int height;
  int bytesPerRow;
  int _bufferSize;

  ImageBuffer._internal(
      {required this.data,
      required this.width,
      required this.height,
      required this.bytesPerRow})
      : _bufferSize = 0;

  factory ImageBuffer.empty() {
    return ImageBuffer._internal(
      data: nullptr,
      width: 0,
      height: 0,
      bytesPerRow: 0,
    );
  }

  void _ensureAllocated(int size) {
    if (_bufferSize < size) {
      calloc.free(data);
      data = calloc<Uint8>(size);
      _bufferSize = size;
    }
  }

  void update(CameraImage image) {
    final plane = image.planes[0];
    final bytes = plane.bytes;

    width = plane.width ?? 0;
    height = plane.height ?? 0;
    bytesPerRow = plane.bytesPerRow;

    _ensureAllocated(bytes.length);
    final bufferBytes = data.asTypedList(bytes.length);
    bufferBytes.setAll(0, bytes);
  }

  bool empty() {
    return _bufferSize == 0;
  }

  // TODO: this can sometimes cause a "buffer beeing freed was not allocated" error
  void free() {
    if (_bufferSize > 0) {
      _bufferSize = 0;
      calloc.free(data);
    }
  }

  Uint8List asTypedList() {
    return data.asTypedList(_bufferSize);
  }
}

// TODO: can we avoid unnecessary memory allocations here? create a view maybe?
Pointer<Uint8> _byteDataToPointer(ByteData bytes) {
  Pointer<Uint8> data = calloc<Uint8>(bytes.buffer.lengthInBytes);
  final bufferBytes = data.asTypedList(bytes.buffer.lengthInBytes);
  bufferBytes.setAll(0, bytes.buffer.asUint8List());
  return data;
}

class PuzzlePlugin {
  static List<DetectedObject> detectObjects(ImageBuffer image) {
    // TODO: implement for Android
    final objects = _PuzzleLib().detectObjects32BGRA(
        image.data, image.width, image.height, image.bytesPerRow);
    final List<DetectedObject> output = List<DetectedObject>.generate(
      objects.size,
      (i) => objects.data[i].clone(),
    );
    _freeDetectedObjects(objects.data);
    return output;
  }

  static Future<List<DetectedObject>> detectObjectsAsync(ui.Image image) async {
    final bytes = await image.toByteData();
    if (bytes == null) {
      return [];
    }
    final pointer = _byteDataToPointer(bytes);
    final objects =
        _PuzzleLib().detectObjects32BGRA(pointer, image.width, image.height, 0);
    final List<DetectedObject> output = List<DetectedObject>.generate(
      objects.size,
      (i) => objects.data[i].clone(),
    );
    _freeDetectedObjects(objects.data);
    calloc.free(pointer);
    return output;
  }

  static void _freeDetectedObjects(Pointer<NativeDetectedObject> ptr) {
    _PuzzleLib().freeDetectedObjects(ptr);
  }
}

class _PuzzleLib {
  final DynamicLibrary _lib;
  late final FreeDetectedObjectsFunction freeDetectedObjects;
  late final DetectObjects32BGRAFunction detectObjects32BGRA;

  static final _PuzzleLib _singleton = _PuzzleLib._internal();

  factory _PuzzleLib() {
    return _singleton;
  }

  _PuzzleLib._internal() : _lib = _getDynamicLibrary() {
    freeDetectedObjects = _lib.lookupFunction<FreeDetectedObjectsFunctionNative,
        FreeDetectedObjectsFunction>("freeDetectedObjects");
    detectObjects32BGRA = _lib.lookupFunction<DetectObjects32BGRAFunctionNative,
        DetectObjects32BGRAFunction>("detectObjects32BGRA");
  }

  static DynamicLibrary _getDynamicLibrary() {
    final DynamicLibrary nativeEdgeDetection = Platform.isAndroid
        ? DynamicLibrary.open("lib_puzzlelib.so")
        : DynamicLibrary.process();
    return nativeEdgeDetection;
  }
}

typedef DetectObjects32BGRAFunctionNative = NativeDetectedObjectList Function(
    Pointer<Uint8>, Int32, Int32, Int32);
typedef DetectObjects32BGRAFunction = NativeDetectedObjectList Function(
    Pointer<Uint8>, int, int, int);

typedef FreeDetectedObjectsFunctionNative = Void Function(
    Pointer<NativeDetectedObject>);
typedef FreeDetectedObjectsFunction = void Function(
    Pointer<NativeDetectedObject>);
