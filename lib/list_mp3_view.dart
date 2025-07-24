import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_mp3_2/model/mp3_file.dart';
import 'package:youtube_mp3_2/state/color_river.dart';
import 'package:youtube_mp3_2/state/list_mp3.dart';
import 'package:youtube_mp3_2/theme.dart';
import 'package:path/path.dart' as path;

class ListMp3View extends ConsumerWidget {
  const ListMp3View({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(filesProvider);
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final mp3File = Mp3File(fileName: path.basename(file.path), filePath: file.path);
        return _Mp3Item(mp3File: mp3File, file: file,);
      },
    );
  }
}

class _Mp3Item extends ConsumerWidget {
  final Mp3File mp3File;
  final File file;
  const _Mp3Item({required this.mp3File, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      width: mainSize(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ref.watch(colorProvider).withValues(alpha: 0.5),
        border: Border.all(
          color: ref.watch(colorProvider) == ColorTheme.blackColor
              ? ColorTheme.whiteColor
              : ColorTheme.blackColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: mainSize(context).width*0.5,
            child: Text(
              mp3File.fileName,
              style: TextStyle(
                color: ref.watch(colorProvider) == ColorTheme.blackColor
                    ? ColorTheme.whiteColor
                    : ColorTheme.blackColor,
                fontSize: 15,
              ),
              maxLines: 2,
            ),
          ),

          IconButton(
            onPressed: ()=>onDeleteTap(ref, context), 
            icon: Icon(Icons.delete, color: ColorTheme.redColor,)
          )
        ],
      )
    );
  }

  FutureOr<void> onDeleteTap(WidgetRef ref, BuildContext context) async{
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('You want to delete this?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async{
                final deleted = await ref.read(filesProvider.notifier).delete(file);
                if (deleted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
                }
              }, 
              child: Text('Yes')
            )
          ],
        );
      }
    );
  }
}
