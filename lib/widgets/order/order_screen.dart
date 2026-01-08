import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/widgets/order/order_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  static const routName = "/OrderScreen";
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Siparişler'),
      ),
      body: user == null
          ? const Center(child: Text('Siparişleri görmek için giriş yapınız.'))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .doc(user.uid).collection('orders')
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
            return const Center(child: Text('Henüz sipariş yok.'));
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, thickness: 1),
            itemBuilder: (ctx, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>? ?? {};

              final orderNo = data['orderNo']?.toString() ?? '-';
              final total = (data['total'] is num)
                  ? (data['total'] as num).toDouble()
                  : 0.0;

              final itemsRaw = data['items'];
              final List<dynamic> items =
              (itemsRaw is List) ? List<dynamic>.from(itemsRaw) : const [];

              return ListTile(
                title: Text('Sipariş No: $orderNo'),
                trailing: Text('Tutar: \$${total.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailsScreen.routName,
                    arguments: {
                      'orderNo': orderNo,
                      'total': total,
                      'items': items,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}