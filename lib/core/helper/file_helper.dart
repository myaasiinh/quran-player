import 'dart:io';
import 'dart:math';

import 'package:quran_player/core/helper/app_logger.dart';

import '/core/helper/dialog_helper.dart';
import '/core/helper/permission_helper.dart';
import '/core/helper/snackbar_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// Kelas `FileHelper` merupakan kelas utilitas statis yang digunakan untuk berbagai
/// operasi terkait file, seperti pemilihan file, manipulasi string ukuran file,
/// direktori penyimpanan lokal, hingga pengunduhan dan pembukaan file.
class FileHelper {
  /// Mendapatkan representasi teks (string) yang ramah pembaca untuk ukuran file lokal.
  /// Menerima parameter [path] sebagai alamat file, dan [decimals] untuk jumlah presisi desimal.
  static String getFileSizeString(String path, int decimals) {
    // Mengambil panjang file dalam ukuran bytes secara sinkronus
    final bytes = File(path).lengthSync();
    // Apabila berkas kosong atau 0 byte, kembalikan '0 B'
    if (bytes <= 0) return '0 B';
    // Daftar sufiks dari Byte hingga YottaByte
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    // Hitung tingkat pangkat ukuran basis logaritma (berbasis 1024)
    final i = (log(bytes) / log(1024)).floor();
    // Kembalikan angka format presisi desimal yang dikalikan dengan sufiks satuannya
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  /// Membuka file picker perangkat untuk memungkinkan pengguna memilih berkas lokal.
  /// Menerima parameter opsional [allowedExtensions] untuk menyaring tipe berkas 
  /// dan [allowMultiple] untuk memilih banyak file sekaligus.
  static Future<List<File>?> pickFile({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    // Jika allowedExtensions tidak disediakan, gunakan filter default
    final extensions = allowedExtensions ?? _defaultExtensions;
    // Panggil paket eksternal file_picker
    final result = await FilePicker.pickFiles(
      type: FileType.custom, // Tipe custom untuk memakai ekstensi
      allowedExtensions: extensions,
      allowMultiple: allowMultiple,
    );

    // Pemetaan data dari package Result menjadi list of model File bawaan Dart.IO
    final data = result?.files.map((e) => File(e.path.toString())).toList();

    // Proses pengecekan khusus apabila pengguna telah selesai memilih file
    if (result != null) {
      /// Memverifikasi Esktensi
      /// Hal ini digunakan untuk Handle beberapa perangkat Android tertentu 
      /// yang sistem pemilihnya tidak mematuhi 'allowedExtensions' dengan benar.
      for (var i = 0; i < (result.paths.length); i++) {
        // Flag boolean untuk menandai pencocokan ekstensi
        var isMatches = false;
        for (final allowedExtension in extensions) {
          // Jika jalurnya berakhir dengan ekstensi yang diizinkan
          if (result.paths[i]!.endsWith(allowedExtension)) {
            isMatches = true;
          }
        }
        // Jika file yang dipilih tidak sesuai daftar yang diizinkan
        if (!isMatches) {
          // Buang dari daftar hasil
          data?.removeAt(i);
          // Tampilkan notifikasi error/tolakan melalui snackbar
          SnackBarHelper.error(message: 'Extension not allowed');
        }
      }
    }

    // Mengembalikan list objek File yang sah (atau null jika pengguna membatalkan)
    return data;
  }

  /// Properti privat yang mengembalikan kumpulan string ekstensi standar bawaan.
  static List<String> get _defaultExtensions => [
        'pdf',
        'doc',
        'docx',
        'odt',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
        'csv',
        'psd',
        'txt',
        'zip',
        'rar',
      ];

  /// Membuka file yang telah selesai diunduh dengan aplikasi bawaan/viewer sistem yang sesuai.
  /// Menerima parameter [savePath] sebagai lokasi lokal.
  static Future<void> viewDownloadedFile(String savePath) async {
    try {
      // Buka file menggunakan package OpenFilex
      final result = await OpenFilex.open(savePath);
      // Log respons dari sistem OS ketika coba membuka file
      AppLogger.debug(result.message);
    } catch (e) {
      // Tangkap dan catat pesan error seandainya gagal membuka (misal tak ada aplikasi kompatibel)
      AppLogger.debug('error: $e');
    }
  }

  /// Membuka aplikasi file explorer sistem pada direktori/lokasi folder tertentu.
  /// Menerima parameter [folderPath].
  static Future<void> openDownloadedFolder(String folderPath) async {
    try {
      // Eksekusi buka file/direktori dengan package
      final result = await OpenFilex.open(folderPath);
      AppLogger.debug(result.message);
    } catch (e) {
      AppLogger.debug('error: $e');
    }
  }

  /// Membuka folder yang didownload dengan mempertimbangkan pengaturan perizinan pada sistem.
  static Future<void> openPlatformDownloadedFolder(String folderPath) async {
    // Logika spesifik OS iOS
    if (Platform.isIOS) {
      // Mengonversi string ke dalam URL intent dokumen terbagikan sistem Apple
      final downloadDir = Uri.tryParse('shareddocuments://$folderPath')!;
      // Panggil launcher app eksternal
      await launchUrl(downloadDir);
    } 
    // Logika spesifik OS Android
    else if (Platform.isAndroid) {
      // Mendapatkan spesifikasi SDK perangkat
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      // SDK di atas 29 (Android 10) memiliki model "Scoped Storage" yang lebih ketat
      if (androidInfo.version.sdkInt > 29) {
        // Harus meminta izin kelola penyimpanan luas
        final isGranted = await PermissionHelper.manageExternalStorage();
        // Buka lokasi folder hanya jika sudah diizinkan
        if (isGranted) await FileHelper.openDownloadedFolder(folderPath);
      } else {
        // Langsung buka folder pada OS Android lama
        await FileHelper.openDownloadedFolder(folderPath);
      }
    }
  }

  /// Mengunduh file dari [url] eksternal lalu secara otomatis membukanya setelah selesai.
  static Future<void> downloadAndOpenFile({
    required String url,
    String? fileName,
  }) async {
    // Pisahkan nama file dari segmen URL terakhir jika tidak disediakan secara eksplisit
    final name = fileName ?? url.split('/').last;
    // Mulai proses unduh
    final file = await downloadFilePath(url, name);
    AppLogger.debug('Path : $file');
    // Segera tampilkan (buka) file setelah unduhan beres
    await OpenFilex.open(file);
  }

  /// Proses download menggunakan Dio untuk mengambil data file dari server dan menyimpannya 
  /// di penyimpanan dokumen internal aplikasi (Private Directory).
  static Future<String> downloadFilePath(String url, String fileName) async {
    // Ambil direktori eksklusif aplikasi
    final directory = await getApplicationDocumentsDirectory();
    // Menyusun full path tempat menaruh file yang didownload
    final filePath = '${directory.path}/$fileName';
    try {
      // Gunakan Dio untuk memanggil internet (GET request implicit) dan simpan ke file lokal
      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      // Lempar pengecualian baru jika ada masalah network atau penyimpanan
      throw Exception('Failed download, msg : $e');
    }
  }

  /// Mendapatkan referensi instance Objek [Directory] lokal untuk penulisan/pembuatan berkas.
  /// Memastikan status perizinan sudah diberikan sebelumnya.
  Future<Directory> getDirectory() async {
    Directory? directory;

    // Periksa dulu apakah izin storage telah didapatkan
    final hasGranted = await checkStoragePermission();
    // Apabila ada izin, siapkan struktur foldernya
    if (hasGranted) {
      directory = await _prepareSaveDir();
    }

    // Mengembalikan objek file lokal (bisa Exception jika null, walau terpaksa)
    return directory!;
  }

  /// Memverifikasi dan meminta otorisasi (perizinan/permissions) untuk membaca
  /// dan menulis dokumen/media ke dalam memori eksternal HP.
  Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      // Kompatibilitas untuk OS Android di bawah Android 13 (API < 33)
      if (androidInfo.version.sdkInt < 33) {
        // Minta secara luas perizinan storage tunggal
        final permission = await Permission.storage.request();
        // Kalau ditolak permanen, peringatkan dan buka setting OS
        if (permission.isPermanentlyDenied) {
          LoadingDialog.dismiss();
          PermissionHelper.openSettings('txt_need_permission_storage'.tr);
          return false;
        } 
        // Kalau diterima sementara/permanen
        else if (permission.isGranted) {
          return true;
        } 
        // Ditolak sekali
        else if (permission.isDenied) {
          SnackBarHelper.error(message: 'txt_need_permission_storage'.tr);
          return false;
        }
      } 
      // Kompatibilitas untuk Android 13 ke atas (Granular Permissions)
      else {
        ///
        /// Untuk perangkat bersistem android 13+ (API level 33 ke atas) tidak lagi 
        /// meminta izin tunggal berkas secara luas (READ_EXTERNAL_STORAGE ditiadakan).
        /// Harus secara spesifik memakai izin tipe medianya
        /// Seperti: Permission.photos, Permission.videos, Permission.audio
        ///
        // Minta perizinan foto (sebagai wakil baca tulis media dasar)
        final permission = await Permission.photos.request();
        // Blok kondisi sama seperti sebelumnya
        if (permission.isPermanentlyDenied) {
          LoadingDialog.dismiss();
          PermissionHelper.openSettings('txt_need_permission_storage'.tr);
          return false;
        } else if (permission.isGranted) {
          return true;
        } else if (permission.isDenied) {
          SnackBarHelper.error(message: 'txt_need_permission_storage'.tr);
          return false;
        }
      }
    } 
    // Pada iOS, izin storage default per-aplikasi biasanya langsung menyatu kecuali di luar sandbox
    else if (Platform.isIOS) {
      return true;
    }
    // Kondisi aman lainnya (web/desktop/etc) return false
    return false;
  }

  /// Mempersiapkan direktori penyimpanan, membuatnya jika rute tersebut belum ada 
  /// secara fisik di memori.
  Future<Directory> _prepareSaveDir() async {
    // Ambil alamat string jalur absolut lokal
    final localPath = await _findSavedDir();
    // Definisikan dalam instance Directory
    final savedDir = Directory(localPath);
    // Cek keberadaan sistem foldernya
    final hasExisted = await savedDir.exists();
    if (!hasExisted) {
      // Jika tidak ada, panggil perintah pembuatan folder
      await savedDir.create();
    }

    return savedDir;
  }

  /// Mengambil path/jalur lokal untuk menyimpan hasil unduhan, 
  /// disesuaikan per arsitektur sistem operasi.
  Future<String> _findSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      // Blok kode lama (di-comment) yang mencari direktori spesifik Android bawaan
      // final directory = await getExternalStorageDirectory();
      // externalStorageDirPath = directory?.absolute.path;
      
      // Override default Android: paksakan menggunakan folder "Download" umum sistem
      externalStorageDirPath = '/storage/emulated/0/Download';
    } else if (Platform.isIOS) {
      // Di perangkat Apple, hanya diizinkan di dokumen internal sandbox
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    } else {
      // Melemparkan kesalahan implementasi jika dicoba build pada web atau desktop
      throw UnimplementedError(
        '_findLocalPath untuk platform ini belum dibuat',
      );
    }
    // Cetak log lokasi pengunduhan yang dipilih
    AppLogger.debug('externalStorageDirPath: $externalStorageDirPath');
    // Kembalikan alur lokasi yang tidak akan null berdasarkan if-else per-platform ini
    return externalStorageDirPath;
  }
}
