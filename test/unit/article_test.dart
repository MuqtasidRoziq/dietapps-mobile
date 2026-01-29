import 'package:flutter_test/flutter_test.dart';

bool isEmailValid(String email) {
  return email.contains('@') && email.contains('.');
}

void main() {
  test('Email valid', () {
    expect(isEmailValid('test@email.com'), true);
  });

  test('Email tidak valid', () {
    expect(isEmailValid('testemail'), false);
  });
}
