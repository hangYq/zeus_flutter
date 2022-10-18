import 'package:flutter/material.dart';

class ZeusNavigator {
  static Future<dynamic> open(
    BuildContext context,
    String routeName, {
    bool isReplacement = false,
    Object? arguments,
  }) async {
    if (isReplacement) {
      return Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: arguments ?? <String, dynamic>{},
      );
    }
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments ?? <String, dynamic>{},
    );
  }
}
