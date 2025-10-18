# skadnetwork_plugin

A lightweight Flutter plugin for iOS to manually set SKAdNetwork conversion values.

## Usage
```dart
import 'package:skadnetwork_plugin/skadnetwork_plugin.dart';

await SkadnetworkPlugin.setConversionValue(1);

await SkadnetworkPlugin.setPostbackConversionValue(
  fineValue: 2,
  coarseValue: 'medium',
  lockWindow: false,
);
```
