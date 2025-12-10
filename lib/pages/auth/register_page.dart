import 'package:diet_apps/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController jkController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  Future<void> Register() async {
    setState(() {
      isLoading = true;
    });

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        isLoading = false;
      });
      ShowAlert(context, "Password tidak sama harap cek kembali", Colors.red, 5);
      return;
    }

    final url = Uri.parse(
      "http://127.0.0.1:5000/api/auth/register",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullname": fullnameController.text,
        "jenis_kelamin": jkController.text,
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );
    final data = jsonDecode(response.body);

    setState(() {
      isLoading = false;
    });

    if (data["success"] == true) {
      ShowAlert(context, data["message"], Colors.green, 2);
      Navigator.pushNamed(context, '/login');
    } else {
      ShowAlert(context, data["message"], Colors.red, 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                  Text("Register", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  SizedBox(height: 20,),
                  TextField(
                    controller: fullnameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: jkController.text.isEmpty ? null : jkController.text,
                    items: ['Laki-laki', 'Perempuan']
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        jkController.text = value!;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.wc_outlined),
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : Register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text("Register"),
                  ),
                ],
              ),
            ),
            ),
          ],
        ),
      )
    );
  }
}