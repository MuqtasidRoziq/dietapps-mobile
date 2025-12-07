import 'package:diet_apps/components/snackbar.dart';
import 'package:flutter/material.dart';

class Ubahpass extends StatefulWidget {
  const Ubahpass({super.key});

  @override
  State<Ubahpass> createState() => _UbahpassState();
}

class _UbahpassState extends State<Ubahpass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Password"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 50,),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "masukan password lama",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Masukan password baru",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(
                    hintText: "konfirmasi password",
                    border: OutlineInputBorder()
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
              ShowAlert(context, "berhasil merubah password", Colors.green, 2);
            },
            label: const Text("Simpan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}