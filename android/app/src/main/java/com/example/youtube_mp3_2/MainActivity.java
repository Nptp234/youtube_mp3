package com.example.youtube_mp3_2;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;

import com.chaquo.python.PyObject;
import com.chaquo.python.Python;
import com.chaquo.python.android.AndroidPlatform;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import com.arthenica.ffmpegkit.FFmpegKit;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "yt_dlp_channel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Copy cookies.txt from assets to internal storage
        // copyAssetToInternalStorage("cookies.txt", "cookies.txt");

        // Initialize Chaquopy
        if (!Python.isStarted()) {
            Python.start(new AndroidPlatform(this));
        }

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("download")) {
                    String url = call.argument("url");
                    downloadWithYtDlp(url, result);
                } else {
                    result.notImplemented();
                }
            });
    }

    private void downloadWithYtDlp(String url, MethodChannel.Result result) {
        new Thread(() -> {
            try {
                Python py = Python.getInstance();
                PyObject pyModule = py.getModule("yt_downloader");
                PyObject pathResult = pyModule.callAttr("download_mp3", url);
                String webmPath = pathResult.toString();

                String mp3Path = webmPath.replace(".webm", ".mp3");
                String command = String.format("-y -i \"%s\" -vn -acodec libmp3lame -q:a 5 \"%s\"", webmPath, mp3Path);

                Log.d("FFmpeg", "Running: " + command);

                FFmpegKit.executeAsync(command, session -> {
                    Log.d("FFmpeg", "Finished: " + session.getState().toString());

                    if (session.getReturnCode().isValueSuccess()) {
                        File webmFile = new File(webmPath);
                        if (webmFile.exists()) {
                            boolean deleted = webmFile.delete();
                            Log.d("FFmpeg", "Deleted webm: " + deleted);
                        }
                        result.success(mp3Path);  // 👈 Trả path file về Flutter
                    } else {
                        result.error("FFMPEG_FAILED", "FFmpeg execution failed", null);
                    }
                });

            } catch (Exception e) {
                Log.e("YTDLP", "Python error", e);
                result.error("PYTHON_ERROR", e.getMessage(), null);
            }
        }).start();
    }

    // private void copyAssetToInternalStorage(String assetFileName, String outputFileName) {
    //     File outputFile = new File(getFilesDir(), outputFileName);
    //     if (outputFile.exists()) return;

    //     try (InputStream inputStream = getAssets().open(assetFileName);
    //          OutputStream outputStream = new FileOutputStream(outputFile)) {

    //         byte[] buffer = new byte[1024];
    //         int length;
    //         while ((length = inputStream.read(buffer)) > 0) {
    //             outputStream.write(buffer, 0, length);
    //         }
    //     } catch (IOException e) {
    //         Log.e("COPY_ASSET", "Failed to copy asset file: " + assetFileName, e);
    //     }
    // }


}
