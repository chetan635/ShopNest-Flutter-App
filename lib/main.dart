import 'package:flutter/material.dart';
import 'package:shopnest/pages/DashBoard.dart';
import 'package:shopnest/pages/auth_service.dart';
import 'package:shopnest/pages/cart.dart';
import 'package:shopnest/pages/edit.dart';
import 'package:shopnest/pages/flash_sell.dart';
import 'package:shopnest/pages/home.dart';




import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopnest/pages/login.dart';
import 'package:shopnest/pages/my_orders.dart';
import 'package:shopnest/pages/popular.dart';
import 'package:shopnest/pages/product_info.dart';
import 'package:shopnest/pages/products.dart';
import 'package:shopnest/pages/profile.dart';
import 'package:shopnest/pages/register.dart';
import 'package:shopnest/pages/settings.dart';
import 'package:shopnest/pages/voucher.dart';
import 'package:shopnest/pages/wish.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider<Auth_serve>(
        create: (_)=>Auth_serve(FirebaseAuth.instance),
      ),
      StreamProvider(create: (context)=> context.read<Auth_serve>().authStateChanges)
    ],
    child: MaterialApp(
      initialRoute: '/aoth',
      routes: {
        '/home':(context) =>Home(),
        '/login':(context) =>Login(),
        '/register':(context) =>SignUp(),
        '/DashBoard':(context) =>DashBoard(),
        '/products':(context) =>Products(),
        '/product_info':(context) =>Product_Info(),
        '/settings':(context) =>Settings(),
        '/cart':(context) =>Cart(),
        '/wish':(context) =>Wish(),
        '/my_orders':(context) =>My_Orders(),
        '/popular':(context) =>Popular(),
        '/voucher':(context) =>Voucher(),
        '/flash_sell':(context) =>Flash(),
        '/edit':(context) =>Edit(),
//        '/profile':(context) =>Profile(),
        "/aoth": (context)=>Aoth(),

//'/home':(context)=>home(),



      },
    ),
  ));
}

class Aoth extends StatelessWidget {

  const Aoth({
    Key key,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser != null){
      return Home();
    }

    else{
      return Login();
    }
  }
}

