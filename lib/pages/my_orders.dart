
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class My_Orders extends StatefulWidget {
  @override
  _My_OrdersState createState() => _My_OrdersState();
}

class _My_OrdersState extends State<My_Orders> {
  var prod;
  var cat_name;
  var rate=1;
  void del_change(var timestamp,var user2,var a,var b) async{
    final snapShot = await FirebaseFirestore.instance.collection('orders').doc("$user2").collection("Items").doc("$timestamp").get();
    final snapShot2 = await FirebaseFirestore.instance.collection('my_orders').doc("${user.uid}").collection("Items").doc("$timestamp").get();

      if(snapShot.data()['shifted']){
        await databaseReference.collection("orders")
            .doc("$user2")
            .collection("Items")
            .doc("$timestamp")
            .update({
          'delivered': true ,

        });


        await databaseReference.collection("my_orders")
            .doc("${user.uid}")
            .collection("Items")
            .doc("$timestamp")
            .update({
          'delivered': true ,

        });
      }









  }

  void rated(var time,var category,var shop_hash,var rate)async{
    final snapShot = await FirebaseFirestore.instance.collection('categories').doc('$category').collection("products").doc("$shop_hash").get();
    var rating=snapShot.data()['rating']+rate;
    var rating_count=snapShot.data()['rating_count']+1;
    var actual=(rating/rating_count).floor();
    print(actual);
    await databaseReference.collection("categories")
        .doc('$category')
        .collection("products")
        .doc("$shop_hash")
        .update({
      'rating': rating ,
      'rating_count': rating_count ,
      'rating_final': actual ,

    });


    await databaseReference.collection("my_orders")
        .doc("${user.uid}")
        .collection("Items")
        .doc("$time")
        .update({
      'rating': rating ,
      'rating_count': rating_count ,
      'rating_final': actual ,
      'rated': true ,

    });
  }

  void provide(hash,category){
    Navigator.pushNamed(context, "/product_info",arguments: {
      "Uid":hash,
      "category":category
    });
  }
  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;

  void Remove (var hash) async {
    await databaseReference.collection("Wish")
        .doc("${user.uid}").collection("Items").doc("$hash")
        .delete();
  }
  var dash;

  Future<bool> check(var hash) async{
    final snapShot = await FirebaseFirestore.instance.collection('Wish').doc("${user.uid}").collection("Items").doc("$hash").get();
    print(snapShot.exists);
    if(snapShot.exists){
      setState(() {
        dash=true;
      });
      return (true);
    }
    else{
      setState(() {
        dash=false;
      });
      return (false);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("my_orders").doc("${user.uid}").collection("Items").snapshots(),

          builder: (context,snapshot){
            if(snapshot.hasData){


              return ListView.builder(
                  physics: BouncingScrollPhysics(),

                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
//                  DocumentSnapshot documentSnapshot2=snapshot.data.documents[index+1];
                    return StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("categories").doc(documentSnapshot["category"]).collection("products").doc(documentSnapshot["shop_hash"]).snapshots(),
                          builder: (context,snapshot) {
                          if (snapshot.hasData) {
                          DocumentSnapshot documentSnapshot2 = snapshot.data;
                           return Column(
                            children: [
                            Row(
                            children: [
                              Flexible(
                                child: Container(
                                  height: 400,
                                  child: Card(
                                    elevation: 2,
                                    child: Row(
                                      children: [
                                        Image.network(documentSnapshot["Image_url"],width: 160,),
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
                                                  child: Row(
                                                    children: [
                                                      if(documentSnapshot2["rating_final"]==0)Row(
                                                        children: [
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                        ],
                                                      ),
                                                      if(documentSnapshot2["rating_final"]==1)Row(
                                                        children: [
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                        ],
                                                      ),if(documentSnapshot2["rating_final"]==2)Row(
                                                        children: [
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                        ],
                                                      ),if(documentSnapshot2["rating_final"]==3)Row(
                                                        children: [
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                        ],
                                                      ),if(documentSnapshot2["rating_final"]==4)Row(
                                                        children: [
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                        ],
                                                      ),if(documentSnapshot2["rating_final"]==5)Row(
                                                        children: [
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                          Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                        ],
                                                      ),

                                                      Text("  ("),
                                                      Text(documentSnapshot["rating_count"].toString()),
                                                      Text(")"),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    children: [
                                                      Text("₹",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold),),
                                                      Text((double.parse(documentSnapshot["price"].toString())-double.parse(documentSnapshot["Discount"].toString())).toString(),style: GoogleFonts.lato(fontSize: 18,color: Colors.red[900],fontWeight: FontWeight.bold),),
                                                      Text("  "),
                                                      Text(documentSnapshot["price"].toString(), style: GoogleFonts.lato(fontSize:18,decoration: TextDecoration.lineThrough)),

                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    children: [
                                                      Text("Save ₹"),
                                                      Text(documentSnapshot["Discount"].toString()),
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
                                                        child: Text("Order Confirmed",
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
                                                        child: Text("Order pending",
                                                          style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                        ),
                                                      ),
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
                                                        child: Text("Order shifted",
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
                                                        child: Text("Not Shifted",
                                                          style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                        ),
                                                      ),
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
                                                  child: RaisedButton(
                                                    onPressed: (){
                                                      del_change(documentSnapshot['Timestamp'],documentSnapshot['shop_id'],documentSnapshot['delivered'],documentSnapshot['shifted']);
                                                    },
                                                    color:Colors.red[200],
                                                    child: Center(
                                                      child: Text("Order delivered",
                                                        style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                documentSnapshot['rated']?Container(


                                                )
                                                    :Container(
                                                  width: 320,
                                                  child: RaisedButton(
                                                    onPressed: (){
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Center(child: Text("Rate The Product!!!",style: GoogleFonts.zillaSlab(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.green[400]),)),
                                                              content: Padding(
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
                                                                      Icon(Icons.rate_review),
                                                                      SizedBox(width: 10,),
                                                                      DropdownButtonHideUnderline(
                                                                        child: DropdownButton(
                                                                            value: rate,
                                                                            items: [

                                                                              DropdownMenuItem(
                                                                                child: Text("1",style: TextStyle(fontSize: 17,color: Colors.black)),
                                                                                value: 1,

                                                                              ),
                                                                              DropdownMenuItem(
                                                                                  child: Text("2",style: TextStyle(fontSize: 17,color: Colors.black)),
                                                                                  value: 2
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                  child: Text("3",style: TextStyle(fontSize: 17,color: Colors.black)),
                                                                                  value: 3
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                  child: Text("4",style: TextStyle(fontSize: 17,color: Colors.black)),
                                                                                  value: 4
                                                                              ),DropdownMenuItem(
                                                                                  child: Text("5",style: TextStyle(fontSize: 17,color: Colors.black)),
                                                                                  value: 5

                                                                              )],
                                                                            onChanged: (value) {
                                                                              setState(() {
                                                                                rate=value;
                                                                              });
                                                                            }),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                FlatButton(
                                                                  child: Text(" Rate ",style: GoogleFonts.zillaSlab(fontSize: 22,fontWeight: FontWeight.bold),),
                                                                  onPressed: () {
                                                                    rated(documentSnapshot['Timestamp'],documentSnapshot['category'],documentSnapshot['shop_hash'],rate);
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          });

                                                    },
                                                    color:Colors.amber[500],
                                                    child: Center(
                                                      child: Text("Rate Order",
                                                        style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),
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
                          ),





                        ],
                      );}}
                    );


                  }


              );
            }
            if (!snapshot.hasData){
              print('test phrase');
              return Text("");
            }

          },

        ),
      ),
    );
  }
}
