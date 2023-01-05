import 'dart:async';

import 'package:flutter/services.dart';

typedef MethodCallback = void Function(dynamic result);

class PluginTest {
  factory PluginTest() {
    if (_singleton == null) {
      final MethodChannel methodChannel =
          MethodChannel('flutter.billionbottle.com/method-channel')
            // setMethodCallHandler
            ..setMethodCallHandler((MethodCall call) async {
              final String callMethodName = call.method;
              if (_callbacks[callMethodName] != null) {
                return _callbacks[callMethodName](call.arguments);
              }
            });

      const EventChannel eventChannel =
          EventChannel('flutter.billionbottle.com/event-channel');
      const BasicMessageChannel<dynamic> basicMessageChannel =
          BasicMessageChannel<dynamic>(
        'flutter.billionbottle.com/basic-message-channel',
        StandardMessageCodec(),
      );

      _singleton = PluginTest._(
        methodChannel,
        eventChannel,
        basicMessageChannel,
      );
    }
    return _singleton!;
  }

  PluginTest._(
    this._methodChannel,
    this._eventChanel,
    this._basicMessageChannel,
  );

  final MethodChannel _methodChannel;
  final BasicMessageChannel<dynamic> _basicMessageChannel;
  final EventChannel _eventChanel;
  static PluginTest? _singleton;
  static final Map<String, dynamic> _callbacks = <String, MethodCallback>{};

  void registerCallback(String callMethodName, MethodCallback callback) {
    _callbacks[callMethodName] = callback;
  }

  void unregisterCallback(String callMethodName) {
    _callbacks.remove(callMethodName);
  }

  Future<Map<dynamic, dynamic>?> sendDataToNative(
    Map<String, dynamic> params,
  ) async {
    final Map<dynamic, dynamic>? result = await _methodChannel.invokeMapMethod(
      'sendDataToNative',
      params,
    );
    return result;
  }

  Future<Map<dynamic, dynamic>?> sendBasicMessage(
    Map<String, dynamic> params,
  ) async {
    final Map<dynamic, dynamic>? result =
        await _basicMessageChannel.send(params);
    return result;
  }

  StreamSubscription<dynamic> onProgress(MethodCallback callback) {
    return _eventChanel.receiveBroadcastStream().listen(callback);
  }
}
