import 'package:flutter/material.dart';

class InheritedDemoPage extends StatefulWidget {
  const InheritedDemoPage({Key? key}) : super(key: key);

  @override
  State<InheritedDemoPage> createState() => _InheritedDemoPageState();
}

class _InheritedDemoPageState extends State<InheritedDemoPage> {
  int _number = 0;

  void _incrementCounter() {
    setState(() {
      _number++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('inherited page demo'),
        centerTitle: true,
      ),
      body: InheritedInfoWidget(
        number: _number,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoChildWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class InheritedInfoWidget extends InheritedWidget {
  InheritedInfoWidget({
    Key? key,
    required this.number,
    required this.child,
  }) : super(
          key: key,
          child: child,
        );

  final int number;
  final Widget child;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static InheritedInfoWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedInfoWidget>();

    // return context
    //     .getElementForInheritedWidgetOfExactType<InheritedInfoWidget>()
    //     ?.widget as InheritedInfoWidget;
  }
}

class InfoChildWidget extends StatefulWidget {
  const InfoChildWidget({Key? key}) : super(key: key);

  @override
  State<InfoChildWidget> createState() => _InfoChildWidgetState();
}

class _InfoChildWidgetState extends State<InfoChildWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //父或祖先widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用。
    //如果build中没有依赖InheritedWidget，则此回调不会被调用。
    print("Dependencies change");
  }

  @override
  Widget build(BuildContext context) {
    final int number = InheritedInfoWidget.of(context)!.number;
    return Text('$number');
    // return Text('number');
  }
}
