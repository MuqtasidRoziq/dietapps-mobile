import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diet_apps/controllers/recommendation_controller.dart';

class MockClient extends Mock implements http.Client {}
class FakeBaseRequest extends Fake implements http.BaseRequest {}
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  setUpAll(() {
    // Registrasi untuk MultipartRequest (BaseRequest)
    registerFallbackValue(FakeBaseRequest());
    
    // Registrasi untuk http.get/post (Uri)
    registerFallbackValue(Uri()); 
    
    // Inisialisasi awal untuk Storage (biar tidak error native code)
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('RecommendationController Unit Test', () {
    
    // Test untuk SharedPreferences (Logika Lokal)
    test('saveChecklist harus menyimpan data ke SharedPreferences', () async {
      // Setup SharedPreferences palsu
      SharedPreferences.setMockInitialValues({}); 
      
      Map<String, bool> testData = {'makanan_nasi_0': true};
      await RecommendationController.saveChecklist(testData);
      
      final result = await RecommendationController.getChecklist();
      expect(result['makanan_nasi_0'], true);
    });

    // Test untuk API (Logika Network)
    test('fetchLatestData harus mengembalikan data jika API sukses (200)', () async {
      final mockClient = MockClient();
      final mockContext = MockBuildContext();
      
      // Data simulasi dari server
      final fakeResponse = {
        'status': 'success',
        'data': {
          'makanan': [{'nama': 'Nasi', 'jam': '07:00'}]
        }
      };

      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(jsonEncode(fakeResponse), 200));

      // Kita butuh SharedPreferences karena fetchLatestData memanggil saveToLocal
      SharedPreferences.setMockInitialValues({});

      // Jalankan fungsi (Context bisa kita mock atau abaikan jika tidak kritis)
      final result = await RecommendationController.fetchLatestData(
        mockContext, 
        client: mockClient
      );

      expect(result?['makanan'][0]['nama'], 'Nasi');
    });
  });
}