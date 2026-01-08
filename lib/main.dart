import 'package:ecommerce_flutter/constans/theme_data.dart';
import 'package:ecommerce_flutter/providers/cart_provider.dart';
import 'package:ecommerce_flutter/providers/product_provider.dart';
import 'package:ecommerce_flutter/providers/theme_provider.dart';
import 'package:ecommerce_flutter/providers/user_provider.dart';
import 'package:ecommerce_flutter/providers/viewed_recently_providers.dart';
import 'package:ecommerce_flutter/providers/wishlist_provider.dart';
import 'package:ecommerce_flutter/root_screen.dart';
import 'package:ecommerce_flutter/screens/adress_screen.dart';
import 'package:ecommerce_flutter/screens/auth/forgot_password.dart';
import 'package:ecommerce_flutter/screens/auth/login.dart';
import 'package:ecommerce_flutter/screens/auth/register.dart';
import 'package:ecommerce_flutter/screens/checkout/add_address_screen.dart';
import 'package:ecommerce_flutter/screens/checkout/checkout_screen.dart';
import 'package:ecommerce_flutter/screens/home_screen.dart';
import 'package:ecommerce_flutter/screens/init_screen/viewed_recently.dart';
import 'package:ecommerce_flutter/screens/init_screen/wishlist.dart';
import 'package:ecommerce_flutter/screens/search_screen.dart';
import 'package:ecommerce_flutter/widgets/order/order_details.dart';
import 'package:ecommerce_flutter/widgets/order/order_screen.dart';
import 'package:ecommerce_flutter/widgets/products/product_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyA75C-pwGSjGK6a_qj1h6RbJC9Ay15THMs',
              appId: '1:378784684371:android:1b43a13718ef076a4da9a6',
              messagingSenderId: '378784684371',
              projectId: "eticaretuygulamasi2",
              storageBucket: 'eticaretuygulamasi2.firebasestorage.app',
          )
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          else if(snapshot.hasError){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(snapshot.error.toString()),
                ),
              )
            );
          }



    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) {
        return ThemeProvider();
      }),
      ChangeNotifierProvider(create: (_) {
        return ProductProvider();
      }),
      ChangeNotifierProvider(create: (_) {
        return CartProvider();
      }),
      ChangeNotifierProvider(create: (_) {
        return WishlistProvider();
      }),
      ChangeNotifierProvider(create: (_) {
        return ViewedProdProvider();
      }),
      ChangeNotifierProvider(create: (_) {
        return UserProvider();
      }),

    ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-ticaret Uygulaması',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),

          home: LoginScreen(),
          routes: {
            WishlistScreen.routName: (context) => const WishlistScreen(),
            ViewedRecentlyScreen.routName: (context) => const ViewedRecentlyScreen(),
            RegisterScreen.routName: (context) => const RegisterScreen(),
            OrderScreen.routName: (context) => const OrderScreen(),
            OrderDetailsScreen.routName: (context) => const OrderDetailsScreen(),
            ForgotPassword.routName: (context) => const ForgotPassword(),
            SearchScreen.routName: (context) => const SearchScreen(),
            ProductDetailsScreen.routName: (context) => const ProductDetailsScreen(),
            RootScreen.routName: (context) => const RootScreen(),
            LoginScreen.routName: (context) => const LoginScreen(),
            CheckoutScreen.routName: (context) => const CheckoutScreen(),
            AddressAddScreen.routName: (context) => const AddressAddScreen(),
            AddressesScreen.routName: (context) => const AddressesScreen(),


          },
        );
      }),

    );
  }
  );

  }
}
