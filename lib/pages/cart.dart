import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';



class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;

  var timestamp;
  var shop_id;
  var name2;
  var Image_url;
  var price;
  var shop_name;
  var Discount;
  var rating;
  var rating_count;
  var category;
  var shop_hash;
  var rating_final;

  void Remove (var time) async {
      await databaseReference.collection("Cart")
        .doc("${user.uid}").collection("Items").doc("$time")
        .delete();
  }
  var address;
  var name;
  var Phone;
  void ADD() async{
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();
    if(snapShot.exists){
      setState(() {
        address=snapShot.data()['Address'];
       name=snapShot.data()['Name'];
       Phone=snapShot.data()['Phone_No'];
      });
    }

  }

//  deleting after payment
void del() async{
  final snapShot = await FirebaseFirestore.instance.collection('Cart').doc("${user.uid}").collection("Items").doc('$timestamp').get();
  if(snapShot.exists){
    await databaseReference.collection("Cart")
        .doc("${user.uid}").collection("Items").doc("$timestamp")
        .delete();
  }
}

//After order recived
  void shop_owner(var Timestamp2) async{

      await databaseReference.collection("orders")
          .doc("${shop_id}")
          .collection("Items")
          .doc("$Timestamp2")
          .set({
        'product_name': name2 ,
        'user_name':name,
        'phone':Phone,
        'address':address,
        'Image_url': Image_url,
        'price': price,
        "Timestamp":Timestamp2,
        "shop_id":"$shop_id",
        'user_id':"${user.uid}",
        'confirmed':false,
        'shifted':false,
        'delivered':false,
      });

      await databaseReference.collection("my_orders")
          .doc("${user.uid}")
          .collection("Items")
          .doc("$Timestamp2")
          .set({
        'product_name': name2 ,
        'phone':Phone,
        'address':address,
        'Image_url': Image_url,
        'price': price,
        "Timestamp":Timestamp2,
        "shop_id":"$shop_id",
        "rating":int.parse("$rating"),
        "rating_count":int.parse("$rating_count"),
        "Discount":"$Discount",
        "rated":false,
        "shop_hash":shop_hash,
        "category":category,
        'confirmed':false,
        'shifted':false,
        'delivered':false,
        'rating_final':rating_final,

      });
  }
//  Payment gateway
  Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();





  void openCheckout(var amount,var name,var Phone){
    var options = {
      "key" : "rzp_test_GX6qClzYjXFCyC",
      "amount" :((amount)*100),
      "name" : "ShopNest",
      "description" : name.toString(),
      "prefill" : {
        "contact" : Phone.toString(),
        "email" : "${user.email}"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);

    }catch(e){
      print(e.toString());
    }

  }
  void quantity()async{
    final snapShot = await FirebaseFirestore.instance.collection('categories').doc("$category").collection("products").doc('$shop_hash').get();
    var quantity=int.parse(snapShot.data()['Quantity']);
    setState(() {
      quantity=quantity-1;
    });
    await databaseReference.collection("categories")
        .doc("$category")
        .collection("products")
        .doc("$shop_hash")
        .update({
      'Quantity':quantity.toString(),
    });

  }

  void _handlerPaymentSuccess(PaymentSuccessResponse response){
    shop_owner(DateTime.now().microsecondsSinceEpoch);
    del();
    quantity();
    Navigator.pushNamed(context, "/home");
    Toast.show("Pament success", context);
  }

  void handlerErrorFailure(){
    print("Pament error");
    Toast.show("Pament error", context);
  }

  void handlerExternalWallet(){
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ADD();
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
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
                Text('My',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.pink,

                ),),
                Text('Cart',style: TextStyle(
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
          stream: FirebaseFirestore.instance.collection("Cart").doc("${user.uid}").collection("Items").snapshots(),

          builder: (context,snapshot){
            if(snapshot.hasData){


              return ListView.builder(

                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
//                  DocumentSnapshot documentSnapshot2=snapshot.data.documents[index+1];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.white,
                                    height: 350,
                                    child: Center(
                                      child: Card(
                                        semanticContainer: true,
                                        elevation:2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [

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
                                                                Text("By "+documentSnapshot["shop_name"],style:GoogleFonts.raleway(fontSize: 12,fontWeight: FontWeight.bold))
                                                              ],
                                                            ),

//                                            SizedBox(width: 1,)
                                                          ],
                                                        ),
                                                        if((documentSnapshot["Name"].toString()).length<=50) Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child:  Text(documentSnapshot["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                                        ),
                                                        if((documentSnapshot["Name"].toString()).length>50) Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child:  Text(documentSnapshot["Name"].substring(0,49)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
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
                                                  ),
                                                  Image.network(documentSnapshot["Image_url"],width: 120,),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.0),
                                                        color: Colors.grey[100],
                                                        border: Border.all(color: Colors.grey)),
                                                    height: 42,
                                                    child :InkWell(
                                                      onTap:(){
                                                        Remove(documentSnapshot['Timestamp']);
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
                                                            Text('   Remove      ',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                                                          ],
                                                        )),
                                                        elevation: 2,
                                                      ),
                                                    ),
                                                  ),Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.0),
                                                        color: Colors.grey[100],
                                                        border: Border.all(color: Colors.grey)),
                                                    height: 42,
                                                    child :InkWell(
                                                      onTap: () {
                                                        showModalBottomSheet<void>(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return SingleChildScrollView(
                                                              child: Container(
                                                                height: 600,
                                                                color: Colors.grey[100],
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(15.0),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                        mainAxisSize: MainAxisSize.min,
                                                                      children: <Widget>[
                                                                        SizedBox(height: 10,),
                                                                        Text(documentSnapshot["Brand"],style:GoogleFonts.raleway(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.red[900])),
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
                                                                          child: Text("Sold by ${documentSnapshot["shop_name"]} and fulfiled by ShopNest.",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                                                                        ),
                                                                        SizedBox(height: 20,),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                                                          child: Text("Delivered to : ",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                                                          child: Text("$name",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                                                                        ),
                                                                        SizedBox(height: 20,),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                                                          child: Text("Contact Details : ",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                                                          child: Text("$Phone",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                                                                        ),
                                                                        SizedBox(height: 20,),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                                                          child: Text("TO Address : ",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(12,5,12,0),
                                                                          child: Text("$address",style:GoogleFonts.raleway(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blueGrey[700])),
                                                                        ),
                                                                        SizedBox(height: 20,),
                                                                        Column(
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
//                                                                                cash_on_delivery();
                                                                                },
                                                                                child: Card(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                  color: Colors.amber[400],

                                                                                  child: Center(child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
//                                                                                    Icon(Icons.attach_money),
                                                                                      SizedBox(width: 2,),
                                                                                      Text('Cash On Delivery ',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                                                                                    ],
                                                                                  )),
                                                                                  elevation: 2,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 20,),Container(
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15.0),
                                                                                  color: Colors.grey[100],
                                                                                  border: Border.all(color: Colors.grey)),
                                                                              height: 45,
                                                                              child :InkWell(
                                                                                onTap:(){
                                                                                  setState(() {
                                                                                    name2=documentSnapshot["Name"];
                                                                                    Image_url=documentSnapshot['Image_url'];
                                                                                    price=double.parse(documentSnapshot['price'])-double.parse(documentSnapshot['Discount']);
                                                                                    shop_id=documentSnapshot["shop_id"];
                                                                                    timestamp=documentSnapshot["Timestamp"];
                                                                                    shop_name=documentSnapshot["shop_name"];
                                                                                    rating=documentSnapshot["rating"];
                                                                                    rating_count=documentSnapshot["rating_count"];
                                                                                    Discount=documentSnapshot["Discount"];
                                                                                    category=documentSnapshot["category"];
                                                                                    shop_hash=documentSnapshot["shop_hash"];
                                                                                    rating_final=documentSnapshot["rating_final"];
                                                                                  });
                                                                                openCheckout(double.parse(documentSnapshot['price'])-double.parse(documentSnapshot['Discount']),documentSnapshot['Name'],Phone,);
                                                                                },
                                                                                child: Card(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                  color: Colors.amber[300],

                                                                                  child: Center(child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
//                                                                                    Icon(Icons.shopping_cart),
                                                                                      SizedBox(width: 2,),
                                                                                      Text('Rezorpay(Online) Payment',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
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
                                                              ),
                                                            );
                                                          },
                                                        );
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
                                                            Text('  Place Order    ',style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                                                          ],
                                                        )),
                                                        elevation: 2,
                                                      )
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
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
        currentIndex: 2,
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
            },child: new Icon(Icons.favorite,)),
            title: new Text('Wishlist',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,)),
          ),
          BottomNavigationBarItem(
            icon: InkWell(onTap: (){
              Navigator.pushNamed(context, "/cart");
            },child: new Icon(Icons.shopping_cart,color: Colors.red[900])),
            title: new Text('Cart',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
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
