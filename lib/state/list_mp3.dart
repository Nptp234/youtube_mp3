import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_mp3_2/download_mp3.dart';

class ListMp3Provider extends StateNotifier<List<File>>{
  ListMp3Provider() : super([]);

  Future<void> addFromDownload(String url) async {
    final file = await downloadMp3(url);
    if (file != null && file.existsSync()) {
      state = [...state, file];
    }
  }

  Future<void> loadAll() async {
    final dir = Directory('/storage/emulated/0/Music/yt_mp3');
    if (await dir.exists()) {
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.mp3'))
          .toList();
      state = files;
    }
  }

  Future<bool> delete(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        state = state.where((f) => f.path != file.path).toList();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

}

final filesProvider = StateNotifierProvider<ListMp3Provider, List<File>>(
  (ref){
    return ListMp3Provider()..loadAll();
  }
);