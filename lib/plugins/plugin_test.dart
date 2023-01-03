import 'package:flutter/services.dart';

class PluginTest {
  factory PluginTest() {
    if (_singleton == null) {
      const MethodChannel methodChannel =
          MethodChannel('flutter.billionbottle.com/method-channel');
      const EventChannel eventChannel =
          EventChannel('flutter.billionbottle.com/event-channel');
      _singleton = PluginTest._(
        methodChannel,
        eventChannel,
      );
    }
    return _singleton!;
  }

  PluginTest._(
    this._methodChannel,
    this._eventChanel,
  );

  final MethodChannel _methodChannel;
  final EventChannel _eventChanel;
  static PluginTest? _singleton;

  Future<Map<dynamic, dynamic>?> sendDataToNative(
    Map<String, dynamic> params,
  ) async {
    final Map<dynamic, dynamic>? result = await _methodChannel.invokeMapMethod(
      'sendDataToNative',
      params,
    );
    return result;
  }
}
