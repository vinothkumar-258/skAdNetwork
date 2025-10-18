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
    // MARK: SKAN 1–3 fine value (iOS 14+)
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
    // MARK: SKAN 4.0+ (iOS 16.1+)
    // ------------------------------------------------------------
    case "setPostbackConversionValue":
      guard let args = call.arguments as? [String: Any],
            let fineValue = args["fineValue"] as? Int else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing fineValue", details: nil))
        return
      }

      let coarseValueStr = args["coarseValue"] as? String
      let lockWindow = args["lockWindow"] as? Bool ?? false

      if #available(iOS 16.1, *) {
        var coarse: SKAdNetwork.CoarseConversionValue = .low  // Default

        if let c = coarseValueStr {
          switch c.lowercased() {
          case "medium": coarse = .medium
          case "high": coarse = .high
          default: coarse = .low
          }
        }

        SKAdNetwork.updatePostbackConversionValue(fineValue, coarseValue: coarse, lockWindow: lockWindow)
        print("[SKAdNetworkPlugin] Updated postback fine:\(fineValue), coarse:\(coarse.rawValue), lock:\(lockWindow)")
        result(nil)

      } else if #available(iOS 14.0, *) {
        // Fallback for SKAN < 4
        SKAdNetwork.updateConversionValue(fineValue)
        print("[SKAdNetworkPlugin] Fallback (SKAN 1–3): fine \(fineValue)")
        result(nil)
      } else {
        result(FlutterError(code: "UNSUPPORTED", message: "iOS 14.0+ required", details: nil))
      }

    // ------------------------------------------------------------
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
