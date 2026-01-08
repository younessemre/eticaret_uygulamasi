import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/providers/user_provider.dart';
import 'package:ecommerce_flutter/providers/cart_provider.dart';
import 'package:ecommerce_flutter/providers/product_provider.dart';
import 'package:ecommerce_flutter/root_screen.dart';
import 'package:ecommerce_flutter/screens/checkout/add_address_screen.dart';
import 'package:ecommerce_flutter/services/myapp_functions.dart';
import 'package:ecommerce_flutter/widgets/title_text.dart';
import 'package:ecommerce_flutter/widgets/subtitle_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  static const routName = '/CheckoutScreen';
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedAddress;
  bool _didFetch = false;
  bool _placing = false;

  //Kullanıcının kayıtlı adresini veritabanından çekme
  Future<void> _fetchAddressesOnce() async {
    if (_didFetch) return;
    _didFetch = true;
    await context.read<UserProvider>().fetchUserAddresses();
    final list = context.read<UserProvider>().getUserAddresses;
    if (list.isNotEmpty) {
      _selectedAddress ??= list.first;
      setState(() {});
    }
  }

  //Adres eklemeye git ve veritabanından adres çek
  Future<void> _goAddAddress() async {
    await Navigator.pushNamed(context, AddressAddScreen.routName);
    await context.read<UserProvider>().fetchUserAddresses();
    final list = context.read<UserProvider>().getUserAddresses;
    if (list.isNotEmpty && (_selectedAddress == null || !list.contains(_selectedAddress))) {
      setState(() => _selectedAddress = list.first);
    } else {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchAddressesOnce();
  }

  //Kullanıcı giriş yaptı mı / Sipariş verme
  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: 'Giriş yapmanız gerekmektedir...',
        fct: () {},
      );
      return;
    }

    final cartProv = context.read<CartProvider>();
    final prodProv = context.read<ProductProvider>();
    if (cartProv.getCartItems.isEmpty) {
      Fluttertoast.showToast(msg: 'Sepetiniz boş');
      return;
    }

    setState(() => _placing = true);

    try {
      final countersRef = FirebaseFirestore.instance
          .collection('users').doc(user.uid)
          .collection('meta').doc('orders_counter');

      final int nextSeq = await FirebaseFirestore.instance.runTransaction<int>((tx) async {
        final snap = await tx.get(countersRef);
        int current = 0;
        if (snap.exists) current = (snap.data()?['seq'] ?? 0) as int;
        final updated = current + 1;
        tx.set(countersRef, {'seq': updated}, SetOptions(merge: true));
        return updated;
      });

      final orderNo = nextSeq.toString().padLeft(4, '0');

      //Ürün listesini ve toplam fiyatı oluşturma
      final items = cartProv.getCartItems.values
          .map((c) => {'productId': c.productId, 'quantity': c.quantity})
          .toList();
      final total = cartProv.geTTotal(productProvider: prodProv);

      //Stok azaltma işlemi
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final Map<DocumentReference<Map<String, dynamic>>, String> updates = {};

        for (final it in items) {
          final String pid = it['productId'] as String;
          final int qty = it['quantity'] as int;

          final ref = FirebaseFirestore.instance.collection('products').doc(pid);
          final snap = await tx.get(ref);
          if (!snap.exists) continue;

          final data = snap.data() as Map<String, dynamic>;
          final curr = int.tryParse((data['productQuantity'] ?? '0').toString()) ?? 0;
          final newQty = (curr - qty).clamp(0, 1 << 31);
          updates[ref] = newQty.toString();
        }

        updates.forEach((ref, qStr) {
          tx.update(ref, {'productQuantity': qStr});
        });
      });

      await FirebaseFirestore.instance.collection('users')
          .doc(user.uid).collection('orders').add({
        'orderNo': orderNo,
        'address': _selectedAddress ?? '',
        'items': items,
        'total': total,
        'createdAt': FieldValue.serverTimestamp(),
      });

      cartProv.clearLocalCart();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, RootScreen.routName, (route) => false);
      Fluttertoast.showToast(msg: 'Sipariş başarıyla oluşturuldu');
    } on FirebaseException catch (e) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: '${e.code} - ${e.message}',
        fct: () {},
      );
    } catch (e) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = context.watch<UserProvider>();
    final cartProv = context.watch<CartProvider>();
    final prodProv = context.watch<ProductProvider>();
    final addresses = userProv.getUserAddresses;
    final total = cartProv.geTTotal(productProvider: prodProv);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Sipariş')),
      body: AbsorbPointer(
        absorbing: _placing,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _boxed(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleTextWidget(label: 'Adres', fontSize: 16, fontWeight: FontWeight.w700),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: (addresses.contains(_selectedAddress)) ? _selectedAddress : null,
                    hint: const Text('Seç'),
                    items: addresses.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                    onChanged: (val) => setState(() => _selectedAddress = val),
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                        onPressed: _goAddAddress,
                        child: const Text('Adres Ekle')),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _boxed(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  TitleTextWidget(label: 'Ödeme Yöntemi', fontSize: 16, fontWeight: FontWeight.w700),
                  SizedBox(height: 6),
                  _RadioRow(title: 'Nakit', selected: true),
                  _RadioRow(title: 'Kredi Kartı', selected: false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _boxed(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleTextWidget(label: 'Sepet Özeti', fontSize: 16, fontWeight: FontWeight.w700),

                  const SizedBox(height: 10),
                  ...cartProv.getCartItems.values.map((cartItem) {
                    final p = prodProv.findByProId(cartItem.productId);
                    if (p == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FancyShimmerImage(
                              imageUrl: p.productImage,
                              height: 54,
                              width: 54,
                              boxFit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubTitleTextWidget(label: p.productTitle, fontWeight: FontWeight.w700),

                                const SizedBox(height: 2),

                                SubTitleTextWidget(
                                  label: "\$ ${p.productPrice}",
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),

                          SubTitleTextWidget(label: "Adet: ${cartItem.quantity}"),

                        ],
                      ),
                    );
                  }).toList(),

                  const Divider(height: 24),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TitleTextWidget(
                      label: "Toplam: \$ ${total.toStringAsFixed(2)}",
                      fontWeight: FontWeight.w900,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _placing ? null : _placeOrder,
                child: Text(_placing ? 'Sipariş Gönderiliyor...' : 'Sipariş Ver'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxed({required Widget child}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Theme.of(context).dividerColor),
    ),
    child: child,
  );
}

class _RadioRow extends StatelessWidget {
  final String title;
  final bool selected;
  const _RadioRow({required this.title, required this.selected});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<bool>(value: true, groupValue: selected, onChanged: (_) {}),
        SubTitleTextWidget(label: title),
      ],
    );
  }
}