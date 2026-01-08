import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/adress_model.dart';
import 'package:ecommerce_flutter/screens/checkout/add_address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressesScreen extends StatelessWidget {
  static const routName = '/AddressesScreen';
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adreslerim'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AddressAddScreen.routName),
            icon: const Icon(Icons.add_location_alt),
            tooltip: 'Adres Ekle',
          ),
        ],
      ),

      body: user == null
          ? const Center(child: Text('Giriş yapmanız gerekmektedir...'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users')
              .doc(user.uid).collection('addresses')
              .orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Hata: ${snap.error}'));
                }
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('Kayıtlı adres yok'));
                }
                final items = docs.map((d) => AddressModel.fromDoc(d)).toList();

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final a = items[i];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text('TC: ${a.tcNo}'),
                            Text('${a.city} / ${a.district}'),
                            Text('PK: ${a.postalCode}'),
                            const SizedBox(height: 6),
                            Text(a.addressLine),
                          ],
                        ),
                      ),
                    );
                    },
                );
                },
      ),
    );
  }
}