#import "AnnotationPlugin.h"
#if __has_include(<annotation/annotation-Swift.h>)
#import <annotation/annotation-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "annotation-Swift.h"
#endif

@implementation AnnotationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAnnotationPlugin registerWithRegistrar:registrar];
}
@end
