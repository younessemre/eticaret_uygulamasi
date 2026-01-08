// lib/root_screen.dart
import 'dart:async';

import 'package:ecommerce_flutter/providers/cart_provider.dart';
import 'package:ecommerce_flutter/providers/product_provider.dart';
import 'package:ecommerce_flutter/providers/user_provider.dart';
import 'package:ecommerce_flutter/providers/wishlist_provider.dart';
import 'package:ecommerce_flutter/screens/cart/cart_screen.dart';
import 'package:ecommerce_flutter/screens/home_screen.dart';
import 'package:ecommerce_flutter/screens/profile_screen.dart';
import 'package:ecommerce_flutter/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  static const routName = "/RootScreen";

  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late final PageController _controller;
  int _currentIndex = 0;

  bool _didHydrateOnce = false;
  StreamSubscription<User?>? _authSub;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex);

    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;
      final userProv = context.read<UserProvider>();
      final cartProv = context.read<CartProvider>();
      final wishProv = context.read<WishlistProvider>();

      if (user == null) {
        cartProv.clearLocalCart();
        wishProv.clearLocalWishlist();
        userProv.clearUserLocal();
        _didHydrateOnce = false;
      } else {
        try {
          final model = await userProv.fetchUserInfo();
          if (model != null) {
            await cartProv.hydrateFromFirestoreList(model.userCart);
            await wishProv.hydrateFromIds(model.userWish);
          }
        } catch (_) {}
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProducts();
    _hydrateIfNeeded();
  }

  Future<void> _fetchProducts() async {
    try {
      await context.read<ProductProvider>().fetchProducts();
    } catch (_) {}
  }

  Future<void> _hydrateIfNeeded() async {
    if (_didHydrateOnce) return;
    _didHydrateOnce = true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userProv = context.read<UserProvider>();
      final cartProv = context.read<CartProvider>();
      final wishProv = context.read<WishlistProvider>();
      final model = await userProv.fetchUserInfo();
      if (model != null) {
        await cartProv.hydrateFromFirestoreList(model.userCart);
        await wishProv.hydrateFromIds(model.userWish);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();

    final screens = const [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
          _controller.jumpToPage(idx);
        },
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(CupertinoIcons.home),
            icon: Icon(CupertinoIcons.home),
            label: "Ana Sayfa",
          ),
          const NavigationDestination(
            selectedIcon: Icon(CupertinoIcons.search),
            icon: Icon(CupertinoIcons.search),
            label: "Arama",
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.shopping_bag_rounded),
            icon: cartProv.getCartItems.isEmpty
                ? const Icon(IconlyLight.bag_2)
                : Badge(
              backgroundColor: Colors.red,
              textColor: Colors.white,
              label: Text(cartProv.getCartItems.length.toString()),
              child: const Icon(IconlyLight.bag_2),
            ),
            label: "Sepet",
          ),
          const NavigationDestination(
            selectedIcon: Icon(CupertinoIcons.person),
            icon: Icon(CupertinoIcons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}