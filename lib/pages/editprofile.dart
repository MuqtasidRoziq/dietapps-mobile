import 'package:diet_apps/components/snackbar.dart';
import 'package:flutter/material.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(child: ListView(
          children: [
            const SizedBox(height: 30,),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage(""),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.camera_alt,color: Colors.white,size: 18,
                      ),
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Nama Lengkap",
                border: OutlineInputBorder(),
              ),
              validator: (value) => 
              value!.isEmpty ?"nama tidak boleh kosong" : null,
            ),
            SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(
                hintText: "No Telp",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
             TextFormField(
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: (){
                  Navigator.pushNamed(context, '/profile');
                  ShowAlert(context, "update profile berhasil", Colors.green, 2);
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
        ),),
        ),
    );
  }
}