import 'package:quran_player/core/helper/app_logger.dart';
import 'package:flutter/foundation.dart';

/* Created by
   Antigravity - AI Principal Engineer
*/

/// A Principal-grade helper to handle heavy CPU tasks outside the Main/UI Thread.
/// This ensures the application maintains 60 FPS even during complex computations.
class IsolateHelper {
  /// Runs a [callback] in a separate Background Isolate using Flutter's compute function.
  ///
  /// [callback]: The function to run (must be a top-level function or static).
  /// [message]: The data to pass to the function.
  ///
  /// Example:
  /// ```dart
  /// final result = await IsolateHelper.run(myHeavyTask, data);
  /// ```
  static Future<R> run<Q, R>(ComputeCallback<Q, R> callback, Q message) async {
    try {
      // compute() is a high-level wrapper around Isolate.spawn()
      // it handles spawning, communication, and closing the isolate.
      return await compute(callback, message);
    } catch (e) {
      AppLogger.debug('IsolateHelper Error: $e');
      rethrow;
    }
  }
}
