---
theme: cyanosis
---

本文主要从 scoped_model 的简单使用说起，然后再深入源码进行剖析（InheritedWidget、Listenable、AnimatedBuilder），不会探讨 Flutter 状态管理的优劣，单纯为了学习作者的设计思想。

- - -

### 一、什么是 scoped_model

scoped_model 是一个第三方 Dart 库，可以让您轻松的将数据模型从父 Widget 传递到子 Widget。此外，它还会在模型更新时重新构建所有使用该模型的子 Widget。

它直接来自于 Google 正在开发的新系统 Fuchsia 核心 Widgets 中对 Model 类的简单提取，作为独立使用的独立 Flutter 插件发布。

- - -

### 二、用法

```dart
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
```

从上面的代码可以看出 scoped_model 的使用非常简单，只需要以下三步：

1. 定义 `Model` 的实现，如 CounterModel，这里需要注意的是 CounterModel 一定要继承自   `Model`（为什么一定要继承 Model 我们后面细说）并且在状态改变的时候执行 notifyListeners。
2. 使用 `ScopedModel` Widget 包裹需要用到 `Model` 的 Widget。
3. 使用 `ScopedModelDescendant` 或者 `ScopedModel.of<CounterModel>(context)` 来进行获取数据。

- - - 

### 三、实现原理
    
在 scoped_model 中的整个实现中，它很巧妙的借助了 AnimatedBuilder、Listenable、InheritedWidget 等 Flutter 的基础特性。

scoped_model 使用了观察者模式，将数据放在父 Widget，子 Widget 通过找到父 Widget 的 model 进行数据渲染，最后改变数据的时候再将数据传回，父 Widget 再通知所有用到了该 model 的子 Widget 去更新状态。
    
我们首先从 `ScopedModel` 入手，通过源码我们不难发现，ScopedModel 是一个 `StatelessWidget` 最后返回一个 `AnimatedBuilder`，在 `AnimatedBuilder` 中在通过 builder 返回 `_InheritedModel`。


![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e299eb04fdcf4015850d584d91dd6ebf~tplv-k3u1fbpfcp-watermark.image?)

我们再从 `Model` 入手，可以看出 `Model` 是一个 继承自 `Listenable` 的抽象类，主要有一个 _listeners 变量用 Set 来进行存储，复写了 `addListener`、`removeListener`、`notifyListeners` 方法。在这里不知道大家有没有想过 `Model` 为什么要继承 `Listenable`？ 在这里先卖个关子，在后面会详细讲解。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c70b2b3f7c5a495c9ec1f6f002fcf153~tplv-k3u1fbpfcp-watermark.image?)

如果只是单单看 `ScopedModel` 和 `Model` 好像也看不出来什么巧妙之处，但是如果把 `ScopedModel` 中返回的 `AnimatedBuilder` 和 `Model` 所继承的 `Listenable` 结合起来进行思考就会发现，`AnimatedBuilder` 继承自 `AnimatedWidget`，在 `AnimatedWidget` 的生命周期中会对 `Listenable` 添加监听，而 `Model` 正好就实现了 `Listenable` 接口。

`Model` 实现了 `Listenable` 接口，内部刚好有一个 `Set<VoidCallback> _listeners` 用来保存接收者。当 `Model` 赋值给 `AnimatedBuilder` 中的 animation 时，`Listenable` 的 addListener 就会被调用，然后添加一个 `_handleChange` 方法，`_handleChange` 内部只有一行代码 `setState((){})`，当调用 `notifyListeners` 时，会从创建一个 Microtask，去执行一遍 `_listeners` 中的 `_handleChange` ，当 `_handleChange` 被调用时就会进行更新 UI 界面。其实这里也就解释了 `Model` 为什么要继承 `Listenable`。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c75e94f2d88541d58375c38e3f3808fd~tplv-k3u1fbpfcp-watermark.image?)

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/36dafae4808a48a49eef9dc3e3656e66~tplv-k3u1fbpfcp-watermark.image?)

不知道大家发现没有，讲了这么多，还没有讲到 `ScopedModelDescendant` 到底是干什么的？那我就不得不先说起 `InheritedWidget` 了。

`InheritedWidget` 是 Flutter 中非常重要的一个功能型组件，它提供了一种在 Widget 树中从上到下共享数据的方式，比如我们在应用的根 Widget 中通过 `InheritedWidget` 共享了一个数据，那么我们便可以在任意子 Widget 中来获取该共享的数据。它主要有以下两个作用：

1. 子 Widget 可以通过 `Inherited` Widgets 提供的静态 of 方法拿到离他最近的父`Inherited` widgets 实例。
2. 当 `Inherited` Widgets 改变 state 之后，会自动触发 state 消费者的 rebuild 行为。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9d0b4e23aa7b4af093b7fe7edf560804~tplv-k3u1fbpfcp-watermark.image?)

在 `scoped_model` 中我们可以通过 `ScopedModel.of<CountModel>(context)` 来获取 我们的 model，最主要的就是在 `ScopedModel` 中返回了 `AnimatedBuilder`，而 `AnimatedBuilder` 中 builder 又返回了 `_InheritedModel`， `_InheritedModel` 又继承了 `InheritedWidget`。

言归正传，我们一起回到 `ScopedModelDescendant` 的主题，不知道大家有没有尝试过，不用 `ScopedModelDescendant` 来获取 model 会发生什么样的情况？通过窥探源码我们发现有 `ScopedModelError` 这样一个异常类，说的已经很明确了，必须要提供 `ScopedModelDescendant`。what ？其实它主要做了以下 2 件事情：

1. 隐式调用 `ScopedModel.of<T>(context)` 来获取 model。
2. 明确语义化，不然我们每次都需要用 `Builder` 来进行构建，不然将获取不到 model，还会抛出异常。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/edf87c69792e400f8184aba0a4b8a921~tplv-k3u1fbpfcp-watermark.image?)

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/db0ceff2a1064cd9ba7cfce080f33a0c~tplv-k3u1fbpfcp-watermark.image?)

```dart
// 不使用 ScopedModelDescendant 使用 Builder 的用法
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
        child: Builder(
          builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${CounterModel.of(context).counter}'),
                OutlinedButton(
                  onPressed: CounterModel.of(context).increment,
                  child: Text('add1'),
                ),
              ],
            );
          },
        ),
        // child: ScopedModelDescendant<CounterModel>(
        //   builder: (context, child, model) => Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text('${model.counter}'),
        //         OutlinedButton(
        //           onPressed: ScopedModel.of<CounterModel>(context).increment,
        //           // onPressed: model.increment,
        //           child: Text('add'),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
```

除了上面这种使用 Builder 的方式，当然我们还可以使用下面的方法，把它单独提取出一个 Widget，代码如下：

```dart
// 单独提取 Widget 的方式
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
        child: NewWidget(),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${CounterModel.of(context).counter}'),
          OutlinedButton(
            onPressed: CounterModel.of(context).increment,
            // onPressed: model.increment,
            child: Text('add'),
          ),
        ],
      ),
    );
  }
}

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

```
是不是很意外？主要起作用的是下面这一段代码：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a3f660eef48f418e867890151f0cdb37~tplv-k3u1fbpfcp-watermark.image?)

单独提取出来 Widget，可以获取到正确的 context，从而可以获取到离他最近的父 `Inherited` widgets 实例。
- - -

### 四、结束

以上就是我对 scoped_model 的使用以及部分源码的解读，如果有不足之处，还请指教。 最后，大家也可以思考一下，我们是如何通过 `context` 就能获取到共享的 Model 呢？
