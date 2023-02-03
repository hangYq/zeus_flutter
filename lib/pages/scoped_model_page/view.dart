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
      body: ScopedModel<CounterModel>(
        model: CounterModel(),
        child: ScopedModelDescendant<CounterModel>(
          builder: (BuildContext context, Widget? child, CounterModel model) =>
              Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${model.counter}'),
                OutlinedButton(
                  // onPressed: ScopedModel.of<CounterModel>(context).increment,
                  onPressed: model.increment,
                  child: Text('add'),
                ),
              ],
            ),
          ),
        ),

        // 不使用 ScopedModelDescendant 的用法
        // child: Builder(
        //   builder: (BuildContext context) {
        //     return Center(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Text('${CounterModel.of(context).counter}'),
        //           OutlinedButton(
        //             onPressed: CounterModel.of(context).increment,
        //             child: Text('add1'),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        // child: NewWidget(),
      ),
    );
  }
}

// class NewWidget extends StatelessWidget {
//   const NewWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text('${CounterModel.of(context).counter}'),
//           OutlinedButton(
//             onPressed: CounterModel.of(context).increment,
//             // onPressed: model.increment,
//             child: Text('add'),
//           ),
//         ],
//       ),
//     );
//   }
// }
