import 'package:flutter/material.dart';

import '../../plugins/plugin_test.dart';

class PluginDemoPage extends StatefulWidget {
  PluginDemoPage({super.key});

  @override
  State<PluginDemoPage> createState() => _PluginDemoPageState();
}

class _PluginDemoPageState extends State<PluginDemoPage> {
  Future<void> sendDataToNative() async {
    final PluginTest plugin = PluginTest();
    final Map<dynamic, dynamic>? result = await plugin.sendDataToNative(
      <String, dynamic>{
        'name': 'tom',
        'age': '20',
      },
    );
    print('$result');
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
          ],
        ),
      ),
    );
  }
}
