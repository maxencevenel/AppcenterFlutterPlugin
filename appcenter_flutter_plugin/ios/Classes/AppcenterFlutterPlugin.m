#import "AppcenterFlutterPlugin.h"
#if __has_include(<appcenter_flutter_plugin/appcenter_flutter_plugin-Swift.h>)
#import <appcenter_flutter_plugin/appcenter_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appcenter_flutter_plugin-Swift.h"
#endif

@implementation AppcenterFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppcenterFlutterPlugin registerWithRegistrar:registrar];
}
@end
