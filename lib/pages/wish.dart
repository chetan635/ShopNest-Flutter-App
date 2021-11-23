
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wish extends StatefulWidget {
  @override
  _WishState createState() => _WishState();
}

class _WishState extends State<Wish> {
  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;
  void provide(hash,category){
    Navigator.pushNamed(context, "/product_info",arguments: {
      "Uid":hash,
      "category":category
    });
  }
  void adddetails(var shop_hash) async{

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
          stream: FirebaseFirestore.instance.collection("Wish").doc("${user.uid}").collection("Items").snapshots(),

          builder: (context,snapshot){
            if(snapshot.hasData){


              return ListView.builder(
                  physics: BouncingScrollPhysics(),

                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
//                  DocumentSnapshot documentSnapshot2=snapshot.data.documents[index+1];
                    return Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: 250,
                            child: InkWell(
                              onTap: (){
                                provide(documentSnapshot["shop_hash"],documentSnapshot["category"]);
                              },
                              child: Card(
                                elevation: 2,
                                child: Row(
                                  children: [
                                    Image.network(documentSnapshot["Image_url"],width: 200,),
                                    Flexible(
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
                                                  Text(documentSnapshot["shop_name"],style:GoogleFonts.raleway(fontSize: 12,fontWeight: FontWeight.bold))
                                                ],
                                              ),
                                              InkWell(
                                                  onTap: (){
                                                    adddetails(documentSnapshot["shop_hash"]);
                                                  },
                                                  child: Icon(Icons.favorite,color: Colors.red[900],)),
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
                                          )



                                        ],
                                      ),
                                    )
                                  ],
                                ),
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
            if (!snapshot.hasData){
              print('test phrase');
              return Text("");
            }

          },

        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        backgroundColor: Colors.grey[100],
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "/home");
                },
                child: new Icon(Icons.home,)),
            title: new Text('Home',
              style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,),),
          ),
          BottomNavigationBarItem(
            icon: InkWell(onTap: (){
              Navigator.pushNamed(context, "/wish");
            },child: new Icon(Icons.favorite,color: Colors.red[900],)),
            title: new Text('Wishlist',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: InkWell(onTap: (){
              Navigator.pushNamed(context, "/cart");
            },child: new Icon(Icons.shopping_cart)),
            title: new Text('Cart',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold)),
          ),

//            BottomNavigationBarItem(
//              icon: InkWell(onTap: (){
//                Navigator.pushNamed(context, "/Dashboard");
//              },child: new Icon(Icons.dashboard)),
//              title: new Text('Dashboard',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold)),
//            ),


        ],
      ),
    );
  }
}
