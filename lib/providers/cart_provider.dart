// lib/providers/cart_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_flutter/models/cart_model.dart';
import 'package:ecommerce_flutter/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems => _cartItems;


  //Firestore'dan gelen sepet listesini projeye getirme işlemi
  Future<void> hydrateFromFirestoreList(List<dynamic> cartList) async {
    _cartItems.clear();
    for (final row in cartList) {
      if (row is Map) {
        final pid = row['productId']?.toString();
        final qty = int.tryParse(row['quantity']?.toString() ?? '1') ?? 1;
        if (pid != null && pid.isNotEmpty) {
          _cartItems[pid] = CartModel(
            cartId: const Uuid().v4(),
            productId: pid,
            quantity: qty,
          );
        }
      }
    }
    notifyListeners();
  }

  //Sepet verilerini kullanıcıya göre güncelleme
  Future<void> loadFromFirestore({required String uid}) async {
    final doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data() as Map<String, dynamic>?;
    final list = (data != null && data['userCart'] is List)
        ? List<dynamic>.from(data['userCart'])
        : <dynamic>[];
    await hydrateFromFirestoreList(list);
  }

  //Sepet verisini Firebase'e kaydetme
  Future<void> saveToFirestore({required String uid}) async {
    final payload = _cartItems.values
        .map((e) => {
      'productId': e.productId,
      'quantity': e.quantity,
    })
        .toList();

    await FirebaseFirestore.instance
        .collection('users').doc(uid)
        .update({'userCart': payload});
  }

  //Sepet hesaplama
  double geTTotal({required ProductProvider productProvider}) {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findByProId(value.productId);
      if (getCurrProduct != null) {
        total += double.parse(getCurrProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }


  //Sepete ürün ekleme
  void addProductCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
          () => CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      ),
    );
    notifyListeners();
    _syncIfLoggedIn();
  }

  bool isProdinCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) => total += value.quantity);
    return total;
  }

  void updateQty({required String productId, required int qty}) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
            (cartItem) => CartModel(
          cartId: cartItem.cartId,
          productId: productId,
          quantity: qty,
        ),
      );
      notifyListeners();
      _syncIfLoggedIn();
    }
  }

  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
    _syncIfLoggedIn();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
    _syncIfLoggedIn();
  }


  Future<void> _syncIfLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await saveToFirestore(uid: user.uid);
      } catch (_) {
      }
    }
  }
}