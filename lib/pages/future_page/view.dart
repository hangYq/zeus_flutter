import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsolateDemoPage extends StatefulWidget {
  const IsolateDemoPage({Key? key}) : super(key: key);

  @override
  State<IsolateDemoPage> createState() => _IsolateDemoPageState();
}

class _IsolateDemoPageState extends State<IsolateDemoPage> {
  int _count = 0;

  static FutureOr<int> _increment(int initCount) async {
    int counter = initCount;
    for (var i = 0; i < 100000; i++) {
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
            OutlinedButton(
              onPressed: _onReset,
              child: const Text(
                'reset',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: _incrementCounterByCompute,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
