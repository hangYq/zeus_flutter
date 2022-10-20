import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CounterModel extends Model {
  int _counter = 0;

  int get counter => _counter;

  static CounterModel of(BuildContext context) =>
      ScopedModel.of<CounterModel>(context, rebuildOnChange: true);

  void increment() {
    _counter++;
    notifyListeners();
  }
}
