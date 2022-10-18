import 'package:flutter/material.dart';

import '../../routes/routes.dart';
import '../../routes/constants.dart';
import '../../utils/navigator.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    this.arguments,
  }) : super(key: key);

  final dynamic arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrance page '),
        centerTitle: true,
      ),
      body: ListView(
        children: AppRoutes.routes.keys
            .map(
              (String item) => TextButton(
                onPressed: () {
                  if (item == RoutesName.homePage) {
                    return;
                  }
                  ZeusNavigator.open(
                    context,
                    item,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                ),
                child: Text(item),
              ),
            )
            .toList(),
      ),
    );
  }
}
