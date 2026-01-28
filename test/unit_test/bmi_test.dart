import 'package:flutter_test/flutter_test.dart';

double hitungBMI(double berat, double tinggiCm) {
  final tinggiM = tinggiCm / 100;
  return berat / (tinggiM * tinggiM);
}

void main() {
  test('BMI dihitung dengan benar', () {
    final bmi = hitungBMI(60, 170);
    expect(bmi.toStringAsFixed(1), '20.8');
  });
}
