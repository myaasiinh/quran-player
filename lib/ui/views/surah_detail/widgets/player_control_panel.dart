import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/ui/views/surah_detail/widgets/audio_visualizer.dart';

/// [PlayerControlPanel] adalah komponen kontrol pemutar audio yang canggih.
/// Digunakan untuk menampilkan dan mengontrol pemutaran murottal Al-Quran.
///
/// **Catatan Utama**: Menggunakan StatefulWidget karena memerlukan AnimationController 
/// lokal untuk memberikan efek visualisasi gelombang suara (audio wave) yang dinamis.
class PlayerControlPanel extends StatefulWidget {
  /// Konstruktor panel kontrol pemutar audio.
  const PlayerControlPanel({
    required this.player,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onSeek,
    super.key,
  });

  /// Instansi [AudioPlayer] dari package `just_audio` untuk streaming status audio.
  final AudioPlayer player;
  
  /// Status apakah audio sedang dimainkan saat ini.
  final bool isPlaying;
  
  /// Callback yang dipicu saat tombol mainkan (play) atau jeda (pause) ditekan.
  final VoidCallback onPlayPause;
  
  /// Callback yang dipicu saat tombol lagu/ayat selanjutnya (next) ditekan.
  final VoidCallback onNext;
  
  /// Callback yang dipicu saat tombol lagu/ayat sebelumnya (previous) ditekan.
  final VoidCallback onPrevious;
  
  /// Callback yang dipicu ketika pengguna mengubah posisi slider progress bar (seek).
  final Function(Duration) onSeek;

  @override
  State<PlayerControlPanel> createState() => _PlayerControlPanelState();
}

class _PlayerControlPanelState extends State<PlayerControlPanel>
    with SingleTickerProviderStateMixin {
  /// Kontroler animasi untuk menggerakkan visualizer gelombang suara.
  late AnimationController _visualizerController;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi controller animasi visualizer audio yang berulang.
    // Durasi animasi diatur selama 1500 milidetik untuk perulangan halus.
    _visualizerController = AnimationController(
      vsync: this, // Membutuhkan SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 1500),
    );
    // Memulai animasi secara terus-menerus tanpa perlu menunggunya (unawaited)
    unawaited(_visualizerController.repeat());
  }

  @override
  void dispose() {
    // Membersihkan/membebaskan sumber daya kontroler animasi untuk mencegah memory leak
    _visualizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wadah utama panel kontrol pemutar di bagian bawah layar
    return Container(
      // Memberikan jarak bantalan (padding) internal
      padding: const EdgeInsets.all(24),
      // Desain dekorasi panel bawah melengkung dengan efek bayangan untuk kedalaman visual.
      decoration: const BoxDecoration(
        color: Colors.white,
        // Membulatkan kedua sudut bagian atas panel
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        // Memberikan bayangan untuk memberikan kesan mengambang/pop-up
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20, // Tingkat keburaman bayangan
            offset: Offset(0, -10), // Arah pergeseran bayangan ke atas
          ),
        ],
      ),
      // Menyusun komponen secara vertikal (kolom)
      child: Column(
        // Meminimumkan tinggi kolom agar pas dengan isi konten
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visualizer kustom menggunakan CustomPainter (UI Khusus untuk Audio Wave).
          // AnimatedBuilder merespons pergerakan _visualizerController
          AnimatedBuilder(
            animation: _visualizerController,
            builder: (context, child) {
              // CustomPaint untuk menggambar visualisasi grafik secara manual
              return CustomPaint(
                // Menetapkan lebar tak terbatas dan tinggi 40 piksel
                size: const Size(double.infinity, 40),
                // Painter eksternal yang merender grafik animasi gelombang suara
                painter: AudioVisualizerPainter(
                  // Meneruskan nilai progres animasi saat ini (0.0 - 1.0)
                  animationValue: _visualizerController.value,
                  // Mengatur apakah gelombang akan bergerak berdasarkan status bermain
                  isPlaying: widget.isPlaying,
                  // Mewarnai gelombang dengan warna primer tema yang ditransparansikan
                  color: context.colorScheme!.primary.withValues(alpha: 0.5),
                ),
              );
            },
          ),
          // Jarak vertikal antara visualizer dan progress bar
          const SizedBox(height: 16),
          // Progress bar menggunakan StreamBuilder bersarang untuk pembaruan real-time 
          // dari engine audio berdasarkan (posisi, durasi, dan buffer).
          StreamBuilder<Duration>(
            // Stream posisi detik audio saat ini dimainkan
            stream: widget.player.positionStream,
            builder: (context, snapshot) {
              // Menyimpan nilai posisi, atau nol jika belum tersedia
              final position = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                // Stream total durasi keseluruhan audio
                stream: widget.player.durationStream,
                builder: (context, snapshot) {
                  // Menyimpan total durasi, atau nol jika belum ada
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration>(
                    // Stream sejauh mana audio telah di-buffer/diunduh untuk dimainkan
                    stream: widget.player.bufferedPositionStream,
                    builder: (context, snapshot) {
                      // Menyimpan posisi buffer, atau nol
                      final buffered = snapshot.data ?? Duration.zero;
                      // Komponen ProgressBar dari package eksternal
                      return ProgressBar(
                        // Durasi yang telah diputar
                        progress: position,
                        // Durasi yang telah dimuat di memori cache
                        buffered: buffered,
                        // Total durasi audio keseluruhan
                        total: duration,
                        // Menangani ketika pengguna menggeser thumb slider
                        onSeek: (val) => unawaited(widget.player.seek(val)),
                        // Warna dasar bilah (jalur lintasan) slider
                        baseBarColor:
                            context.colorScheme!.primary.withValues(alpha: 0.1),
                        // Warna bagian bilah yang telah terlewati
                        progressBarColor: context.colorScheme!.primary,
                        // Warna untuk bagian bilah yang telah ter-buffer
                        bufferedBarColor:
                            context.colorScheme!.primary.withValues(alpha: 0.2),
                        // Warna tombol bulat pegangan (thumb)
                        thumbColor: context.colorScheme!.primary,
                        // Ukuran radius untuk tombol pegangan (thumb)
                        thumbRadius: 8,
                      );
                    },
                  );
                },
              );
            },
          ),
          // Jarak vertikal sebelum tombol kontrol navigasi media
          const SizedBox(height: 16),
          // Barisan kontrol playback (Previous, Play/Pause, Next) diatur secara horizontal
          Row(
            // Memposisikan seluruh ikon tepat di tengah baris
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tombol IconButton untuk kembali (Previous)
              IconButton(
                // Mengatur ukuran besar ikon
                iconSize: 32,
                // Memakai ikon standar kembali material design
                icon: const Icon(Icons.skip_previous),
                // Callback kembali
                onPressed: widget.onPrevious,
                // Mewarnai ikon dengan warna primer
                color: context.colorScheme!.primary,
              ),
              // Spasi mendatar antar ikon
              const SizedBox(width: 24),
              // Tombol Play/Pause utama dengan bentuk bulat, efek gradient, dan bayangan
              GestureDetector(
                // Menangani ketukan pada tombol play/pause
                onTap: widget.onPlayPause,
                // Wadah pembentuk bundaran untuk Play/Pause
                child: Container(
                  width: 64, // Dimensi lebar yang seragam
                  height: 64, // Dimensi tinggi yang seragam
                  decoration: BoxDecoration(
                    // Membuat bentuk bundar
                    shape: BoxShape.circle,
                    // Pewarnaan latar gradasi linear dari atas ke bawah
                    gradient: LinearGradient(
                      colors: [
                        context.colorScheme!.primary, // Warna pertama (atas)
                        context.colorScheme!.secondary, // Warna kedua (bawah)
                      ],
                    ),
                    // Memberikan efek bayangan jatuh yang menyala berwarna primer
                    boxShadow: [
                      BoxShadow(
                        color:
                            context.colorScheme!.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  // Ikon play/pause di tengah bentuk bulat
                  child: Icon(
                    // Menampilkan ikon pause jika sedang bermain, play jika dijeda
                    widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    // Mewarnai ikon putih kontras dengan tombol
                    color: Colors.white,
                    // Ukuran ikon diperbesar
                    size: 40,
                  ),
                ),
              ),
              // Spasi mendatar antar ikon
              const SizedBox(width: 24),
              // Tombol IconButton untuk maju (Next)
              IconButton(
                // Mengatur ukuran besar ikon
                iconSize: 32,
                // Memakai ikon standar maju material design
                icon: const Icon(Icons.skip_next),
                // Callback maju
                onPressed: widget.onNext,
                // Mewarnai ikon dengan warna primer
                color: context.colorScheme!.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
