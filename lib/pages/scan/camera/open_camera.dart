import 'dart:io';
import 'package:camera/camera.dart';
import 'package:diet_apps/main.dart'; // Pastikan 'cameras' ada di sini
import 'package:flutter/material.dart';

class OpenCamera extends StatefulWidget {
  const OpenCamera({super.key});

  @override
  State<OpenCamera> createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> {
  CameraController? _controller;
  int _selectedCameraIndex = 0; // 0: Belakang, 1: Depan
  int _currentStep = 1; // 1: Depan, 2: Samping, 3: Belakang
  
  List<String> _capturedPaths = []; // Penyimpanan sementara untuk 3 foto
  bool _isPreviewMode = false;
  String? _currentPreviewPath;

  @override
  void initState() {
    super.initState();
    _initCamera(_selectedCameraIndex);
  }

  Future<void> _initCamera(int index) async {
    if (cameras.isEmpty) return;
    
    // Matikan controller lama sebelum membuat yang baru
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameras[index], 
      ResolutionPreset.high, 
      enableAudio: false
    );

    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Gagal inisialisasi kamera: $e");
    }
  }

  // Fungsi Ganti Kamera (Flip)
  void _toggleCamera() {
    if (cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex == 0) ? 1 : 0;
    _initCamera(_selectedCameraIndex);
  }

  // Ambil Foto
  Future<void> _takePicture() async {
    try {
      final image = await _controller!.takePicture();
      setState(() {
        _currentPreviewPath = image.path;
        _isPreviewMode = true;
      });
    } catch (e) {
      debugPrint("Error ambil foto: $e");
    }
  }

  // Simpan foto dan lanjut ke tahap berikutnya
  void _confirmPhoto() {
    _capturedPaths.add(_currentPreviewPath!);
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
        _isPreviewMode = false;
        _currentPreviewPath = null;
      });
    } else {
      // PINDAH KE HALAMAN ANALISIS (Bawa 3 file untuk MediaPipe)
      Navigator.pushReplacementNamed(context, '/inputbmi', arguments: _capturedPaths);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. TAMPILAN KAMERA ATAU PREVIEW FOTO
          _isPreviewMode ? _buildImagePreview() : _buildLiveCamera(),

          // 2. OVERLAY PANDUAN (Hanya muncul saat live)
          if (!_isPreviewMode) _buildGuideOverlay(),

          // 3. INSTRUKSI ATAS
          _buildTopInstructions(),

          // 4. TOMBOL AKSI BAWAH
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildLiveCamera() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover, // FIX: Anti-Gepeng
        child: SizedBox(
          width: _controller!.value.previewSize!.height,
          height: _controller!.value.previewSize!.width,
          child: CameraPreview(_controller!),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return SizedBox.expand(
      child: Image.file(File(_currentPreviewPath!), fit: BoxFit.cover),
    );
  }

  Widget _buildGuideOverlay() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }

  Widget _buildTopInstructions() {
    return Positioned(
      top: 50,
      left: 20, right: 20,
      child: Column(
        children: [
          // Progress Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 30, height: 5,
              decoration: BoxDecoration(
                color: index < _currentStep ? Colors.yellow : Colors.white24,
                borderRadius: BorderRadius.circular(5),
              ),
            )),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
            child: Text(
              _isPreviewMode ? "Cek Hasil Foto" : "Posisi: ${_getStepName()}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 0, right: 0,
      child: _isPreviewMode 
      ? Row( // MODE PREVIEW
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(Icons.refresh, "Ulangi", Colors.grey[800]!, () {
              setState(() => _isPreviewMode = false);
            }),
            _actionButton(Icons.check, "Gunakan", Colors.green, _confirmPhoto),
          ],
        )
      : Row( // MODE LIVE CAMERA
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
            GestureDetector(
              onTap: _takePicture,
              child: Container(
                height: 80, width: 80,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                child: const Center(child: Icon(Icons.camera_alt, color: Colors.white, size: 40)),
              ),
            ),
            IconButton(
              onPressed: _toggleCamera, // TOMBOL GANTI KAMERA
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
            ),
          ],
        ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
    );
  }

  String _getStepName() {
    if (_currentStep == 1) return "Tampak Depan";
    if (_currentStep == 2) return "Tampak Samping";
    return "Tampak Belakang";
  }
}