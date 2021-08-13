import Flutter
import UIKit

public class SwiftPuzzlePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "puzzle_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftPuzzlePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
    if (call.method == "temp") {
      avoidCodeStripping();
    }
  }
}
