import 'package:flutter/material.dart';

class StreamBuilderDemoPage extends StatelessWidget {
  const StreamBuilderDemoPage({Key? key}) : super(key: key);

  Stream<int> createStream() {
    return Stream<int>.periodic(Duration(seconds: 1), (int i) {
      return i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Builder Demo Page'),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: createStream(),
          builder: (BuildContext contet, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasError) {
              return Text('请求出错：${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('没有Stream');
              case ConnectionState.waiting:
                return Text('等待数据...');
              case ConnectionState.active:
                return Text('active: ${snapshot.data}');
              case ConnectionState.done:
                return Text('Stream 已关闭');
            }
          },
        ),
      ),
    );
  }
}
