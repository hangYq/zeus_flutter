import 'package:flutter/material.dart';

import '../pages/plugin_page/view.dart';
import './constants.dart';
import '../pages/bloc_page/components/bloc_demo_page/bloc_demo_page.dart';
import '../pages/bloc_page/components/future_builder_page/future_builder_page.dart';
import '../pages/bloc_page/components/stream_builder_page/stream_builder_page.dart';
import '../pages/bloc_page/components/stream_controller_page/stream_controller_page.dart';
import '../pages/bloc_page/components/stream_generate_page/stream_generate.dart';
import '../pages/bloc_page/view.dart';
import '../pages/button_page/view.dart';
import '../pages/custom_provider_page/view.dart';
import '../pages/future_page/view.dart';
import '../pages/home_page/view.dart';
import '../pages/inherited_page/view.dart';
import '../pages/provider_page/view.dart';
import '../pages/scoped_model_page/view.dart';

typedef PageBuilder = Widget Function(
  BuildContext context, {
  dynamic arguments,
});

class AppRoutes {
  static Map<String, PageBuilder> routes = <String, PageBuilder>{
    RoutesName.homePage: (BuildContext context, {dynamic arguments}) =>
        HomePage(arguments: arguments),
    RoutesName.futurePage: (BuildContext context, {dynamic arguments}) =>
        FutureDemoPage(arguments: arguments),
    RoutesName.buttonPage: (BuildContext context, {dynamic arguments}) =>
        ButtonDemoPage(),
    RoutesName.scopedModel: (BuildContext context, {dynamic arguments}) =>
        ScopedModelDemoPage(),
    RoutesName.inherited: (BuildContext context, {dynamic arguments}) =>
        InheritedDemoPage(),
    RoutesName.customProvider: (BuildContext context, {dynamic arguments}) =>
        CustomProviderDemoPage(),
    RoutesName.providerPage: (BuildContext context, {dynamic arguments}) =>
        ProviderDemoPage(),
    RoutesName.blocPage: (BuildContext context, {dynamic arguments}) =>
        BlocPage(),
    RoutesName.blocDemoPage: (BuildContext context, {dynamic arguments}) =>
        BlocDemoPage(),
    RoutesName.streamControllerDemoPage: (
      BuildContext context, {
      dynamic arguments,
    }) =>
        StreamControllerDemoPage(),
    RoutesName.streamGenerateDemoPage:
        (BuildContext context, {dynamic arguments}) => StreamGenerateDemoPage(),
    RoutesName.futureBuilderDemoPage:
        (BuildContext context, {dynamic arguments}) => FutureBuilderDemoPage(),
    RoutesName.streamBuilderDemoPage:
        (BuildContext context, {dynamic arguments}) => StreamBuilderDemoPage(),
    RoutesName.pluginDemoPage: (BuildContext context, {dynamic arguments}) =>
        PluginDemoPage(),
  };
}
