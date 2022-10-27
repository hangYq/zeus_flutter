import 'package:flutter/material.dart';

import '../pages/bloc_page/components/bloc_demo_page/bloc_demo_page.dart';
import '../pages/bloc_page/components/future_builder_page/future_builder_page.dart';
import '../pages/bloc_page/components/stream_builder_page/stream_builder_page.dart';
import '../pages/future_page/view.dart';
import '../pages/bloc_page/components/stream_controller_page/stream_controller_page.dart';
import '../pages/bloc_page/components/stream_generate_page/stream_generate.dart';
import '../pages/bloc_page/view.dart';
import '../pages/button_page/view.dart';
import '../pages/custom_provider_page/view.dart';
import '../pages/home_page/view.dart';
import '../pages/inherited_page/view.dart';
import '../pages/provider_page/view.dart';
import '../pages/scoped_model_page/view.dart';
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
    RoutesName.scopedModel: (context, {arguments}) => ScopedModelDemoPage(),
    RoutesName.inherited: (context, {arguments}) => InheritedDemoPage(),
    RoutesName.customProvider: (context, {arguments}) =>
        CustomProviderDemoPage(),
    RoutesName.providerPage: (context, {arguments}) => ProviderDemoPage(),
    RoutesName.blocPage: (context, {arguments}) => BlocPage(),
    RoutesName.blocDemoPage: (context, {arguments}) => BlocDemoPage(),
    RoutesName.streamControllerDemoPage: (context, {arguments}) =>
        StreamControllerDemoPage(),
    RoutesName.streamGenerateDemoPage: (context, {arguments}) =>
        StreamGenerateDemoPage(),
    RoutesName.futureBuilderDemoPage: (context, {arguments}) =>
        FutureBuilderDemoPage(),
    RoutesName.streamBuilderDemoPage: (context, {arguments}) =>
        StreamBuilderDemoPage(),
  };
}
