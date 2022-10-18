import 'package:flutter/material.dart';
import 'package:zeus/pages/future_page/view.dart';

import '../pages/button_page/view.dart';
import '../pages/home_page/view.dart';
import './constants.dart';

typedef PageBuilder = Widget Function(
  BuildContext context, {
  dynamic arguments,
});

class AppRoutes {
  static Map<String, PageBuilder> routes = <String, PageBuilder>{
    RoutesName.homePage: (context, {arguments}) =>
        HomePage(arguments: arguments),
    RoutesName.futurePage: (context, {arguments}) =>
        FutureDemoPage(arguments: arguments),
    RoutesName.buttonPage: (context, {arguments}) => ButtonDemoPage(),
  };
}
