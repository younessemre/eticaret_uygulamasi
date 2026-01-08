import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_flutter/models/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistitems = {};

  Map<String, WishlistModel> get getWishLists => _wishlistitems;

  //Veritabanından favori ürünleri çekme
  Future<void> hydrateFromIds(List<dynamic> ids) async {
    _wishlistitems.clear();
    for (final raw in ids) {
      final pid = raw?.toString();
      if (pid == null || pid.isEmpty) continue;
      _wishlistitems[pid] = WishlistModel(
        wishlistId: const Uuid().v4(),
        productId: pid,
      );
    }
    notifyListeners();
  }

  List<String> _asIdList() => _wishlistitems.keys.toList();

  //Kullanıcı giriş yaptıysa favori listesini kaydetme
  Future<void> _persistToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; //Misafir mi
    try {
      await FirebaseFirestore.instance.collection('users')
          .doc(user.uid).update({'userWish': _asIdList()});
    } catch (_) {
      await FirebaseFirestore.instance.collection('users')
          .doc(user.uid).set({'userWish': _asIdList()}, SetOptions(merge: true));
    }
  }


  Future<void> addORderRemoveWishlist({required String productId}) async {
    if (_wishlistitems.containsKey(productId)) {
      _wishlistitems.remove(productId);
    } else {
      _wishlistitems[productId] = WishlistModel(
        wishlistId: const Uuid().v4(),
        productId: productId,
      );
    }
    notifyListeners();
    await _persistToFirestore(); // değişikliği Firestore'a yansıt
  }

  bool isProdingWishlist({required String productId}) {
    return _wishlistitems.containsKey(productId);
  }

  Future<void> clearLocalWishlist({bool persist = false}) async {
    _wishlistitems.clear();
    notifyListeners();
    if (persist) {
      await _persistToFirestore();
    }
  }
}