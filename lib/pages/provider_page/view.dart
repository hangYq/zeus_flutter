import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProviderDemoPage extends StatelessWidget {
  ProviderDemoPage({super.key});
  var _providerViewModel = ProviderViewModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('provider Demo'),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider.value(
          value: _providerViewModel,
          builder: (context, child) {
            return Column(
              children: [
                const Text("我是父节点"),
                Text(
                    "Parent number is: ${Provider.of<ProviderViewModel>(context).number}"),
                ChildA(),
                //ChildB(),
                //ChildC()
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _providerViewModel.addNumber();
          }, //使用context.read不会调用rebuild
        ),
      ),
    );
  }
}

class ChildA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("childA build");
    return Container(
      width: double.infinity,
      color: Colors.amberAccent,
      child: Column(
        children: [
          Text(
              "Child A number: ${Provider.of<ProviderViewModel>(context).number}"),
          MaterialButton(
            child: const Text("Add Number"),
            color: Colors.white,
            onPressed: () {
              Provider.of<ProviderViewModel>(context, listen: false)
                  .addNumber();
            },
          )
        ],
      ),
    );
  }
}

class ProviderViewModel with ChangeNotifier {
  int _number = 0;

  get number => _number;

  void addNumber() {
    _number++;
    notifyListeners();
  }
}
