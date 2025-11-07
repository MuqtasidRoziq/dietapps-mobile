import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Let's get started!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Text("login to stay in apps fit and healthy", style: TextStyle(fontSize: 14, color: Colors.grey),),
            SizedBox(height: 100,),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/login');
            }, child: Text("Login"),style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape :RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)
                )
              ) , 
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/register');
            }, child: Text("Sign Up"),style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 94, vertical: 19),
                backgroundColor: Colors.white,
                shape :RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: BorderSide(color: Colors.blue)
                )
              ) , 
            ),

          ],
        ),
      ),
    );
  }
}