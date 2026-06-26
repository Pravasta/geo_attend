import 'package:intl/intl.dart';

/// Utilitas format tanggal & waktu menggunakan `intl`.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, HH:mm');
  static final DateFormat _time = DateFormat('HH:mm');

  /// Contoh keluaran: `25 Jun 2026, 14:30`.
  static String formatDateTime(DateTime dateTime) =>
      _dateTime.format(dateTime);

  /// Contoh keluaran: `14:30`.
  static String formatTime(DateTime dateTime) => _time.format(dateTime);
}
