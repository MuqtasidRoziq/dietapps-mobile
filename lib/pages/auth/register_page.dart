import 'package:diet_apps/controllers/auth/register_controller.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Inisialisasi Controller
  final RegisterController _controller = RegisterController();

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController jkController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Icon(Icons.app_registration_rounded, size: 80, color: Colors.blueAccent),
              SizedBox(height: 10),
              Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                ),
                child: Column(
                  children: [
                    _buildTextField(fullnameController, "Full Name", Icons.person_outline),
                    SizedBox(height: 15),
                    _buildDropdownField(),
                    SizedBox(height: 15),
                    _buildTextField(emailController, "Email", Icons.email_outlined),
                    SizedBox(height: 15),
                    _buildPasswordField(passwordController, "Password", isPasswordVisible, 
                      () => setState(() => isPasswordVisible = !isPasswordVisible)),
                    SizedBox(height: 15),
                    _buildPasswordField(confirmPasswordController, "Confirm Password", isConfirmPasswordVisible, 
                      () => setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible)),
                    SizedBox(height: 30),
                    
                    // Button Trigger Controller
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () {
                          _controller.register(
                            context,
                            fullname: fullnameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                            jenisKelamin: jkController.text,
                            setLoading: (val) => setState(() => isLoading = val),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: isLoading 
                          ? CircularProgressIndicator(color: Colors.white) 
                          : Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper tetap di sini agar UI konsisten
  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Color(0xFFF8FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: jkController.text.isEmpty ? null : jkController.text,
      items: ['Laki-laki', 'Perempuan'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (v) => setState(() => jkController.text = v!),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.wc, color: Colors.blueAccent),
        labelText: 'Jenis Kelamin',
        filled: true,
        fillColor: Color(0xFFF8FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool isVisible, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Color(0xFFF8FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off), onPressed: toggle),
      ),
    );
  }
}