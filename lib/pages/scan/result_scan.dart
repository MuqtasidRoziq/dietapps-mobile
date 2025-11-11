import 'package:flutter/material.dart';

class ResultScan extends StatelessWidget {
  const ResultScan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          children: [
            Text("Prediksi Postur Tubuh", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lengan : over"),
                  Text("Perut  : over"),
                  Text("Paha   : over"),
                ],
              ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/rekomen-pola-hidup');
            }, child: Text("Lihat Rekomendasi Pola Hidup"))
          ],
        ),
      ),
    );
  }
}