import 'package:quran_player/core/extension/context_extension.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControlPanel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme!.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<Duration>(
            stream: player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration>(
                    stream: player.bufferedPositionStream,
                    builder: (context, snapshot) {
                      final buffered = snapshot.data ?? Duration.zero;
                      return ProgressBar(
                        progress: position,
                        buffered: buffered,
                        total: duration,
                        onSeek: onSeek,
                      );
                    },
                  );
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: onPrevious,
              ),
              IconButton(
                iconSize: 48,
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                ),
                onPressed: onPlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
