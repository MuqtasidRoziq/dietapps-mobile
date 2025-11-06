import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(50),
          children: [
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
                prefixIcon: Icon(Icons.lock_outline),
                label: Text("enter your password"),
                suffixIcon: Icon(Icons.visibility_off_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: (){

              }, style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                
              ),child: Text("forgot password?", style: TextStyle(color: Colors.blue),)),
            ),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/homepage');
            }, child: Text("Login"),style: ElevatedButton.styleFrom(
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
                  Navigator.pushNamed(context, '/register');
                }, child: Text("Sign Up", style: TextStyle(color: Colors.blue),)
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.grey, thickness: 1)
                  ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("or"),
                ),
                Expanded(
                  child: Divider(color: Colors.grey, thickness: 1)
                  ),
              ],
            ),
            SizedBox(height: 20,),
            ElevatedButton.icon(onPressed: (){

            }, 
            icon: Image.asset("assets/images/google_logo.png", height: 24, width: 24,), 
            label: Text("Login with Google", style: TextStyle(fontWeight: FontWeight.bold),), 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey),
              padding: EdgeInsets.symmetric(vertical: 20),
              shape :RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              )
            ),
            ),
            SizedBox(height: 20,),
            ElevatedButton.icon(onPressed: (){

            }, 
            icon: Image.asset("assets/images/logo_facebook.png", height: 24, width: 24,), 
            label: Text("Login with Facebook", style: TextStyle(fontWeight: FontWeight.bold),),
             style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey),
              padding: EdgeInsets.symmetric(vertical: 20),
              shape :RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              )
            ),
            ),
          ],
        ),
      ),
    );
  }
}