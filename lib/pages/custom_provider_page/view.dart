import 'package:flutter/material.dart';

import './src/inherited_provider.dart';

class CustomProviderDemoPage extends StatelessWidget {
  const CustomProviderDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CustomProviderDemoPage'),
        centerTitle: true,
      ),
      body: ProviderDemoRoute(),
    );
  }
}
