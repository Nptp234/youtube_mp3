# 🎵 YouTube MP3 Downloader App

A simple yet powerful mobile application that allows users to download MP3 files from YouTube links directly to their Android device.

## 🛠️ Technologies Used

- **Flutter**: Frontend framework for building the UI
- **Riverpod**: For clear and scalable state management
- **Chaquopy**: Integrates Python into Android (used to run `yt-dlp`)
- **Java**: Android native code integration
- **Python**: Executes `yt-dlp` for downloading audio
- **Android File System**: For managing downloaded files

## 🚀 Features

- 🔗 **Paste YouTube URL** → Automatically download MP3 using `yt-dlp` (via Python)
- 📁 **Save MP3** to device storage: `/storage/emulated/0/Music/yt_mp3`
- 💡 **Clean UI** with clear loading and error handling
- 🔁 **State Management** with Riverpod
- 📞 **Flutter ↔ Native Integration** using `MethodChannel` to call Java and Python code

## 🎯 Purpose & Architecture

This project demonstrates:

- Thoughtful app **architecture and native API communication**
- **Hybrid integration** of Python, Java, and Flutter
- Real-world usage of **state management** and asynchronous operations in mobile development

---

Feel free to clone and explore this project to understand how Flutter can be extended with native Android and Python functionality!
