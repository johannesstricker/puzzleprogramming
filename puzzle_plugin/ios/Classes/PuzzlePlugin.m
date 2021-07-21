#import "PuzzlePlugin.h"
#if __has_include(<puzzle_plugin/puzzle_plugin-Swift.h>)
#import <puzzle_plugin/puzzle_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "puzzle_plugin-Swift.h"
#endif

@implementation PuzzlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPuzzlePlugin registerWithRegistrar:registrar];
}
@end
