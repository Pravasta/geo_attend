import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/services/connectivity_service.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;
  late ConnectivityServiceImpl service;

  setUp(() {
    mockConnectivity = MockConnectivity();
    service = ConnectivityServiceImpl(connectivity: mockConnectivity);
  });

  test('isConnected -> true saat terhubung wifi', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);

    expect(await service.isConnected(), isTrue);
  });

  test('isConnected -> true saat terhubung seluler', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.mobile]);

    expect(await service.isConnected(), isTrue);
  });

  test('isConnected -> false saat tidak ada koneksi', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.none]);

    expect(await service.isConnected(), isFalse);
  });
}
