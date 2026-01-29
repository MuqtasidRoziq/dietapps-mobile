import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:diet_apps/controllers/scan_controller.dart';

class FakeBaseRequest extends Fake implements http.BaseRequest {}

class MockBuildContext extends Mock implements BuildContext {}

class MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBaseRequest());
  });

  test('Test ScanController Sukses Tanpa API Aktif', () async {
    final mockContext = MockBuildContext();
    final mockClient = MockClient();
    final controller = ScanController();

    final responseData = jsonEncode({'status': 'success', 'message': 'Berhasil'});

    when(() => mockClient.send(any())).thenAnswer((_) async {
      return http.StreamedResponse(
        Stream.value(utf8.encode(responseData)),
        200,
      );
    });

    // Jalankan test
    final result = await controller.uploadScanData(
      mockContext, 
      userId: '1',
      gender: 'L',
      tinggi: 170,
      berat: 60,
      alergi: [],
      images: [],
      client: mockClient, 
    );

    expect(result?['status'], 'success');
  });
}