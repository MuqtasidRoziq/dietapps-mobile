import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Lupa Password"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "masukan alamat email"

                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}