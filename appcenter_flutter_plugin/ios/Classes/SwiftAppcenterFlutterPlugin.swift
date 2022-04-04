import Flutter
import UIKit

 import AppCenter
 import AppCenterAnalytics
 import AppCenterCrashes

public class SwiftAppcenterFlutterPlugin: NSObject, FlutterPlugin {

    static let methodChannelName = "appcenter_flutter_plugin";
        static let instance = SwiftAppcenterFlutterPlugin();
        
        public static func register(binaryMessenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
            let methodChannel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: binaryMessenger)
            methodChannel.setMethodCallHandler(instance.methodChannelHandler);
            return methodChannel;
        }
        
        public static func register(with registrar: FlutterPluginRegistrar) {
            register(binaryMessenger: registrar.messenger());
        }

    public func methodChannelHandler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            debugPrint(call.method)
             switch call.method {
             case "start":
                 guard let args:[String: Any] = (call.arguments as? [String: Any]) else {
                     result(FlutterError(code: "400", message:  "Bad arguments", details: "iOS could not recognize flutter arguments in method: (start)") )
                     return
                 }

                 let secret = args["secret"] as! String
                 AppCenter.start(withAppSecret: secret, services: [
                    Analytics.self,
                    Crashes.self,
                ])
             case "trackEvent":
                 trackEvent(call: call, result: result)
                 return
             case "getInstallId":
                 result(AppCenter.installId.uuidString)
                 return
             case "isCrashesEnabled":
                 result(Crashes.enabled)
                 return
             case "configureCrashes":
                 Crashes.enabled = call.arguments as! Bool
             case "isAnalyticsEnabled":
                 result(Analytics.enabled)
                 return
             case "configureAnalytics":
                 Analytics.enabled = call.arguments as! Bool
             case "generateTestCrash":
                 Crashes.generateTestCrash()
             case "enableManualSessionTracker":
                 Analytics.enableManualSessionTracker()
             case "startSession":
                 Analytics.startSession()
             default:
                 result(FlutterMethodNotImplemented);
                 return
             }
            
            result(nil);
        }
        
        private func trackEvent(call: FlutterMethodCall, result: FlutterResult) {
            guard let args:[String: Any] = (call.arguments as? [String: Any]) else {
                result(FlutterError(code: "400", message:  "Bad arguments", details: "iOS could not recognize flutter arguments in method: (trackEvent)") )
                return
            }
            
            let name = args["name"] as? String
            let properties = args["properties"] as? [String: String]
            if(name != nil) {
                 Analytics.trackEvent(name!, withProperties: properties)
            }
            
            result(nil)
        }

}
