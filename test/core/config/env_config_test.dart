import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attend/core/config/env_config.dart';

void main() {
  test('mapsApiKey mengembalikan nilai dari env', () {
    dotenv.loadFromString(envString: 'MAPS_API_KEY=abc123');

    expect(EnvConfig.mapsApiKey, 'abc123');
    expect(EnvConfig.hasMapsApiKey, isTrue);
  });

  test('hasMapsApiKey false saat key kosong', () {
    dotenv.loadFromString(envString: 'MAPS_API_KEY=', isOptional: true);

    expect(EnvConfig.mapsApiKey, '');
    expect(EnvConfig.hasMapsApiKey, isFalse);
  });
}
