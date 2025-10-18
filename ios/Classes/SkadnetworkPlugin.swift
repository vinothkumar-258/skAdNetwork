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

    // ------------------------------------------------------------
    // MARK: Set fine conversion value (SKAN 1–3)
    // ------------------------------------------------------------
    case "setConversionValue":
      guard let args = call.arguments as? [String: Any],
            let value = args["value"] as? Int else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing value", details: nil))
        return
      }

      if #available(iOS 14.0, *) {
        SKAdNetwork.updateConversionValue(value)
        print("[SKAdNetworkPlugin] Updated fine conversion value: \(value)")
        result(nil)
      } else {
        result(FlutterError(code: "UNSUPPORTED", message: "iOS 14.0+ required", details: nil))
      }

    // ------------------------------------------------------------
    // MARK: Set postback conversion value (SKAN 4+)
    // ------------------------------------------------------------
    case "setPostbackConversionValue":
      guard let args = call.arguments as? [String: Any],
            let fineValue = args["fineValue"] as? Int else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing fineValue", details: nil))
        return
      }

      let coarseValueStr = args["coarseValue"] as? String
      let lockWindow = args["lockWindow"] as? Bool ?? false

      // ✅ SKAN 4.0 (iOS 16.1+)
      if #available(iOS 16.1, *) {
        var coarse: SKAdNetwork.CoarseConversionValue? = nil
        if let c = coarseValueStr {
          switch c.lowercased() {
          case "low":
            coarse = .low
          case "medium":
            coarse = .medium
          case "high":
            coarse = .high
          default:
            coarse = nil
          }
        }

        if let coarse = coarse {
          SKAdNetwork.updatePostbackConversionValue(fineValue, coarseValue: coarse, lockWindow: lockWindow)
          print("[SKAdNetworkPlugin] Updated postback fine:\(fineValue), coarse:\(coarse.rawValue), lock:\(lockWindow)")
        } else {
          SKAdNetwork.updatePostbackConversionValue(fineValue, coarseValue: nil, lockWindow: lockWindow)
          print("[SKAdNetworkPlugin] Updated postback fine:\(fineValue), coarse:nil, lock:\(lockWindow)")
        }

        result(nil)

      // ✅ Fallback for iOS 14–15 (SKAN 1–3)
      } else if #available(iOS 14.0, *) {
        SKAdNetwork.updateConversionValue(fineValue)
        print("[SKAdNetworkPlugin] Fallback: Updated fine conversion value \(fineValue)")
        result(nil)
      } else {
        result(FlutterError(code: "UNSUPPORTED", message: "iOS 14.0+ required", details: nil))
      }

    // ------------------------------------------------------------
    // MARK: Unknown method
    // ------------------------------------------------------------
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
