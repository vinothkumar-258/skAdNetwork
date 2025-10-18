import 'package:flutter/services.dart';

class SkadnetworkPlugin {
  static const MethodChannel _channel = MethodChannel('skadnetwork_plugin');

  static Future<void> setConversionValue(int value) async {
    await _channel.invokeMethod('setConversionValue', {'value': value});
  }

  static Future<void> setPostbackConversionValue({
    required int fineValue,
    String? coarseValue,
    bool lockWindow = false,
  }) async {
    await _channel.invokeMethod('setPostbackConversionValue', {
      'fineValue': fineValue,
      'coarseValue': coarseValue,
      'lockWindow': lockWindow,
    });
  }
}
