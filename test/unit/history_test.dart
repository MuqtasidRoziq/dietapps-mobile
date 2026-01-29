import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:diet_apps/controllers/history_controller.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  // Ingat: registrasi Uri karena http.get menggunakan Uri
  setUpAll(() {
    registerFallbackValue(Uri());
    // Mocking untuk FlutterSecureStorage agar tidak error native
    FlutterSecureStorage.setMockInitialValues({'jwt_token': 'fake_token'});
  });

  group('HistoryController Unit Test', () {
    late HistoryController controller;
    late MockClient mockClient;

    setUp(() {
      controller = HistoryController();
      mockClient = MockClient();
    });

    test('Harus mengembalikan List data jika status code 200', () async {
      // 1. Siapkan response palsu sesuai format JSON backend kamu
      final fakeData = {
        "success": true,
        "data": [
          {"id": 1, "date": "2023-10-01", "result": "Ideal"},
          {"id": 2, "date": "2023-10-05", "result": "Overweight"}
        ]
      };

      // 2. Setup Mock
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(jsonEncode(fakeData), 200));

      // 3. Jalankan fungsi
      final result = await controller.getHistory(client: mockClient);

      // 4. Verifikasi
      expect(result, isA<List>());
      expect(result.length, 2);
      expect(result[0]['result'], 'Ideal');
    });

    test('Harus mengembalikan List kosong jika server error (500)', () async {
      // Setup Mock untuk error
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      final result = await controller.getHistory(client: mockClient);

      // Verifikasi harus kosong sesuai catch/else di controller kamu
      expect(result, isEmpty);
    });
  });
}