import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'register.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState>_formKey=GlobalKey();
  var Email;
  var Password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

            colors: [
              Colors.pink[100],
              Colors.amber[300],
              Colors.pink[200],
              Colors.pink[300],
              Colors.amber[500],
            ],

          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50,),
//            Image.asset('assects/Lojo.jpg',width: 220,),
            SizedBox(height: 20,),
            Text('Improving',style: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text('Agriculture For life',style: GoogleFonts.zillaSlab(fontSize: 22,fontWeight: FontWeight.bold),),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('SignIn',style: GoogleFonts.zillaSlab(fontSize: 30,fontWeight: FontWeight.bold,),),
                InkWell(
                    onTap:(){
                      Navigator.push(context, SlideRightRoute(page: SignUp()));
                    },
                    child: Text('SignUp',style: GoogleFonts.zillaSlab(fontSize: 18,fontWeight: FontWeight.bold),)),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35.0,35,35,15),
                    child: TextFormField(
                      decoration: InputDecoration(icon:Icon(Icons.mail,color: Colors.white60,),labelText: "Email",labelStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green[900])),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value.isEmpty || !value.contains('@')){
                          return 'Invalid email';
                        }
                        return null;
                      },
                      onSaved: (value){
                        Email=value;
                      },
                    ),
                  )
                  ,Padding(
                    padding: const EdgeInsets.fromLTRB(35.0,15,35,15),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(icon:Icon(Icons.lock,color: Colors.white60,),labelText: "Password",labelStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green[900])),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value.isEmpty || value.length <= 5 ){
                          return 'Invalid Password';
                        }
                        return null;
                      },
                      onSaved: (value){
                        Password=value;
                      },
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    width: 320,
                    child: RaisedButton(
                      onPressed: signIn,
                      color:Colors.green[100],
                      child: Text("SIGN IN",
                        style: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),


          ],
        ),
      ),
    );

  }
  Future<void> signIn() async{
    final formState=_formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: Email, password: Password);
        Navigator.pushReplacementNamed(context, '/home');
        //TODO : Navigate to home
      }catch(e){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error Occured !",style:GoogleFonts.zillaSlab(fontSize:30,fontWeight: FontWeight.bold,color: Colors.red )),
                content: Text(e.message),
                actions: [
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }
  }
}