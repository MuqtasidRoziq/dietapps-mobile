import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: ListView(
          padding: EdgeInsets.all(50),
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline,),
                label: Text("enter your full name"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined,),
                label: Text("enter your email"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined,),
                label: Text("enter your password"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined,),
                label: Text("enter your confirm password"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
            CheckboxListTile(
              value: false, 
              onChanged: (value){}, 
              title: Text("I agree to the dietkuys terms of service and privacy police", style: TextStyle(fontSize: 15),),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/login');
            }, child: Text("Sign Up"),style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape :RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)
                )
              ) , 
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/login');
                }, child: Text("Login", style: TextStyle(color: Colors.blue),)
                )
              ],
            ),
          ],
        ),
    );
  }
}