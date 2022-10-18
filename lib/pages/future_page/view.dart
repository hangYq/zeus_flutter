import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FutureDemoPage extends StatefulWidget {
  const FutureDemoPage({
    Key? key,
    this.arguments,
  }) : super(key: key);

  final dynamic arguments;

  @override
  State<FutureDemoPage> createState() => _FutureDemoPageState();
}

class _FutureDemoPageState extends State<FutureDemoPage> {
  int _count = 0;

  static FutureOr<int> _increment(int initCount) async {
    int counter = initCount;
    for (var i = 0; i < 1000000000; i++) {
      counter += i;
    }
    return counter;
  }

  void _incrementCounter() async {
    final int result = await _increment(0);
    setState(() {
      _count = result;
    });
  }

  void _incrementCounterByCompute() async {
    final int result = await compute(_increment, 0);
    setState(() {
      _count = result;
    });
  }

  void _onReset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate Demo  Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/rabbit.gif',
            ),
            Text('你点击了$_count次'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _onReset,
                  child: const Text(
                    'reset',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: _incrementCounter,
                  child: const Text(
                    'ANR increment',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: _incrementCounterByCompute,
                  child: const Text(
                    'compute',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
