

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;

   catName(var str){
    Navigator.pushNamed(context,'/products',arguments: {
      "Category":str,
    });
  }



    var desh=false;
    func() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('business_accounts').doc("${user.uid}").get();
    if(snapShot.exists){
      setState(() {
        desh=true;
      });

    }
    else{
      setState(() {
        desh=false;
      });
      return desh;
    }
  }

   void handleClick(String value) {
     switch (value) {
       case 'Logout':signOut();
       break;
       case 'Settings':Navigator.pushNamed(context, "/settings");
       break;
       case 'profile':showModalBottomSheet<void>(
         context: context,
         builder: (BuildContext context) {
           return Container(
             height: 380,
             child: SingleChildScrollView(
               child: StreamBuilder(
                 stream: FirebaseFirestore.instance.collection("users").doc("${user.uid}").snapshots(),

                 builder: (context,snapshot){
                   if(snapshot.hasData){
                     DocumentSnapshot documentSnapshot=snapshot.data;
                     return Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(15.0),
                           child: Row(
                             children: [
                               Text("Personal ",style: GoogleFonts.raleway(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.pink[900],decoration: TextDecoration.underline),),
                               Text("Profile",style: GoogleFonts.raleway(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.amber[900],decoration: TextDecoration.underline),),
                             ],
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(15.0),
                           child: Container(

                             width: 500,
                             height: 60,
                             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10.0),
                                 color: Colors.orange[900],
                                 border: Border.all(color: Colors.grey)),
                             child: Card(
                               elevation: 0.0,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10.0),
                               ),
                               child: Center(child: Text(documentSnapshot['Name'],style: GoogleFonts.raleway(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),),
                             ),
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(15.0),
                           child: Container(
                             width: 500,
                             height: 90,
                             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10.0),
                                 color: Colors.pink[900],
                                 border: Border.all(color: Colors.grey)),
                             child: Card(
                               elevation: 0.0,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10.0),
                               ),
                               child: Center(child: Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Text(documentSnapshot['Address'],style: GoogleFonts.raleway(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                               )),
                             ),
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(15.0),
                           child: Container(
                             width: 500,
                             height: 60,
                             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10.0),
                                 color: Colors.cyan[900],
                                 border: Border.all(color: Colors.grey)),
                             child: Card(
                               elevation: 0.0,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10.0),
                               ),
                               child: Center(child: Text(documentSnapshot['Phone_No'],style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),)),
                             ),
                           ),
                         )
                       ],
                     );

                   }
                 },
               ),
             ),
           );
         },
       );
       break;
     }
   }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => Container(
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
        child: new AlertDialog(
          title: new Text('Are you sure?',style: GoogleFonts.zillaSlab(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.pink[900]),),
          content: new Text('Do you want to exit an App',style: GoogleFonts.zillaSlab(fontSize: 20,color: Colors.pink[900]),),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO",style: GoogleFonts.zillaSlab(fontSize: 20,color: Colors.amber[900]),),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES",style: GoogleFonts.zillaSlab(fontSize: 20,color: Colors.amber[900]),),
              ),
            ),
          ],
        ),
      ),
    ) ??
        false;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    func();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            iconTheme: IconThemeData(color: Colors.black,),
            elevation: 0,
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout', 'Settings','profile'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
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

              ],
            ),

            backgroundColor: Colors.white,
            centerTitle: true,
          ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white, //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(

            child: Column(
              children: [
                Image.asset('assects/1.jpg',height: 250,width: double.infinity,),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.pink[500], Colors.amber[100]]
                    )
                  ),
                  width: double.infinity,
                  height: 45,
                  child: RaisedButton(
                    color: Colors.transparent,
                      child: Text("My Orders",style: GoogleFonts.raleway(fontSize: 22,color: Colors.white),),
                      onPressed: (){
                    Navigator.pushNamed(context, '/my_orders');
                  }),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.pink[500], Colors.amber[100]]
                    )
                  ),
                  width: double.infinity,
                  height: 45,
                  child: RaisedButton(
                    color: Colors.transparent,
                      child: Text("Wish List",style: GoogleFonts.raleway(fontSize: 22,color: Colors.white),),
                      onPressed: (){
                    Navigator.pushNamed(context, '/wish');
                  }),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.pink[500], Colors.amber[100]]
                    )
                  ),
                  width: double.infinity,
                  height: 45,
                  child: RaisedButton(
                    color: Colors.transparent,
                      child: Text("My Cart",style: GoogleFonts.raleway(fontSize: 22,color: Colors.white),),
                      onPressed: (){
                    Navigator.pushNamed(context, '/cart');
                  }),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.0),

                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,color: Colors.black,),
                      hintText: "What would you like to buy?",
                      hintStyle: TextStyle(color: Colors.black,fontSize: 17,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),

                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                    height: 170.0,
                    width:390,
                    child: Carousel(
                      images: [
                        NetworkImage("https://i.gadgets360cdn.com/large/jio_hotstar_offer_1591500059056.jpg"),
                        NetworkImage("https://image.freepik.com/free-vector/special-offer-modern-sale-banner-template_1017-20667.jpg"),
                        NetworkImage("https://cdn.grabon.in/gograbon/images/web-images/uploads/1602057770316/dussehra-offers.jpg"),
                        NetworkImage("https://assorted.downloads.oppo.com/static/archives/images/in/diwali-offer/offers-mobile.png"),
                        NetworkImage("https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/Samsung/SamsungM/M12/LP/Launch/PC/M12_LP_PC_51.jpg"),


                      ],
                      dotSize: 8.0,
                      dotSpacing: 15.0,
                      dotColor: Colors.white,
                      indicatorBgPadding: 5.0,
                      dotBgColor: Colors.purple.withOpacity(0),
                      borderRadius: false,
                      animationDuration: Duration(seconds: 1),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,10,0,10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 60,
                          width: 100,
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, '/popular');
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              color: Colors.grey[200],
                              elevation: 0,
                              child: Icon(Icons.account_balance,size: 30,color: Colors.pink,),
                            ),
                          ),
                        ),
                        Text("Popular",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 60,
                          width: 100,
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, '/flash_sell');
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              color: Colors.grey[200],
                              elevation: 0,
                              child: Icon(Icons.alarm,size: 30,color: Colors.amber,),
                            ),
                          ),
                        ),
                        Text("Flash Sell",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 60,
                          width: 100,
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, '/voucher');
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              color: Colors.grey[200],
                              elevation: 0,
                              child: Icon(Icons.card_giftcard,size: 30,color: Colors.cyan,),
                            ),
                          ),
                        ),
                        Text("Voucher",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.grey[100],
                    elevation: 10,
                    child: Center(child: Text("Categories",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Fashion");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://media.vanityfair.com/photos/55ef2bb0fad0d98d444cdb61/master/w_1600%2Cc_limit/fashion-illustrators-meagan-morrison-chiara-ferragni.jpg",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Fashion",style: GoogleFonts.redressed(fontSize: 25),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Mobile");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://www.mobilityindia.com/wp-content/uploads/2021/01/LAVA-Z6.jpg",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Mobiles",style: GoogleFonts.redressed(fontSize: 22),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Electronics");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://i.pinimg.com/originals/41/03/e4/4103e408acd9ab178616f6954d8fe769.jpg",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Electronics",style: GoogleFonts.redressed(fontSize: 22),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Home");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://i2-prod.gloucestershirelive.co.uk/incoming/article2388909.ece/ALTERNATES/s1200b/1_Poundland-Promotion.jpg",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Home",style: GoogleFonts.redressed(fontSize: 25),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Appliances");
                        },
                        child: Card(
                          child: Flexible(
                            child: Column(

                              children: [
                                Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjtehuUYSiCwNsS78GX9mlnLSNigH_mej_Zw&usqp=CAU",height: 120,),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("Appliances",style: GoogleFonts.redressed(fontSize: 22),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Beauty");
                        },
                        child: Card(
                          child: Flexible(
                            child: Column(

                              children: [
                                Image.network("https://www.creativenaturesuperfoods.co.uk/wp-content/uploads/2019/01/Cosmetic.jpg",height: 120,),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("Beauty",style: GoogleFonts.redressed(fontSize: 25),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Toys & baby");
                        },
                        child: Card(
                          child: Flexible(
                            child: Column(

                              children: [
                                Image.network("https://i.ebayimg.com/thumbs/images/g/u9wAAOSwvhte8t2w/s-l300.jpg",height: 120,),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("Toys & Boys",style: GoogleFonts.redressed(fontSize: 22),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Sports");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://media.istockphoto.com/vectors/set-of-sports-equipment-vector-id543180996?k=6&m=543180996&s=612x612&w=0&h=_rt5-aSraJl4hkZVpKJOg2SPMnMrgEbgWAKyRkoXqyE=",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Sports",style: GoogleFonts.redressed(fontSize: 25),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Furniture");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://images-na.ssl-images-amazon.com/images/I/61MAzfI%2B4vL._SX425_.jpg",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Furniture",style: GoogleFonts.redressed(fontSize: 25),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Food & more");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://4.imimg.com/data4/YD/CB/MY-3845829/center-seal-pouch-500x500.jpg",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Food & more",style: GoogleFonts.redressed(fontSize: 22),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Stationary");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://www.fermoylens.ie/wp-content/uploads/2019/07/stationary-2.jpg",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Stationary",style: GoogleFonts.redressed(fontSize: 25),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),Container(
                      height: 170,
                      width: 125,
                      child: InkWell(
                        onTap: (){
                          catName("Artifacts");
                        },
                        child: Card(
                          child: Column(

                            children: [
                              Image.network("https://heritagehandicraft.com/wp-content/uploads/2019/06/craft-map.jpg",height: 120,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Artifacts",style: GoogleFonts.redressed(fontSize: 25),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.pink[100],
                    elevation: 10,
                    child: Center(child: Text("Fashion",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Fashion").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Fashion");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.red[200],
                    elevation: 10,
                    child: Center(child: Text("Mobile",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Mobile").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Mobile");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.amber[100],
                    elevation: 10,
                    child: Center(child: Text("Electronics",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Electronics").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Electronics");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Flexible(
                                    child: Column(
                                      children: [
                                        Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                        if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                        ),
                                        if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.green[100],
                    elevation: 10,
                    child: Center(child: Text("Home",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Home").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Home");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.purple[100],
                    elevation: 10,
                    child: Center(child: Text("Appliances",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Appliances").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Appliances");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.deepOrange[100],
                    elevation: 10,
                    child: Center(child: Text("Beauty",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Beauty").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Beauty");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.teal[100],
                    elevation: 10,
                    child: Center(child: Text("Toys & baby",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Toys & baby").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Toys & baby");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.cyan[100],
                    elevation: 10,
                    child: Center(child: Text("Sports",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Sports").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Sports");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.yellow[100],
                    elevation: 10,
                    child: Center(child: Text("Furniture",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Furniture").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Furniture");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.indigo[100],
                    elevation: 10,
                    child: Center(child: Text("Food & more",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Food & more").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Food & more");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.amber[100],
                    elevation: 10,
                    child: Center(child: Text("Stationary",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Stationary").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Stationary");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,8,0,8),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: Card(
                    color: Colors.tealAccent[100],
                    elevation: 10,
                    child: Center(child: Text("Artifacts",style: TextStyle(color: Colors.blueGrey[900],fontSize: 22,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("categories").doc("Artifacts").collection("products").snapshots(),

                  builder: (context,snapshot){
                    if(snapshot.hasData) {
                      DocumentSnapshot documentSnapshot1=snapshot.data.documents[0];
                      DocumentSnapshot documentSnapshot2=snapshot.data.documents[1];
                      DocumentSnapshot documentSnapshot3=snapshot.data.documents[2];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            catName("Artifacts");
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Card(
                                  child: Column(
                                    children: [
                                      Image.network(documentSnapshot1["Image_url"],height: 350,width: 210,),
                                      if((documentSnapshot1["Name"].toString()).length<=20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                      if((documentSnapshot1["Name"].toString()).length>20) Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child:  Text(documentSnapshot1["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot2["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot2["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot2["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot2["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Image.network(documentSnapshot3["Image_url"],height: 150,width: 210,),
                                            if((documentSnapshot3["Name"].toString()).length<=20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"],style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                            if((documentSnapshot3["Name"].toString()).length>20) Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:  Text(documentSnapshot3["Name"].substring(0,19)+"...",style:GoogleFonts.raleway(fontSize: 17,fontWeight: FontWeight.bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
              ),

            ],
          ),
        ),
        bottomNavigationBar: desh ? BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          backgroundColor: Colors.grey[100],
          items: [
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/");
                  },
                  child: new Icon(Icons.home,color: Colors.red[900],)),
              title: new Text('Home',
                style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
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
              },child: new Icon(Icons.dashboard)),
              title: new Text('DashBoard',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold)),
            )


          ],
        ):BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          backgroundColor: Colors.grey[100],
          items: [
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/");
                  },
                  child: new Icon(Icons.home,color: Colors.red[900],)),
              title: new Text('Home',
                style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
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



          ],
        ),

      ),
    );
  }
  Future signOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, "/login");
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}



