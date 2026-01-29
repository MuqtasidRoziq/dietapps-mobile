import 'package:flutter_test/flutter_test.dart';

bool isPasswordValid(String password) {
  return password.length >= 6;
}

void main() {
  test('Password valid', () {
    expect(isPasswordValid('123456'), true);
  });

  test('Password terlalu pendek', () {
    expect(isPasswordValid('123'), false);
  });
}
