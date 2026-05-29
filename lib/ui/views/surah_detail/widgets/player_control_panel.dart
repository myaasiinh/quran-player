import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player/core/extension/context_extension.dart';
import 'package:quran_player/ui/views/surah_detail/widgets/audio_visualizer.dart';

/// [PlayerControlPanel] adalah komponen kontrol pemutar audio yang canggih.
/// Principal Note: Menggunakan StatefulWidget karena memerlukan AnimationController lokal
/// untuk visualisasi gelombang suara (audio wave).
class PlayerControlPanel extends StatefulWidget {
  const PlayerControlPanel({
    required this.player,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onSeek,
    super.key,
  });

  final AudioPlayer player;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(Duration) onSeek;

  @override
  State<PlayerControlPanel> createState() => _PlayerControlPanelState();
}

class _PlayerControlPanelState extends State<PlayerControlPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _visualizerController;

  @override
  void initState() {
    super.initState();
    // Animasi visualizer audio yang berulang.
    _visualizerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    unawaited(_visualizerController.repeat());
  }

  @override
  void dispose() {
    _visualizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      // Desain panel bawah melengkung dengan shadow untuk kedalaman visual.
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visualizer kustom menggunakan CustomPainter (OP UI).
          AnimatedBuilder(
            animation: _visualizerController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(double.infinity, 40),
                painter: AudioVisualizerPainter(
                  animationValue: _visualizerController.value,
                  isPlaying: widget.isPlaying,
                  color: context.colorScheme!.primary.withValues(alpha: 0.5),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Progress bar menggunakan StreamBuilder untuk pembaruan real-time dari engine audio.
          StreamBuilder<Duration>(
            stream: widget.player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: widget.player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration>(
                    stream: widget.player.bufferedPositionStream,
                    builder: (context, snapshot) {
                      final buffered = snapshot.data ?? Duration.zero;
                      return ProgressBar(
                        progress: position,
                        buffered: buffered,
                        total: duration,
                        onSeek: (val) => unawaited(widget.player.seek(val)),
                        baseBarColor:
                            context.colorScheme!.primary.withValues(alpha: 0.1),
                        progressBarColor: context.colorScheme!.primary,
                        bufferedBarColor:
                            context.colorScheme!.primary.withValues(alpha: 0.2),
                        thumbColor: context.colorScheme!.primary,
                        barHeight: 5,
                        thumbRadius: 8,
                      );
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          // Barisan kontrol playback (Previous, Play/Pause, Next).
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 32,
                icon: const Icon(Icons.skip_previous),
                onPressed: widget.onPrevious,
                color: context.colorScheme!.primary,
              ),
              const SizedBox(width: 24),
              // Tombol Play/Pause utama dengan efek gradient dan shadow.
              GestureDetector(
                onTap: widget.onPlayPause,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        context.colorScheme!.primary,
                        context.colorScheme!.secondary,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            context.colorScheme!.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              IconButton(
                iconSize: 32,
                icon: const Icon(Icons.skip_next),
                onPressed: widget.onNext,
                color: context.colorScheme!.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
