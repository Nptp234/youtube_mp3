import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_mp3_2/list_mp3_view.dart';
import 'package:youtube_mp3_2/state/color_river.dart';
import 'package:youtube_mp3_2/state/is_waiting.dart';
import 'package:youtube_mp3_2/state/list_mp3.dart';
import 'package:youtube_mp3_2/theme.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainView();
}

class _MainView extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body(context));
  }

  Widget body(BuildContext context) {
    return Container(
      width: mainSize(context).width,
      height: mainSize(context).height,
      color: ref.watch(colorProvider),
      child: SafeArea(
        child: Stack(
          children: [
            // Main view
            Container(
              width: mainSize(context).width,
              height: mainSize(context).height,
              decoration: BoxDecoration(color: ref.watch(colorProvider)),
            ),

            // List file
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: mainSize(context).width,
                height: mainSize(context).height,
                padding: EdgeInsets.all(10),
                child: ListMp3View(),
              ),
            ),

            // Add button
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                onPressed: ref.watch(waitingProvider)
                    ? null
                    : () {
                        onBtnClick(context);
                      },
                icon: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: ColorTheme.blueColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ref.watch(waitingProvider)
                      ? CircularProgressIndicator(color: ColorTheme.whiteColor)
                      : Icon(Icons.add, color: ColorTheme.whiteColor, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onBtnClick(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final isWaiting = ref.watch(waitingProvider);

            return AlertDialog(
              title: Text('Enter YouTube URL'),
              content: TextField(
                controller: urlController,
                decoration: InputDecoration(
                  hintText: 'https://youtube.com/...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isWaiting ? null : () => Navigator.of(ctx).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isWaiting
                      ? null
                      : () async {
                          final url = urlController.text.trim();
                          if (url.isNotEmpty) {
                            ref.read(waitingProvider.notifier).change(true);
                            await ref
                                .read(filesProvider.notifier)
                                .addFromDownload(url);
                            ref.read(waitingProvider.notifier).change(false);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          } else {
                            ref.read(waitingProvider.notifier).change(false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('URL cannot be empty'),
                                backgroundColor: ColorTheme.redColor,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                  child: isWaiting
                      ? CircularProgressIndicator(color: ColorTheme.whiteColor)
                      : Text('OK'),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
        );
      },
    );
  }
}
