import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

const platform = MethodChannel('yt_dlp_channel');

Future<File?> downloadMp3(String url) async {
  try {
    final String path = await platform.invokeMethod('download', {'url': url});
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
  } catch (e) {
    log('Download error: $e');
    return null;
  }
  return null;
}
