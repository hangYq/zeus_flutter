import 'dart:collection';

import 'package:flutter/material.dart';

/// [跨组件状态共享](https://book.flutterchina.club/chapter7/provider.html#_7-3-1-%E9%80%9A%E8%BF%87%E4%BA%8B%E4%BB%B6%E5%90%8C%E6%AD%A5%E7%8A%B6%E6%80%81)
/// 通用的 InheritedWidget, 用来保存需要跨组件共享的数据状态
class InheritedProvider<T> extends InheritedWidget {
  InheritedProvider({
    required Widget child,
    required this.data,
    Key? key,
  }) : super(key: key, child: child);

  // final Widget child;
  final T data;

  @override
  bool updateShouldNotify(InheritedProvider<T> oldWidget) {
    //  返回 true，每次更新都会调用依赖其的子孙节点的 `didChangeDependencies`.
    return true;
  }
}

/// 问题1：数据发生变化怎么通知？
/// 问题2：谁来重新构建 InheritedProvier?
///
/// 我们要将共享的状态放到一个 model 类中，然后让它继承自 [ChangeNotifier] ，这样当共享的状态
/// 改变时，我们只需要调用 notifyListeners() 来通知订阅者，然后由订阅者来重新构建 InheritedProvider
///
class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  const ChangeNotifierProvider({
    required this.child,
    required this.data,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final T data;

  /// 定义一个便捷方法，方便对子树中的 Widget 获取共享数据
  /// 子Widget可以通过Inherited widgets提供的静态of方法拿到离他最近的父Inherited widgets实例
  static T of<T>(BuildContext context, {bool listen = true}) {
    final InheritedProvider<T>? provider = listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>()
        : context
            .getElementForInheritedWidgetOfExactType<InheritedProvider<T>>()
            ?.widget as InheritedProvider<T>;
    return provider!.data;
  }

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    /// 如果数据发生变化，model 类调用了notifyListeners ,重新构建 InheritProvider
    setState(() {});
  }

  @override
  void initState() {
    // 给 model 添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    // 当 provider 更新是，如果新旧数据不相等，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

class Item {
  Item({
    required this.price,
    required this.count,
  });

  double price;
  int count;
}

class CartModel extends ChangeNotifier {
  final List<Item> _items = <Item>[];

  // 禁止改变购物车里的商品信息
  UnmodifiableListView<Item> get items => UnmodifiableListView<Item>(_items);

  double get totalPrice => _items.fold(
        0,
        (double previousValue, Item item) =>
            previousValue + item.price * item.count,
      );

  void add(Item item) {
    _items.add(item);
    // 通知监听器（订阅者），重新构建 InheritedProvider，更新状态
    notifyListeners();
  }
}

class ProviderDemoRoute extends StatefulWidget {
  const ProviderDemoRoute({Key? key}) : super(key: key);

  @override
  State<ProviderDemoRoute> createState() => _ProviderDemoRouteState();
}

class _ProviderDemoRouteState extends State<ProviderDemoRoute> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartModel>(
      data: CartModel(),
      child: Center(
        child: Column(
          children: <Widget>[
            Consumer<CartModel>(
              builder: (BuildContext context, CartModel? model) {
                return Text(
                  '总价：${model!.totalPrice}',
                );
              },
            ),
            Builder(
              builder: (BuildContext context) {
                print('ElevatedButton build'); // 构建时输出日志
                return ElevatedButton(
                  child: Text('添加商品'),
                  onPressed: () {
                    ChangeNotifierProvider.of<CartModel>(context, listen: false)
                        .add(
                      Item(
                        price: 10,
                        count: 10,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        // child: Builder(
        //   builder: (BuildContext innerContext) {
        //     return Column(
        //       children: [
        //         Builder(
        //           builder: (_) {
        //             CartModel cart =
        //                 ChangeNotifierProvider.of<CartModel>(innerContext);
        //             return Text(
        //               '总价：${cart.totalPrice}',
        //             );
        //           },
        //         ),
        //         Builder(builder: (innerContext) {
        //           return OutlinedButton(
        //             onPressed: () {
        //               CartModel cart =
        //                   ChangeNotifierProvider.of<CartModel>(innerContext);
        //               cart.add(
        //                 Item(
        //                   price: 10,
        //                   count: 10,
        //                 ),
        //               );
        //             },
        //             child: Text('添加商品'),
        //           );
        //         })
        //       ],
        //     );
        //   },
        // ),
      ),
    );
  }
}

// 这是一个便捷类，会获得当前context和指定数据类型的Provider
class Consumer<T> extends StatelessWidget {
  Consumer({
    required this.builder,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext context, T? value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      ChangeNotifierProvider.of<T>(context),
    );
  }
}
