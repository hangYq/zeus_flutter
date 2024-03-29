import 'package:flutter/material.dart';

import '../../routes/constants.dart';
import '../../utils/navigator.dart';

class BlocPage extends StatelessWidget {
  const BlocPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bloc demo page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                ZeusNavigator.open(
                  context,
                  RoutesName.streamControllerDemoPage,
                );
              },
              child: Text('Navigate To Stream Controller Demo Page'),
            ),
            OutlinedButton(
              onPressed: () {
                ZeusNavigator.open(
                  context,
                  RoutesName.streamGenerateDemoPage,
                );
              },
              child: Text('Navigate To Stream Generate Demo Page'),
            ),
            OutlinedButton(
              onPressed: () {
                ZeusNavigator.open(
                  context,
                  RoutesName.futureBuilderDemoPage,
                );
              },
              child: Text('Navigate To Future Builder Demo Page'),
            ),
            OutlinedButton(
              onPressed: () {
                ZeusNavigator.open(
                  context,
                  RoutesName.streamBuilderDemoPage,
                );
              },
              child: Text('Navigate To Stream Builder Demo Page'),
            ),
          ],
        ),
      ),
    );
  }
}
