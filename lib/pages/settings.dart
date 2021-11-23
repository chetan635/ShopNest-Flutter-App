import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final nameHolder1 = TextEditingController();
  final nameHolder2 = TextEditingController();
  final nameHolder3 = TextEditingController();
  final nameHolder4 = TextEditingController();
  final nameHolder5 = TextEditingController();
  final nameHolder6 = TextEditingController();

  clearTextInput(){

    nameHolder1.clear();
    nameHolder2.clear();
    nameHolder3.clear();
    nameHolder4.clear();
    nameHolder5.clear();
    nameHolder6.clear();

  }
  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;
  void createRecord (var Name, var address , var phone) async {
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();
    if(snapShot.exists){
      await databaseReference.collection("users")
          .doc("${user.uid}")
          .update({
        'Name': Name ,
        'Address': address,
        'Phone_No': phone,

      });
    }
    else{
      await databaseReference.collection("users")
          .doc("${user.uid}")
          .set({
        'Name': Name ,
        'Address': address,
        'Phone_No': phone,

      });
    }




  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        iconTheme: IconThemeData(color: Colors.black,),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Shop',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.pink,

                ),),
                Text('Nest',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.amber,

                ),),
              ],
            ),
            Icon(Icons.perm_identity,size: 35,),
          ],
        ),

        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Add Following Details Or update Personal Details',style: GoogleFonts.raleway(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueGrey[400]),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),

                ),
                child: TextField(
                  controller: nameHolder1,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person,color: Colors.pink[900],),
                    hintText: "Name",
                    hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),


                  ),

                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),

                ),
                child: TextField(
                  maxLines: 5,
                  controller: nameHolder2,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on,color: Colors.pink[900],),
                    hintText: "Address",
                    hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),



                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),

                ),
                child: TextField(
                  controller: nameHolder3,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone,color: Colors.pink[900],),
                    hintText: "Phone No",
                    hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),


                  ),

                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 50,
              width: 200,
              child: InkWell(
                onTap: (){
                  createRecord(nameHolder1.text, nameHolder2.text, nameHolder3.text);
                  clearTextInput();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.amberAccent[100],
                  shadowColor: Colors.red,
                  child: Center(child: Text('Update Details',style: GoogleFonts.raleway(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),)),
                  elevation: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
