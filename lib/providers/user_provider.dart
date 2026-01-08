import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;

  List<String> _addresses = [];
  List<String> get getUserAddresses => _addresses;

  UserModel? get getUserModel => userModel;

  Future<UserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await FirebaseFirestore.instance.collection("users")
          .doc(user.uid).get();

      final data = doc.data() as Map<String, dynamic>?;

      userModel = UserModel(
        userId: doc.get("userId"),
        userName: doc.get("userName"),
        userImage: doc.get("userImage"),
        userEmail: doc.get("userEmail"),
        createdAt: doc.get("createdAt"),
        userCart: (data != null && data.containsKey("userCart"))
            ? doc.get("userCart")
            : [],
        userWish: (data != null && data.containsKey("userWish"))
            ? doc.get("userWish")
            : [],
      );

      await fetchUserAddresses();

      notifyListeners();
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  //Veritabanından adres bilgisi çekme
  Future<void> fetchUserAddresses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _addresses = [];
      notifyListeners();
      return;
    }

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .orderBy('createdAt', descending: true)
        .get();

    _addresses = snap.docs.map((d) {
      final data = d.data();
      final String? line = (data['address'] ?? data['addressLine']) as String?;
      return line ?? '';
    }).where((e) => e.isNotEmpty).toList();

    notifyListeners();
  }

  void clearUserLocal() {
    userModel = null;
    _addresses = [];
    notifyListeners();
  }
}