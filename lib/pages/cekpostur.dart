import 'package:diet_apps/components/menu_button.dart';
import 'package:flutter/material.dart';

class CekPostur extends StatelessWidget {
  const CekPostur({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Scan Postur",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("ayo scan postur tubuh anda siapa tau kekurangan gizi atau terdeteksi obesitas", style: TextStyle(fontSize: 15, ), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_rounded, color: Colors.amber),
                    Text("perhatian!!", style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
                Text("harap menggunakan baju yang ketat"),
                Text("untuk hasil yang lebih akurat"),
              ],
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButton(
                title: "Upload Image", 
                icon: Icons.upload_file, 
                color: Colors.blueAccent, 
                onPressed: (){

                }
              ),
              MenuButton(
                title: "Open Camera", 
                icon: Icons.camera_alt, 
                color: Colors.blueAccent, 
                onPressed: (){

                }
              ),
            ],
          )
        ]
      ),
    );
  }
}
