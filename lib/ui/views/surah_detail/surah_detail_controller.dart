import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player/config/base/base_controller.dart';
import 'package:quran_player/data/models/quran/ayah_model.dart';
import 'package:quran_player/data/models/quran/surah_model.dart';
import 'package:quran_player/data/repositories/quran/quran_repository.dart';

/// Kelas [SurahDetailController] mengelola seluruh logika untuk halaman detail surah,
/// termasuk pemutaran audio per ayat (Ayah-by-Ayah) secara sekuensial.
/// Kelas ini mewarisi [BaseController] yang diikat dengan model [AyahModel].
class SurahDetailController extends BaseController<AyahModel> {
  /// Konstruktor utama untuk [SurahDetailController].
  /// Mendukung Dependency Injection yang memungkinkan injeksi mock player selama unit testing.
  SurahDetailController({
    required this.repository,
    AudioPlayer? player,
  }) : player = player ?? AudioPlayer(); // Inisialisasi AudioPlayer default jika tidak ada mock yang diinjeksi.

  /// Instance dari [QuranRepository] yang digunakan untuk mengambil data surah dan ayat.
  final QuranRepository repository;
  
  /// Instance dari [AudioPlayer] yang digunakan untuk mengelola pemutaran audio.
  final AudioPlayer player;

  /// [ScrollController] yang khusus untuk menangani pergerakan list ayat secara otomatis
  /// saat audio berpindah ke ayat selanjutnya.
  final ScrollController scrollController = ScrollController();

  /// State reaktif [Rxn] yang menyimpan data surah dari argumen navigasi halaman sebelumnya.
  final Rxn<SurahModel> surah = Rxn<SurahModel>();

  /// State reaktif [RxBool] untuk memantau status pemutaran audio (sedang play atau pause).
  final RxBool isPlaying = false.obs;

  /// State reaktif [RxInt] untuk melacak indeks ayat mana yang saat ini sedang diputar.
  final RxInt currentAyahIndex = 0.obs;

  /// Metode siklus hidup GetX yang dipanggil pertama kali saat controller diinisialisasi.
  @override
  void onInit() {
    // Mengambil data model surah dari argumen yang dikirim via GetX navigation.
    surah.value = Get.arguments as SurahModel?;

    // Principal Note: Listener 'ever' dari GetX memantau setiap perubahan nilai pada 'currentAyahIndex'.
    // Jika indeks ayat yang diputar berubah (misal lanjut ke ayat berikutnya), sistem akan trigger fungsi '_scrollToCurrentAyah'.
    ever(currentAyahIndex, (_) => _scrollToCurrentAyah());

    // Memanggil inisialisasi dari superclass (BaseController).
    super.onInit();
  }

  /// Metode siklus hidup GetX yang dipanggil tepat setelah frame UI pertama dirender.
  @override
  void onReady() {
    // Memulai proses pengambilan daftar detail ayat dari server sesaat setelah view ditampilkan.
    // Menggunakan unawaited untuk mencegah blocking thread utama karena kita tidak perlu menunggu hasilnya di blok ini.
    unawaited(getSurahDetail());
    
    // Memanggil onReady dari superclass.
    super.onReady();
  }

  /// Metode asinkron [getSurahDetail] mengambil daftar ayat lengkap beserta URL audio dari repository.
  Future<void> getSurahDetail() async {
    // Jika data surah kosong (null), hentikan eksekusi fungsi ini.
    if (surah.value == null) return;
    
    // Menjalankan operasi pemuatan data menggunakan wrapper loadData dari BaseController.
    await loadData(() async {
      // Memanggil fungsi API untuk mengambil detail surah dari repository.
      final res = await repository.getSurahDetail(
        // Mengirimkan nomor surah yang aktif.
        surahNumber: surah.value!.number!,
        // Menetapkan qari/reciter yang digunakan. Default menggunakan Mishary Alafasy.
        edition: 'ar.alafasy', 
      );
      
      // Menyimpan hasil (res) ke dalam state data list bawaan BaseController.
      loadFinish(list: res);

      // Setelah data ayat dan URL audio siap, segera siapkan playlist di audio player.
      unawaited(_setupPlaylist());
    });
  }

  /// Metode asinkron (private) untuk mengatur antrean pemutaran (playlist) pada [AudioPlayer].
  Future<void> _setupPlaylist() async {
    // Memastikan daftar ayat (dataList) tidak kosong sebelum memproses audio.
    if (dataList.isEmpty) return;

    // Membuat objek ConcatenatingAudioSource yang berfungsi menyusun banyak track audio (ayat) dalam satu playlist.
    final playlist = ConcatenatingAudioSource(
      // Melakukan pemetaan/mapping dari list model ayat menjadi daftar AudioSource berdasarkan URL audio.
      children: dataList
          .map((ayah) => AudioSource.uri(Uri.parse(ayah.audio!)))
          .toList(),
    );

    // Memuat objek playlist secara utuh ke dalam player audio secara asinkron.
    await player.setAudioSource(playlist);

    // Mendaftarkan pendengar (listener) pada stream status pemutaran audio.
    // Tujuannya agar ikon Play/Pause pada UI terupdate otomatis sesuai state player (playing/paused).
    player.playerStateStream.listen((state) {
      // Memperbarui nilai state reaktif.
      isPlaying.value = state.playing;
    });

    // Mendaftarkan pendengar (listener) pada stream indeks antrean audio yang saat ini sedang berjalan.
    // Principal Note: Pemantauan ini krusial untuk fitur 'highlight ayat yang dibaca'.
    player.currentIndexStream.listen((index) {
      // Memeriksa bahwa index tidak null.
      if (index != null) {
        // Mengubah nilai indeks ayat yang dipantau.
        currentAyahIndex.value = index;
        // Memanggil refresh() agar GetX mendeteksi perubahan nilai obxable secara real-time
        // sehingga memaksa widget Obx/GetX di UI untuk rebuild tampilan highlight pada item spesifik.
        currentAyahIndex.refresh();
      }
    });
  }

  /// Metode (private) untuk menggerakkan (scroll) daftar tampilan UI menuju ayat yang aktif dibaca.
  /// Principal Note: Menggunakan perhitungan manual (estimasi tinggi item)
  /// untuk memposisikan tampilan memusat pada ayat yang bersangkutan.
  void _scrollToCurrentAyah() {
    // Mengecek terlebih dahulu apakah ScrollController telah terhubung ke widget ListView di UI.
    if (scrollController.hasClients) {
      // Membuat estimasi jarak (offset) dalam piksel: Indeks aktif * Estimasi tinggi rata-rata 1 item (misalnya 100px).
      final offset = currentAyahIndex.value * 100.0;
      
      // Melakukan animasi gulir secara asinkron (tanpa di-await).
      unawaited(
        scrollController.animateTo(
          // Posisi akhir (destinasi) dari scroll
          offset,
          // Durasi jalannya animasi gulir (500 milidetik).
          duration: const Duration(milliseconds: 500),
          // Gaya kurva animasi agar terlihat mulus saat bergerak.
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  /// Fungsi kontrol pemutaran: mengalihkan (toggle) antara status putar dan jeda.
  void playPause() {
    // Mengevaluasi apakah player sedang berjalan.
    if (player.playing) {
      // Jika iya, maka jeda (pause) pemutaran.
      unawaited(player.pause());
    } else {
      // Jika tidak, maka mulai (play) pemutaran.
      unawaited(player.play());
    }
  }

  /// Fungsi kontrol pemutaran: meloncat secara spesifik ke waktu tertentu pada durasi track saat ini.
  void seek(Duration position) {
    // Menginstruksikan audio player untuk melompat ke posisi durasi yang diminta.
    unawaited(player.seek(position));
  }

  /// Fungsi kontrol antrean: pindah maju ke track/ayat berikutnya di dalam playlist.
  /// Principal Note: Mengecek hasNext adalah wajib guna mencegah aplikasi crash
  /// atau me-restart playlist secara tidak sengaja ketika sudah mencapai akhir surah.
  void next() {
    // Validasi apakah masih ada track lanjutan.
    if (player.hasNext) {
      // Lompati antrean menuju item/ayat selanjutnya.
      unawaited(player.seekToNext());
    }
  }

  /// Fungsi kontrol antrean: mundur kembali ke track/ayat sebelumnya di dalam playlist.
  void previous() {
    // Validasi apakah masih ada track sebelumnya (bukan item pertama).
    if (player.hasPrevious) {
      // Kembali ke item/ayat sebelumnya di antrean.
      unawaited(player.seekToPrevious());
    }
  }

  /// Metode siklus hidup GetX yang dipanggil sebelum memori controller ini dihancurkan (disposed).
  @override
  Future<void> onClose() async {
    // Membersihkan memori (dispose) milik audio player agar tidak ada memory leak dari background audio stream.
    await player.dispose();
    
    // Membersihkan memori ScrollController agar tidak membebani tree.
    scrollController.dispose();
    
    // Memanggil rutin onClose dari superclass untuk menutup controller utama.
    await super.onClose();
  }
}
