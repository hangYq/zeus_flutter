import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import 'dart:io';

class CommonResult {
  CommonResult({
    required this.code,
    required this.message,
    this.data,
  });

  final int code;
  final String message;
  final dynamic data;

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data,
      };
}

void saveToFile() {
  try {
    final CommonResult result = CommonResult(
        code: 200, message: 'this is success message', data: 'data');
    String filePath = path.join(Directory.current.path, 'out.json');
    File file = File(filePath);
    String content = json.encode(result);
    Future<File> futureFile = file.writeAsString(content);
    futureFile
        .then((File file) {
          if (kDebugMode) {
            print('success');
          }
        })
        .catchError((dynamic error) {})
        .whenComplete(() => null);
  } catch (e) {
    print(e);
  } finally {
    print('success');
  }
}
