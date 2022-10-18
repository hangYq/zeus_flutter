import 'package:flutter/material.dart';

class ButtonDemoPage extends StatelessWidget {
  const ButtonDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Demo Page'),
      ),
      body: Column(
        children: [
          BackButton(),
          ElevatedButton(
              onPressed: null,
              child: const Text(
                'ElevatedButton',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              )),
          OutlinedButton(
            onPressed: () {},
            child: const Text(
              'OutlinedButton',
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'TextButton',
            ),
          ),
        ],
      ),
    );
  }
}