import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Akses terpusat ke variabel environment dari file `.env`.
///
/// Memuat nilai dilakukan sekali saat startup (`main.dart`) melalui
/// `dotenv.load`. Kelas ini hanya menyediakan getter yang aman.
class EnvConfig {
  EnvConfig._();

  /// Google Maps API key. Kosong bila belum diisi pada `.env`.
  static String get mapsApiKey => dotenv.maybeGet('MAPS_API_KEY') ?? '';

  /// `true` bila API key Maps sudah tersedia.
  static bool get hasMapsApiKey => mapsApiKey.trim().isNotEmpty;
}
