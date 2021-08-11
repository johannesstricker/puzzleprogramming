import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

typedef DetectQrCode32BGRAFunctionNative = Pointer<Utf8> Function(
    Pointer<Uint8>, Int32, Int32, Int32);
typedef DetectQrCode32BGRAFunction = Pointer<Utf8> Function(
    Pointer<Uint8>, int, int, int);

typedef TokenToStringFunctionNative = Pointer<Utf8> Function(Int32, Int32);
typedef TokenToStringFunction = Pointer<Utf8> Function(int, int);

class PuzzlemathPlugin {
  static const MethodChannel _channel =
      const MethodChannel('puzzlemath_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> detectAndDecodeArUco32BGRA(Pointer<Uint8> bytes,
      int imageWidth, int imageHeight, int bytesPerRow) async {
    DynamicLibrary nativeLib = _getDynamicLibrary();
    final nativeFunction = nativeLib.lookupFunction<
        DetectQrCode32BGRAFunctionNative,
        DetectQrCode32BGRAFunction>("detectAndDecodeArUco32BGRA");
    Pointer<Utf8> decodedString =
        nativeFunction(bytes, imageWidth, imageHeight, bytesPerRow);
    final result = decodedString.toDartString();
    malloc.free(decodedString);
    return result;
  }

  static Future<String> tokenToString(int tokenId, int value) async {
    DynamicLibrary nativeLib = _getDynamicLibrary();
    final nativeFunction = nativeLib.lookupFunction<TokenToStringFunctionNative,
        TokenToStringFunction>("tokenToString");
    Pointer<Utf8> outputString = nativeFunction(tokenId, value);
    final result = outputString.toDartString();
    malloc.free(outputString);
    return result;
  }

  static DynamicLibrary _getDynamicLibrary() {
    final DynamicLibrary nativeEdgeDetection = Platform.isAndroid
        ? DynamicLibrary.open("lib_puzzlelib.so")
        : DynamicLibrary.process();
    return nativeEdgeDetection;
  }
}
