import 'dart:async';

import 'package:flutter/material.dart';

import '../../plugins/plugin_test.dart';

class PluginDemoPage extends StatefulWidget {
  PluginDemoPage({super.key});

  @override
  State<PluginDemoPage> createState() => _PluginDemoPageState();
}

class _PluginDemoPageState extends State<PluginDemoPage> {
  String? nativeResult;
  String? receiverResult;
  String? basicMessageResult;
  dynamic eventChannelResult;
  StreamSubscription<dynamic>? subscription;

  @override
  void initState() {
    super.initState();
    final PluginTest plugin = PluginTest();
    plugin.registerCallback('timer', receiverNative);
    subscription = plugin.onProgress(_onData);
  }

  void _onData(dynamic event) {
    setState(() {
      eventChannelResult = event;
    });
  }

  @override
  void dispose() {
    super.dispose();
    final PluginTest plugin = PluginTest();
    plugin.unregisterCallback('timer');
    subscription?.cancel();
  }

  void receiverNative(dynamic result) {
    setState(() {
      receiverResult = '$result';
    });
  }

  Future<void> sendDataToNative() async {
    final PluginTest plugin = PluginTest();
    final Map<dynamic, dynamic>? result = await plugin.sendDataToNative(
      <String, dynamic>{
        'name': 'tom',
        'age': '20',
      },
    );
    setState(() {
      nativeResult = '$result';
    });
  }

  Future<void> sendBasicMessage() async {
    final PluginTest plugin = PluginTest();
    final Map<dynamic, dynamic>? result = await plugin.sendBasicMessage(
      <String, dynamic>{
        'name': 'tom',
        'age': '20',
      },
    );
    setState(() {
      basicMessageResult = '$result';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('plugin Demo'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            OutlinedButton(
              onPressed: sendDataToNative,
              child: Text('sendDataToNative'),
            ),
            Text('Native 返回的数据:$nativeResult'),
            Text('Native 主动调用 Flutter 返回的数据:$receiverResult'),
            OutlinedButton(
              onPressed: sendBasicMessage,
              child: Text('SendBasicMessage'),
            ),
            Text('basicMessageResult 返回的数据:$basicMessageResult'),
            Text('eventChannel 返回的数据:$eventChannelResult'),
          ],
        ),
      ),
    );
  }
}
