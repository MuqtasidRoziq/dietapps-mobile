import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diet_apps/controllers/get_user_data.dart'; // Sesuaikan path-nya

void main() {
  group('GetUserData Unit Test', () {
    late GetUserData getUserData;

    setUp(() {
      getUserData = GetUserData();
    });

    test('Harus mengembalikan Map user data dengan benar dari SharedPreferences', () async {
      // 1. Siapkan data simulasi di SharedPreferences
      SharedPreferences.setMockInitialValues({
        'id': 'user123',
        'fullname': 'Muqtasid Roziq',
        'gender': 'Laki-laki',
        'email': 'roziq@example.com',
        'profile_picture': 'foto_profil.jpg'
      });

      // 2. Jalankan fungsi
      final result = await getUserData.getUserData();

      // 3. Verifikasi hasilnya
      expect(result['id'], 'user123');
      expect(result['fullname'], 'Muqtasid Roziq');
      expect(result['email'], 'roziq@example.com');
      
      // Verifikasi URL foto (mengecek apakah URL mengandung nama file dan domain api)
      expect(result['profile_picture'], contains('foto_profil.jpg'));
      expect(result['profile_picture'], contains('/api/get_image/'));
    });

    test('Harus mengembalikan profile_picture null jika di prefs kosong', () async {
      // Setup data tanpa profile_picture
      SharedPreferences.setMockInitialValues({
        'id': 'user123',
        'profile_picture': ?null,
      });

      final result = await getUserData.getUserData();

      expect(result['profile_picture'], isNull);
    });
  });
}