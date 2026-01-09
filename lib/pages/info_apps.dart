import 'package:flutter/material.dart';

class InfoApps extends StatelessWidget {
  const InfoApps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Aplikasi'),
      ),
      body: const Center(
        child: Text('Halaman Info Aplikasi'),
      ),
    );
  }
}