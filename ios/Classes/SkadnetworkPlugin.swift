import Flutter
import UIKit
import StoreKit

public class SkadnetworkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "skadnetwork_plugin", binaryMessenger: registrar.messenger())
    let instance = SkadnetworkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setConversionValue":
      guard let args = call.arguments as? [String: Any],
            let value = args["value"] as? Int else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing value", details: nil))
        return
      }
      if #available(iOS 14.0, *) {
        SKAdNetwork.updateConversionValue(value)
        result(nil)
      } else {
        result(FlutterError(code: "UNSUPPORTED", message: "iOS 14+ required", details: nil))
      }

    case "setPostbackConversionValue":
      guard let args = call.arguments as? [String: Any],
            let fineValue = args["fineValue"] as? Int else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing fineValue", details: nil))
        return
      }
      let coarseValue = args["coarseValue"] as? String
      let lockWindow = args["lockWindow"] as? Bool ?? false
      if #available(iOS 15.4, *) {
        var coarse: SKAdNetwork.CoarseConversionValue? = nil
        if let cv = coarseValue?.lowercased() {
          switch cv {
            case "low": coarse = .low
            case "medium": coarse = .medium
            case "high": coarse = .high
            default: coarse = nil
          }
        }
        SKAdNetwork.updatePostbackConversionValue(fineValue, coarseValue: coarse, lockWindow: lockWindow)
        result(nil)
      } else {
        result(FlutterError(code: "UNSUPPORTED", message: "iOS 15.4+ required", details: nil))
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
