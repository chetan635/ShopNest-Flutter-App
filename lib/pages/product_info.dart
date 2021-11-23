import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product_Info extends StatefulWidget {
  @override
  _Product_InfoState createState() => _Product_InfoState();
}

class _Product_InfoState extends State<Product_Info> {
  var prod;
  var prod_uid;
  var category;
  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;
  void adddetails(var name,var quantity,var price,var img_url,var timestamp,var disc,var brand,var shop_hash,var rating,var rating_count,var shop_id,var shopname,var rating_final) async{




    await databaseReference.collection("Cart")
        .doc("${user.uid}").collection("Items").doc("$timestamp")
        .set({
      "Name":name,
      "Quantity":quantity,
      "price":price,
      "Image_url":img_url,
      "Timestamp":timestamp,
      "shop_id":shop_id,
      "shop_name":shopname,
      "shop_hash":shop_hash,
      "Discount":disc,
      "Brand":brand,
      "rating":rating,
      "rating_count":rating_count,
      "category":category,
      "rating_final":rating_final,

    });
  }


  @override
  Widget build(BuildContext context) {
    prod=ModalRoute.of(context).settings.arguments;
    prod_uid=prod['Uid'];
    category=prod['category'];
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
            stream: FirebaseFirestore.instance.collection("categories").doc("$category").collection("products").doc("$prod_uid").snapshots(),

            builder: (context,snapshot){
              if(snapshot.hasData){
                DocumentSnapshot documentSnapshot=snapshot.data;
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.pink[900],size: 18,),
                                SizedBox(width: 3,),
                                Text(documentSnapshot["Shop_name"],style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold))
                              ],
                            ),
                            Icon(Icons.favorite_border,color: Colors.red,size: 25,),
//                                            SizedBox(width: 1,)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(documentSnapshot["brand"],style:GoogleFonts.raleway(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.red[900])),
                        SizedBox(height: 10,),
                        Text(documentSnapshot["Name"],style:GoogleFonts.raleway(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blueGrey[800])),
                        Column(
                          children: [
                            Center(child: Image.network(documentSnapshot["Image_url"],width: 300,)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if(documentSnapshot["rating_final"]==0)Row(
                                  children: [
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                  ],
                                ),
                                if(documentSnapshot["rating_final"]==1)Row(
                                  children: [
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                  ],
                                ),if(documentSnapshot["rating_final"]==2)Row(
                                  children: [
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                  ],
                                ),if(documentSnapshot["rating_final"]==3)Row(
                                  children: [
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                  ],
                                ),if(documentSnapshot["rating_final"]==4)Row(
                                  children: [
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star_border,color: Colors.amber[900],size: 24,),
                                  ],
                                ),if(documentSnapshot["rating_final"]==5)Row(
                                  children: [
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                    Icon(Icons.star,color: Colors.amber[900],size: 30,),
                                  ],
                                ),

                                Text("  ("),
                                Text(documentSnapshot["rating_count"].toString()),
                                Text(")"),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("MRP : ",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold,fontSize: 18),),
                                      Text("₹",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold,fontSize: 20),),
                                      SizedBox(width: 5,),
                                      Text((double.parse(documentSnapshot["price"].toString())-double.parse(documentSnapshot["Discount"].toString())).toString(),style: GoogleFonts.lato(fontSize: 26,color: Colors.red[900],fontWeight: FontWeight.bold),),


                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      SizedBox(width: 55,),
                                      Text("₹",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 18),),
                                      Text(documentSnapshot["price"].toString(), style: GoogleFonts.lato(fontSize:15,decoration: TextDecoration.lineThrough,)),
                                      SizedBox(width: 10,),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Text("Save ₹ ",style:GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[400])),
                                            Text(documentSnapshot["Discount"].toString(),style:GoogleFonts.raleway(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.red[900])),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Free Delivery !!!",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.blueGrey[500])),
                                  SizedBox(height: 5,),
                                  Text("Delivery Within 4 Days ...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.blueGrey[500]))

                                ],
                              ),
                            ),

                          ],
                        ),
                        Container(
                          width: double.infinity,

                          child: Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Description : ",style:GoogleFonts.raleway(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.pink)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(documentSnapshot["Desc"],style:GoogleFonts.raleway(fontSize: 17,letterSpacing: 0.4,wordSpacing: 4),),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0,0,12,0),
                          child: Row(
                            children: [
                              Text("Totel : ",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold,fontSize: 22),),
                              Text("₹",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold,fontSize: 22),),
                              SizedBox(width: 5,),
                              Text((double.parse(documentSnapshot["price"].toString())-double.parse(documentSnapshot["Discount"].toString())).toString(),style: GoogleFonts.lato(fontSize: 22,color: Colors.red[900],fontWeight: FontWeight.bold),),


                            ],
                          ),
                        ),
                        if(int.parse(documentSnapshot["Quantity"])>0)Padding(
                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                          child: Text("In Stock",style:GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.green[700])),
                        ),
                        if(int.parse(documentSnapshot["Quantity"])==0)Padding(
                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                          child: Text("Out Of Stock",style:GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.pink[900])),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                          child: Text("Sold by ${documentSnapshot["Shop_name"]} and fulfiled by ShopNest.",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey)),
                          height: 60,
                          child :InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 300,
                                    color: Colors.grey[100],
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
//                                        mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(height: 10,),
                                            Text(documentSnapshot["brand"],style:GoogleFonts.raleway(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.red[900])),
                                            SizedBox(height: 10,),
                                            Text(documentSnapshot["Name"],style:GoogleFonts.raleway(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blueGrey[800])),
                                            SizedBox(height: 10,),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(12.0,0,12,0),
                                              child: Row(
                                                children: [
                                                  Text("Totel : ",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold,fontSize: 22),),
                                                  Text("₹",style: TextStyle(color: Colors.red[900],fontWeight: FontWeight.bold,fontSize: 22),),
                                                  SizedBox(width: 5,),
                                                  Text((double.parse(documentSnapshot["price"].toString())-double.parse(documentSnapshot["Discount"].toString())).toString(),style: GoogleFonts.lato(fontSize: 22,color: Colors.red[900],fontWeight: FontWeight.bold),),


                                                ],
                                              ),
                                            ),
                                            if(int.parse(documentSnapshot["Quantity"])>0)Padding(
                                              padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                              child: Text("In Stock",style:GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.green[700])),
                                            ),
                                            if(int.parse(documentSnapshot["Quantity"])==0)Padding(
                                              padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                              child: Text("Out Of Stock",style:GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.pink[900])),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                              child: Text("Sold by ${documentSnapshot["Shop_name"]} and fulfiled by ShopNest.",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                                            ),
                                            SizedBox(height: 20,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                      color: Colors.grey[100],
                                                      border: Border.all(color: Colors.grey)),
                                                  height: 45,
                                                  child :InkWell(
                                                    onTap:(){
                                                      Navigator.pop(context);
                                                    },
                                                    child: Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      color: Colors.amber[400],

                                                      child: Center(child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.cancel),
                                                          SizedBox(width: 2,),
                                                          Text('   Cancel      ',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                                                        ],
                                                      )),
                                                      elevation: 2,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                      color: Colors.grey[100],
                                                      border: Border.all(color: Colors.grey)),
                                                  height: 45,
                                                  child :InkWell(
                                                    onTap:(){
                                                      adddetails(documentSnapshot["Name"],documentSnapshot["Quantity"],documentSnapshot["price"],documentSnapshot["Image_url"],DateTime.now().microsecondsSinceEpoch,documentSnapshot["Discount"],documentSnapshot["brand"],documentSnapshot["shop_hash"],documentSnapshot["rating"],documentSnapshot["rating_count"],documentSnapshot["shop_id"],documentSnapshot["Shop_name"],documentSnapshot['rating_final']);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      color: Colors.amber[300],

                                                      child: Center(child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.shopping_cart),
                                                          SizedBox(width: 2,),
                                                          Text('Add to cart',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                                                        ],
                                                      )),
                                                      elevation: 2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: documentSnapshot['Quantity']!='0'?Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.amber[800],

                              child: Center(child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart),
                                  SizedBox(width: 2,),
                                  Text('Add to Cart',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                                ],
                              )),
                              elevation: 2,
                            ):SizedBox(height: 0,)
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey)),
                          height: 60,
                          child :InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, '/cart');
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.amber[300],

                              child: Center(child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart),
                                  SizedBox(width: 2,),
                                  Text('Go to Cart',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                                ],
                              )),
                              elevation: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 25,),
                      ],
                    ),
                  ),
                );

              }
            },
          ),
        )
    );
  }
}


