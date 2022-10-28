import 'dart:async';

import 'package:flutter/material.dart';

class StreamGenerateDemoPage extends StatelessWidget {
  const StreamGenerateDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StreamGenerateDemoPage'),
        centerTitle: true,
      ),
      body: StreamHomePage(),
    );
  }
}

class SignalStream {
  SignalState _signalState = SignalState(counter: 10, type: SignalType.denial);
  Stream<SignalState> createStream({int count = 100}) async* {
    for (int i = 0; i < count; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      _signalState = _signalState.next();
      yield _signalState;
    }
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  final SignalStream signalStream = SignalStream();

  SignalState _signalState = SignalState(counter: 10, type: SignalType.denial);
  late StreamSubscription<SignalState> _subscription;
  bool _hasError = false;

  @override
  void initState() {
    _subscription = signalStream.createStream().listen(onData);

    super.initState();
  }

  void handleError({bool flag = true}) {
    setState(() {
      _hasError = flag;
    });
  }

  Future<void> onData(SignalState state) async {
    _signalState = state;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onToggle() {
    if (_subscription.isPaused) {
      _subscription.resume();
    } else {
      _subscription.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_hasError)
            Text(
              'Error Signal',
              style: TextStyle(
                color: Colors.red,
                fontSize: 28,
              ),
            )
          else
            SignalLamp(
              state: _signalState,
            ),
          OutlinedButton(
            onPressed: onToggle,
            child: Text('toggle'),
          ),
        ],
      ),
    );
  }
}

const int _allowMaxCount = 10;
const int _awaitMaxCount = 3;
const int _denialMaxCount = 10;

enum SignalType {
  /// 绿灯
  allow,

  /// 红灯
  denial,

  /// 黄灯
  wait,
}

class SignalState {
  SignalState({
    required this.counter,
    required this.type,
  });

  final int counter;
  final SignalType type;

  SignalState next() {
    if (counter > 1) {
      return SignalState(type: type, counter: counter - 1);
    } else {
      switch (type) {
        case SignalType.allow:
          return SignalState(type: SignalType.denial, counter: _allowMaxCount);
        case SignalType.denial:
          return SignalState(type: SignalType.wait, counter: _awaitMaxCount);
        case SignalType.wait:
          return SignalState(type: SignalType.allow, counter: _denialMaxCount);
      }
    }
  }
}

class Lamp extends StatelessWidget {
  const Lamp({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
    );
  }
}

class SignalLamp extends StatelessWidget {
  const SignalLamp({
    required this.state,
    Key? key,
  }) : super(key: key);

  final SignalState state;

  Color get activeColor {
    switch (state.type) {
      case SignalType.allow:
        return Colors.green;
      case SignalType.denial:
        return Colors.red;
      case SignalType.wait:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            children: <Widget>[
              Lamp(color: state.type == SignalType.denial ? activeColor : null),
              Lamp(color: state.type == SignalType.wait ? activeColor : null),
              Lamp(color: state.type == SignalType.allow ? activeColor : null),
            ],
          ),
        ),
        Text(
          '${state.counter}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 50,
            color: activeColor,
          ),
        )
      ],
    );
  }
}
