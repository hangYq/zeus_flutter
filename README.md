# zeus

## Flutter 异步编程

### Isolate

- Isolate 相当于 Dart 语言种的 Thread，是 Dart/Flutter 的执行上下文；
- Isolate 有自己独立的内存地址和 Event Loop，不存在共享内存，所以不会出现死锁，但是比 Thread 更耗内存；


