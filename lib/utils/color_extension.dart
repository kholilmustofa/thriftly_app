import 'package:flutter/material.dart';

/// Extension untuk Color yang menyediakan method kompatibilitas
/// untuk mengganti withOpacity yang deprecated
extension ColorExtension on Color {
  /// Mengganti withOpacity dengan withValues untuk Flutter 3.8+
  Color opacity(double opacity) {
    return Color.fromRGBO(
      (r * 255.0).round().clamp(0, 255),
      (g * 255.0).round().clamp(0, 255),
      (b * 255.0).round().clamp(0, 255),
      opacity,
    );
  }
}
