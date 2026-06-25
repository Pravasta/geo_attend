import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/constants/app_constants.dart';
import 'package:geo_attend/core/utils/distance_calculator.dart';

void main() {
  const calculator = DistanceCalculator();
  const radius = AppConstants.defaultRadiusMeters; // 50.0 m

  group('isWithinRadius (aturan absensi 50 m)', () {
    test('jarak 0 m -> di dalam radius (accepted)', () {
      expect(calculator.isWithinRadius(0, radius), isTrue);
    });

    test('jarak tepat 50 m -> di dalam radius (accepted)', () {
      expect(calculator.isWithinRadius(50, radius), isTrue);
    });

    test('jarak 49.9 m -> di dalam radius (accepted)', () {
      expect(calculator.isWithinRadius(49.9, radius), isTrue);
    });

    test('jarak 51 m -> di luar radius (rejected)', () {
      expect(calculator.isWithinRadius(51, radius), isFalse);
    });

    test('jarak 50.01 m -> di luar radius (rejected)', () {
      expect(calculator.isWithinRadius(50.01, radius), isFalse);
    });
  });

  group('distanceInMeters', () {
    test('dua titik identik berjarak 0 m', () {
      final distance = calculator.distanceInMeters(
        startLatitude: -6.200000,
        startLongitude: 106.816666,
        endLatitude: -6.200000,
        endLongitude: 106.816666,
      );
      expect(distance, 0);
    });

    test('mengembalikan jarak positif untuk dua titik berbeda', () {
      final distance = calculator.distanceInMeters(
        startLatitude: -6.200000,
        startLongitude: 106.816666,
        endLatitude: -6.201000,
        endLongitude: 106.817666,
      );
      expect(distance, greaterThan(0));
    });
  });
}
