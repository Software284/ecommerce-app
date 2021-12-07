import 'package:flutter/material.dart';
import './screen/products_overview_screen.dart';
import './screen/product_detail_screen.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './screen/cart_screen.dart';
import './providers/orders.dart';
import './screen/orders_screen.dart';
import './screen/user_product_screen.dart';
import './providers/products.dart';
import './screen/edit_product_screen.dart';
import './screen/auth_screen.dart';
import './providers/auth.dart';
import './screen/splash-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth,Products>(
          create: (ctx) => Products('','',List.empty()),
          update: (ctx,auth,previousProducts) => Products(auth.token.toString(),auth.userId.toString(),  previousProducts! == null ? [] : previousProducts.items),
          
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth,Orders>(
          create: (ctx) => Orders('','',List.empty()),
          update: (ctx,auth,previousOrders) => Orders(auth.token.toString(),auth.userId.toString(),  previousOrders! == null ? [] : previousOrders.orders),
          
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx,auth,_) => MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: auth.isAuth 
        ? ProductsOverviewScreen() 
        : FutureBuilder(
          future: auth.tryAutoLogin(),
          builder: (ctx,authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
        ),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),) 
    );
  }
}
