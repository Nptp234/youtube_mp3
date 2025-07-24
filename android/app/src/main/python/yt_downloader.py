import yt_dlp
import os
import traceback

# def get_cookie_path():
#     # Đường dẫn nội bộ
#     base_path = str(os.environ.get("HOME"))  # Tương đương /data/user/0/<your.package.name>/
#     return os.path.join(base_path, "cookies.txt")

def download_mp3(url):
    try:
        out_dir = os.path.join(os.environ.get("ANDROID_PRIVATE", "/storage/emulated/0/Music"), "yt_mp3")
        os.makedirs(out_dir, exist_ok=True)

        ydl_opts = {
            "format": "bestaudio[ext=webm]/bestaudio/best",
            'outtmpl': os.path.join(out_dir, '%(title)s.%(ext)s'),
            'noplaylist': True,
            'quiet': True,
            'nocheckcertificate': True,
            'http_headers': {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36'
            },
            'postprocessors': [],
            # 'cookiefile': get_cookie_path(),
        }

        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info_dict2 = ydl.extract_info(url, download=False)
            for f in info_dict2.get('formats', []):
                print(f"{f['format_id']}: {f['ext']} - {f.get('acodec')} - {f.get('vcodec')}")
            info_dict = ydl.extract_info(url, download=True)
            filename = ydl.prepare_filename(info_dict)

            if filename and os.path.exists(filename):
                return filename
            else:
                return f"[ERROR] File not found or not created: {filename}"

    except Exception as e:
        return f"[EXCEPTION] {str(e)}\n{traceback.format_exc()}"
