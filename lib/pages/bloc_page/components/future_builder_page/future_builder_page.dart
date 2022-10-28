import 'package:flutter/material.dart';

class FutureBuilderDemoPage extends StatelessWidget {
  const FutureBuilderDemoPage({Key? key}) : super(key: key);

  Future<String> fetchData() async {
    return Future<String>.delayed(Duration(seconds: 3), () => 'mock 数据成功');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Builder Demo Page'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchData(),
          builder: (
            BuildContext context,
            AsyncSnapshot<String> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('请求出错：${snapshot.error}');
              }
              return Text('请求成功:${snapshot.data}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
