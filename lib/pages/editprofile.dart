import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/profile_controller.dart';
import '../config/api.dart';
import '../components/snackbar.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});
  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final ProfileController _controller = ProfileController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  String? _selectedGender;
  XFile? _selectedImage; 
  String? _userProfilePicName;
  int? _userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String genderFromPrefs = prefs.getString('gender') ?? "";

    setState(() {
      final idData = prefs.get('id');
      if (idData is int) {
        _userId = idData;
      } else if (idData is String) {
        _userId = int.tryParse(idData);
      }

      _nameController.text = prefs.getString('fullname') ?? "";
      _emailController.text = prefs.getString('email') ?? "";

      // Validasi: Pastikan nilai gender ada di list Dropdown
      if (genderFromPrefs == "Laki-laki" || genderFromPrefs == "Perempuan") {
        _selectedGender = genderFromPrefs;
      } else {
        _selectedGender = null; 
      }

      _userProfilePicName = prefs.getString('profile_picture');
    });
  }

  _pickImage() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );

    if (result != null && result.isNotEmpty) {
      final file = await result.first.file;
      if (file != null) {
        setState(() => _selectedImage = XFile(file.path));
      }
    }
  }

  _save() async {
    if (_userId == null) return;
    setState(() => _isLoading = true);

    try {
      final response = await _controller.updateProfile(
        userId: _userId!,
        name: _nameController.text,
        email: _emailController.text,
        gender: _selectedGender ?? "",
        imageFile: _selectedImage,
      );

      // Debugging: Muncul di console terminal
      print("Response Backend: $response");

      if (response['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        
        // Ambil data dari Map 'data' yang dikirim backend
        final userData = response['data'];
        if (userData['profile_picture'] != null) {
          await prefs.setString('profile_picture', userData['profile_picture']);
        }

        // 2. Update data lainnya
        await prefs.setString('fullname', userData['fullname'] ?? _nameController.text);
        await prefs.setString('email', userData['email'] ?? _emailController.text);
        await prefs.setString('gender', userData['gender'] ?? (_selectedGender ?? ""));

        if (mounted) {
          String success = response['message'];
          ShowAlert(context, success, Colors.green, 2);
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context, true); 
          });
        }
      } else {
        if (mounted) {
          // Menampilkan pesan error spesifik dari Flask jika ada
          String errorMsg = "Gagal memperbarui profil";
          ShowAlert(context, errorMsg, Colors.red, 2);
        }
      }
    } catch (e) {
      print("Error Update: $e");
      if (mounted) ShowAlert(context, "Terjadi kesalahan koneksi", Colors.red, 2);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profil", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // --- AVATAR SECTION ---
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blueAccent, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _selectedImage != null
                                ? (kIsWeb 
                                    ? NetworkImage(_selectedImage!.path) 
                                    : FileImage(File(_selectedImage!.path)) as ImageProvider)
                                : (_userProfilePicName != null && _userProfilePicName != ""
                                    ? NetworkImage(
                                        "${ConfigApi.baseUrl}/api/get_image/$_userProfilePicName?v=${DateTime.now().millisecondsSinceEpoch}",
                                        // TAMBAHKAN HEADER INI
                                        headers: const {"ngrok-skip-browser-warning": "true"},
                                      )
                                    : null),
                            child: (_selectedImage == null && (_userProfilePicName == null || _userProfilePicName == ""))
                                ? const Icon(Icons.person, size: 65, color: Colors.grey)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 20,
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildInputLabel("Nama Lengkap"),
                  TextField(
                    controller: _nameController,
                    decoration: _inputDecoration(Icons.person_outline, "Masukkan nama"),
                  ),
                  const SizedBox(height: 20),

                  _buildInputLabel("Email"),
                  TextField(
                    controller: _emailController,
                    decoration: _inputDecoration(Icons.email_outlined, "Masukkan email"),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    hint: Text("Pilih Jenis Kelamin"),
                    decoration: _inputDecoration(Icons.wc_outlined, ""),
                    items: ["Laki-laki", "Perempuan"].map((e) {
                      return DropdownMenuItem<String>(
                        value: e, 
                        child: Text(e)
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedGender = v),
                    // Validasi tambahan agar tidak error saat build
                    validator: (value) => value == null ? "Pilih jenis kelamin" : null,
                  ),
                  
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "SIMPAN PERUBAHAN",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // UI Helper: Label Input
  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  // UI Helper: Decoration Input
  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
    );
  }
}