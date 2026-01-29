import 'package:flutter_test/flutter_test.dart';

bool isTokenValid(String? token) {
  return token != null && token.isNotEmpty;
}

void main() {
  test('Token tersedia', () {
    expect(isTokenValid('abc123'), true);
  });

  test('Token null', () {
    expect(isTokenValid(null), false);
  });
}
