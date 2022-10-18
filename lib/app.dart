import 'package:flutter/material.dart';

import './pages/home_page/view.dart';
import './routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Zeus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            final String? name = settings.name;
            final PageBuilder pageContentBuilder = AppRoutes.routes[name]!;
            if (settings.arguments != null) {
              return pageContentBuilder(
                context,
                arguments: settings.arguments,
              );
            }
            return pageContentBuilder(context);
          },
        );
      },
    );
  }
}
