import 'package:flutter_test/flutter_test.dart';

String mapGender(String input) {
  return input == 'Laki-laki' ? 'male' : 'female';
}

void main() {
  test('Mapping gender laki-laki', () {
    expect(mapGender('Laki-laki'), 'male');
  });

  test('Mapping gender perempuan', () {
    expect(mapGender('Perempuan'), 'female');
  });
}
