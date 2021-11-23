import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final nameHolder1 = TextEditingController();
  final nameHolder2 = TextEditingController();
  final nameHolder3 = TextEditingController();
  final nameHolder4 = TextEditingController();
  final nameHolder5 = TextEditingController();
  final nameHolder6 = TextEditingController();
  final nameHolder7 = TextEditingController();
  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;


  void con_change(var timestamp,var user2) async{
    final snapShot = await FirebaseFirestore.instance.collection('orders').doc("${user.uid}").collection("Items").doc("$timestamp").get();
    final snapShot2 = await FirebaseFirestore.instance.collection('my_orders').doc("$user").collection("Items").doc("$timestamp").get();

    await databaseReference.collection("orders")
        .doc("${user.uid}")
        .collection("Items")
        .doc("$timestamp")
        .update({
      'confirmed': true ,

    });


      await databaseReference.collection("my_orders")
          .doc("$user2")
          .collection("Items")
          .doc("$timestamp")
          .update({
        'confirmed': true ,

      });


  }
  void shi_change(var timestamp,var user2) async{
    final snapShot = await FirebaseFirestore.instance.collection('orders').doc("${user.uid}").collection("Items").doc("$timestamp").get();
    final snapShot2 = await FirebaseFirestore.instance.collection('my_orders').doc("$user").collection("Items").doc("$timestamp").get();

      await databaseReference.collection("orders")
          .doc("${user.uid}")
          .collection("Items")
          .doc("$timestamp")
          .update({
        'shifted': true ,

      });


      await databaseReference.collection("my_orders")
          .doc("$user2")
          .collection("Items")
          .doc("$timestamp")
          .update({
        'shifted': true ,

      });







  }



  clearTextInput(){

    nameHolder1.clear();
    nameHolder2.clear();
    nameHolder3.clear();
    nameHolder4.clear();
    nameHolder5.clear();
    nameHolder6.clear();
    nameHolder7.clear();

  }
  var category="Fashion";
  var Name;
  var Desc;
  var Quantity;
  var Image_url;
  var Price;
  var timestamp;
  void createRecord (var Name, var Desc , var Quantity, var Image_url,var Price,var timestamp,var discount,var brand) async {
    var shop_hash=timestamp.toString()+(user.uid).toString();
    final snapShot = await FirebaseFirestore.instance.collection('business_accounts').doc("${user.uid}").get();
    var gg;
    gg=snapShot.data()["Shap_name"];
      await databaseReference.collection("categories")
          .doc("$category")
          .collection("products")
          .doc("$shop_hash")
          .set({
        'Name': Name ,
        'Desc': Desc,
        'Quantity': Quantity,
        'Image_url': Image_url,
        'price': Price,
        "Timestamp":timestamp,
        "shop_id":"${user.uid}",
        "Shop_name":gg,
        "shop_hash":shop_hash,
        "Discount":discount,
        "brand":brand,
        "rating":0,
        "rating_count":0,
        "rating_final":0,
        "category":category,
      });
      await databaseReference.collection("All_products")
          .doc("$shop_hash")
          .set({
        'Name': Name ,
        'Desc': Desc,
        'Quantity': Quantity,
        'Image_url': Image_url,
        'price': Price,
        "Timestamp":timestamp,
        "shop_id":"${user.uid}",
        "Shop_name":gg,
        "shop_hash":shop_hash,
        "Discount":discount,
        "brand":brand,
        "rating":0,
        "rating_count":0,
        "rating_final":0,
        "category":category,
      });




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
            InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/edit');
                },
                child: Icon(Icons.edit,size: 27,)),
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
              padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
              child: Container(
                height: 55,
                width: double.infinity,
                child: Card(
                  color: Colors.grey[100],
                  elevation: 2,
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome : ",style: TextStyle(color: Colors.amber,fontSize: 30,fontWeight: FontWeight.bold),),
                      Text("Shop",style: TextStyle(color: Colors.pink,fontSize: 30,fontWeight: FontWeight.bold),),
                    ],
                  )),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Add Following Details To add Item ....',style: GoogleFonts.raleway(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueGrey[400]),),
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
                        prefixIcon: Icon(Icons.card_giftcard,color: Colors.black,),
                        hintText: "Name Of product",
                        hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),


                      ),
                      onChanged: (value){
                        setState(() {
                          Name=value;
                          value=" ";
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 500,
                    height: 60,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      children: [
                        Icon(Icons.category),
                        SizedBox(width: 10,),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                              value: category,
                              items: [

                                DropdownMenuItem(
                                  child: Text("Fashion",style: TextStyle(fontSize: 17,color: Colors.black)),
                                  value: "Fashion",

                                ),
                                DropdownMenuItem(
                                    child: Text("Mobile",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Mobile"
                                ),
                                DropdownMenuItem(
                                    child: Text("Electronics",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Electronics"
                                ),
                                DropdownMenuItem(
                                    child: Text("Home",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Home"
                                ),DropdownMenuItem(
                                    child: Text("Appliances",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Appliances"
                                ),DropdownMenuItem(
                                    child: Text("Beauty",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Beauty"
                                ),DropdownMenuItem(
                                    child: Text("Toys & baby",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Toys & baby"
                                ),DropdownMenuItem(
                                    child: Text("Sports",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Sports"
                                ),DropdownMenuItem(
                                    child: Text("Furniture",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Furniture"
                                ),DropdownMenuItem(
                                    child: Text("Food & more",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Food & more"
                                ),DropdownMenuItem(
                                    child: Text("Stationary",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Stationary"
                                ),DropdownMenuItem(
                                    child: Text("Artifacts",style: TextStyle(fontSize: 17,color: Colors.black)),
                                    value: "Artifacts"
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                    category=value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0),

                    ),
                    child: TextField(
                      controller: nameHolder2,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description,color: Colors.black,),
                        hintText: "Description of Product",
                        hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),

                      ),
                      onChanged: (value){
                        setState(() {
                          Desc=value;
                          value=" ";
                        });
                      },
                    ),
                  ),
                ),
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
                        prefixIcon: Icon(Icons.add_box,color: Colors.black,),
                        hintText: "Quantity",
                        hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),

                      ),
                      onChanged: (value){
                        setState(() {
                          Quantity=value;
                          value=" ";
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0),

                    ),
                    child: TextField(
                      controller: nameHolder7,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.bookmark,color: Colors.black,),
                        hintText: "Brand name",
                        hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),

                      ),

                    ),
                  ),
                ),Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0),

                    ),
                    child: TextField(
                      controller: nameHolder4,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.image,color: Colors.black,),
                        hintText: "Image Url",
                        hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),

                      ),
                      onChanged: (value){
                        setState(() {
                          Image_url=value;
                          value=" ";
                        });
                      },
                    ),
                  ),
                ),Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0),

                    ),
                    child: TextField(
                      controller: nameHolder6,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.content_cut,color: Colors.black,),
                        hintText: "Discount",
                        hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),

                      ),

                    ),
                  ),
                ),Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0),

                    ),
                    child: TextField(
                      controller: nameHolder5,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.monetization_on,color: Colors.black,),
                        hintText: "Price",
                        hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),

                      ),

                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 200,
                  child: InkWell(
                    onTap: (){
                      createRecord(nameHolder1.text,  nameHolder2.text , nameHolder3.text,  nameHolder4.text, nameHolder5.text,DateTime.now().microsecondsSinceEpoch,nameHolder6.text,nameHolder7.text);
                      clearTextInput();

                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.amberAccent[100],
                      shadowColor: Colors.red,
                      child: Center(child: Text('Add Item',style: GoogleFonts.raleway(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),)),
                      elevation: 8,
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("orders").doc("${user.uid}").collection("Items").snapshots(),

                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),

                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
                          return Row(
                            children: [
                              Flexible(
                                child: Container(
                                  height: 580,
                                  child: Card(
                                    elevation: 2,
                                    child: Row(
                                      children: [
                                        Image.network(documentSnapshot["Image_url"],width: 150,),
                                        Flexible(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 15,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [


//                                            SizedBox(width: 1,)
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(documentSnapshot["product_name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 8,),
                                                      Text(documentSnapshot["price"].toString(), style: GoogleFonts.lato(fontSize:18,fontWeight: FontWeight.bold)),
                                                      SizedBox(height: 8,),
                                                      Text("Recipent", style: GoogleFonts.lato(fontSize:25,fontWeight: FontWeight.bold,color: Colors.red)),
                                                      SizedBox(height: 8,),
                                                      Text(documentSnapshot["user_name"].toString(), style: GoogleFonts.lato(fontSize:18,fontWeight: FontWeight.bold)),
                                                      SizedBox(height: 8,),
                                                      Text("Phone No", style: GoogleFonts.lato(fontSize:25,fontWeight: FontWeight.bold,color: Colors.green[400])),
                                                      SizedBox(height: 8,),
                                                      Text( documentSnapshot["phone"].toString(), style: GoogleFonts.lato(fontSize:18,fontWeight: FontWeight.bold)),
                                                      SizedBox(height: 8,),
                                                      Text("Address", style: GoogleFonts.lato(fontSize:25,fontWeight: FontWeight.bold,color: Colors.pink)),
                                                      SizedBox(height: 8,),
                                                      Text(documentSnapshot["address"].toString(), style: GoogleFonts.lato(fontSize:18,fontWeight: FontWeight.bold)),
                                                      SizedBox(height: 8,),

                                                    ],
                                                  ),
                                                ),


                                                documentSnapshot['confirmed']?Container(
                                                  width: 320,
                                                  child: Container(
                                                    height: 45,
                                                    child: Card(
                                                      color:Colors.green[200],
                                                      child: Center(
                                                        child: Text("Confirm Order",
                                                          style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ):Container(
                                                  width: 320,
                                                  child: RaisedButton(
                                                    onPressed: (){
                                                        con_change(documentSnapshot['Timestamp'],documentSnapshot['user_id']);
                                                    },
                                                    color:Colors.red[200],
                                                    child: Text("Confirm Order",
                                                      style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                    ),
                                                  ),
                                                ),
                                                documentSnapshot['shifted']?Container(
                                                  width: 320,
                                                  child: Container(
                                                    height: 45,
                                                    child: Card(
                                                      color:Colors.green[200],
                                                      child: Center(
                                                        child: Text("Order Shifted",
                                                          style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ):Container(
                                                  width: 320,
                                                  child: RaisedButton(
                                                    onPressed: (){
                                                        shi_change(documentSnapshot['Timestamp'],documentSnapshot['user_id']);
                                                    },
                                                    color:Colors.red[200],
                                                    child: Text("Shift Order",
                                                      style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                    ),
                                                  ),
                                                ),




                                                documentSnapshot['delivered']?Container(
                                                  width: 320,
                                                  child: Container(
                                                    height: 45,
                                                    child: Card(
                                                      color:Colors.green[200],
                                                      child: Center(
                                                        child: Text("Order delivered",
                                                          style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ):Container(
                                                  width: 320,
                                                  child: Container(
                                                    height: 45,
                                                    child: Card(
                                                      color:Colors.red[200],
                                                      child: Center(
                                                        child: Text("Order delivered",
                                                          style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )

                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
//                      Flexible(
//                        child: Card(
//                          child: Text(documentSnapshot2["Name"]),
//                        ),
//                      )
                            ],
                          );
                        }
                    );
                  }
                }
            )
          ],
        ),
      ),




      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        backgroundColor: Colors.grey[100],
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "/home");
                },
                child: new Icon(Icons.home,)),
            title: new Text('Home',
              style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold),),
          ),
          BottomNavigationBarItem(
            icon: InkWell(onTap: (){
              Navigator.pushNamed(context, "/wish");
            },child: new Icon(Icons.favorite)),
            title: new Text('Wish List',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold)),
          ),
          BottomNavigationBarItem(
            icon: InkWell(onTap: (){
              Navigator.pushNamed(context, "/cart");
            },child: new Icon(Icons.shopping_cart)),
            title: new Text('Cart',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold)),
          ),
          BottomNavigationBarItem(
            icon: InkWell(onTap: (){
              Navigator.pushNamed(context, "/DashBoard");
            },child: new Icon(Icons.dashboard,color: Colors.red[900])),
            title: new Text('DashBoard',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
          ),


        ],
      ),
    );
  }
}
