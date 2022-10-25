import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './models/counter_model.dart';

class ScopedModelDemoPage extends StatelessWidget {
  const ScopedModelDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('scopedModel'),
        centerTitle: true,
      ),
      body: ScopedModel(
        model: CounterModel(),
        // 不使用 ScopedModelDescendant 的用法
        // child: Builder(
        //   builder: (context) {
        //     return Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text('${CounterModel.of(context).counter}'),
        //         OutlinedButton(
        //           onPressed: CounterModel.of(context).increment,
        //           child: Text('add1'),
        //         ),
        //       ],
        //     );
        //   },
        // ),
        child: ScopedModelDescendant<CounterModel>(
          builder: (context, child, model) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${model.counter}'),
                OutlinedButton(
                  onPressed: ScopedModel.of<CounterModel>(context).increment,
                  // onPressed: model.increment,
                  child: Text('add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
