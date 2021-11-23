
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  var prod;
  var cat_name;

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

  void adddetails(var name,var quantity,var price,var img_url,var timestamp,var disc,var brand,var shop_hash,var rating,var rating_count,var shop_id,var shopname,var rating_final) async{

    final snapShot = await FirebaseFirestore.instance.collection('Wish').doc("${user.uid}").collection("Items").doc("$shop_hash").get();

    if(snapShot.exists){
      await databaseReference.collection("Wish")
          .doc("${user.uid}").collection("Items").doc("$shop_hash")
          .delete();
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0,0,0,400),
              child: AlertDialog(
                backgroundColor: Colors.red[500],
                title: Center(child: Row(
                  children: [
                    Icon(Icons.cancel,color: Colors.white,),
                    SizedBox(width: 8,),
                    Text('Removed Sucessfully',style:GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
                  ],
                )),
              ),
            );
          });
    }
    else{
      await databaseReference.collection("Wish")
          .doc("${user.uid}").collection("Items").doc("$shop_hash")
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
        "category":cat_name,
        "rating_final":rating_final,

      });
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0,0,0,400),
              child: AlertDialog(
                backgroundColor: Colors.greenAccent[200],
                title: Center(child: Row(
                  children: [
                    Icon(Icons.thumb_up),
                    SizedBox(width: 8,),
                    Text('Added Sucessfully',style:GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900])),
                  ],
                )),
              ),
            );
          });
    }

  }

  void Remove2(var shop_hash,var category) async {
    await databaseReference.collection("All_products")
        .doc("$shop_hash")
        .delete();

    await databaseReference.collection("categories")
        .doc("${category}").collection("products").doc("$shop_hash")
        .delete();
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
          stream: FirebaseFirestore.instance.collection("All_products").snapshots(),

          builder: (context,snapshot){
            if(snapshot.hasData){


              return ListView.builder(
                  physics: BouncingScrollPhysics(),

                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
//                  DocumentSnapshot documentSnapshot2=snapshot.data.documents[index+1];
                    return user.uid==documentSnapshot['shop_id']?Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: 250,
                            child: Card(
                              elevation: 2,
                              child: Row(
                                children: [
                                  Image.network(documentSnapshot["Image_url"],width: 200,),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on,color: Colors.pink[900],size: 18,),
                                                  SizedBox(width: 3,),
                                                  Text(documentSnapshot["Shop_name"],style:GoogleFonts.raleway(fontSize: 12,fontWeight: FontWeight.bold))
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Icon(Icons.favorite_border,color: Colors.red[900],),


                                                ],
                                              ),
//                                            SizedBox(width: 1,)
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              if(documentSnapshot["Name"].toString().length>50) Text("${documentSnapshot["Name"].toString().substring(0,49)}...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold)),
                                              if(documentSnapshot["Name"].toString().length<=50) Text(documentSnapshot["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                if(documentSnapshot["rating_final"]==0)Row(
                                                  children: [
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                  ],
                                                ),
                                                if(documentSnapshot["rating_final"]==1)Row(
                                                  children: [
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                  ],
                                                ),if(documentSnapshot["rating_final"]==2)Row(
                                                  children: [
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                  ],
                                                ),if(documentSnapshot["rating_final"]==3)Row(
                                                  children: [
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                  ],
                                                ),if(documentSnapshot["rating_final"]==4)Row(
                                                  children: [
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star,color: Colors.amber[900],size: 26,),
                                                    Icon(Icons.star_border,color: Colors.amber[900],size: 21,),
                                                  ],
                                                ),if(documentSnapshot["rating_final"]==5)Row(
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
                                          ), Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                Text("Remaining Quantity"),
                                                Text("   "+documentSnapshot["Quantity"].toString()),
                                              ],
                                            ),
                                          ),

                                          InkWell(
                                            onTap: (){
                                              Remove2(documentSnapshot["shop_hash"],documentSnapshot['category']);
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              color: Colors.amber[400],

                                              child: Center(child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.delete),
                                                  SizedBox(width: 2,),
                                                  Text('   Remove      ',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                                                ],
                                              )),
                                              elevation: 2,
                                            ),
                                          ),



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
                    ):SizedBox(height: 0,);


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
