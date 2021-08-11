#import "PuzzlemathPlugin.h"
#if __has_include(<puzzlemath_plugin/puzzlemath_plugin-Swift.h>)
#import <puzzlemath_plugin/puzzlemath_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "puzzlemath_plugin-Swift.h"
#endif

@implementation PuzzlemathPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPuzzlemathPlugin registerWithRegistrar:registrar];
}
@end
