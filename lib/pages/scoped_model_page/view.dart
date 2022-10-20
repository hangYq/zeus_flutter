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
