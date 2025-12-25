import 'package:flutter/material.dart';

/// Extension untuk Color yang menyediakan method kompatibilitas
/// untuk mengganti withOpacity yang deprecated
extension ColorExtension on Color {
  /// Mengganti withOpacity dengan withValues untuk Flutter 3.8+
  Color opacity(double opacity) {
    return Color.fromRGBO(red, green, blue, opacity);
  }
}
