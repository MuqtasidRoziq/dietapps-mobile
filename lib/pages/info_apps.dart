import 'package:flutter/material.dart';

class InfoApps extends StatelessWidget {
  const InfoApps({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Aplikasi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Aplikasi
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.shield_rounded, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dietkuy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Versi 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Card Informasi Pengembang
            _buildInfoCard(
              title: 'Pengembang',
              children: [
                _infoTile(Icons.code, 'Developer', 'Tim Kelompok 8'),
                _infoTile(Icons.language, 'Website', 'www.dietkuy.id'),
                _infoTile(Icons.email, 'Kontak', 'support@diet.id'),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              '© 2026 All Rights Reserved',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}