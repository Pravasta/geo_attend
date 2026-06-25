import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/utils/date_formatter.dart';

void main() {
  test('formatDateTime mengembalikan format dd MMM yyyy, HH:mm', () {
    final result = DateFormatter.formatDateTime(DateTime(2026, 6, 25, 14, 30));

    expect(result, '25 Jun 2026, 14:30');
  });

  test('formatDateTime memberi padding nol pada jam/menit', () {
    final result = DateFormatter.formatDateTime(DateTime(2026, 1, 5, 9, 5));

    expect(result, '05 Jan 2026, 09:05');
  });
}
