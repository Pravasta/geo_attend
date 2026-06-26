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

  // Nama hari & bulan ringkas (Indonesia) — deterministik tanpa init locale.
  static const List<String> _idDays = [
    '', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
  ];
  static const List<String> _idMonths = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  /// Contoh keluaran: `Kam, 26 Jun 2026 · 08:02`.
  static String formatHistoryDateTime(DateTime dt) {
    final day = _idDays[dt.weekday];
    final dd = dt.day.toString().padLeft(2, '0');
    final month = _idMonths[dt.month];
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$day, $dd $month ${dt.year} · $hh:$mm';
  }
}
