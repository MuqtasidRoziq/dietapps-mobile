import 'package:diet_apps/controllers/auth/change_pass_controlller.dart';
import 'package:flutter/material.dart';

class Ubahpass extends StatefulWidget {
  const Ubahpass({super.key});

  @override
  State<Ubahpass> createState() => _UbahpassState();
}

class _UbahpassState extends State<Ubahpass> {
  final UbahPassController _controller = UbahPassController();
  
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool isLoading = false;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Ubah Password", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Icon(Icons.lock_reset_rounded, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 10),
            const Text("Security Update", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Pastikan password baru Anda kuat dan aman", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  _buildPasswordField(oldPassController, "Password Lama"),
                  const SizedBox(height: 15),
                  _buildPasswordField(newPassController, "Password Baru"),
                  const SizedBox(height: 15),
                  _buildPasswordField(confirmPassController, "Konfirmasi Password Baru"),
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () {
                        _controller.updatePassword(
                          context,
                          oldPassword: oldPassController.text,
                          newPassword: newPassController.text,
                          confirmPassword: confirmPassController.text,
                          setLoading: (val) => setState(() => isLoading = val),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueAccent),
        filled: true,
        fillColor: const Color(0xFFF8FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, size: 20),
          onPressed: () => setState(() => isVisible = !isVisible),
        ),
      ),
    );
  }
}