import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/services/myapp_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressAddScreen extends StatefulWidget {
  static const routName = '/AddressAddScreen';
  const AddressAddScreen({super.key});

  @override
  State<AddressAddScreen> createState() => _AddressAddScreenState();
}

class _AddressAddScreenState extends State<AddressAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _tcNo = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _postal = TextEditingController();
  final _address = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _fullName.dispose();
    _tcNo.dispose();
    _city.dispose();
    _district.dispose();
    _postal.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
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

    try {
      setState(() => _saving = true);
      final col = FirebaseFirestore.instance.collection('users')
          .doc(user.uid).collection('addresses');

      await col.add({
        'fullName': _fullName.text.trim(),
        'tcNo': _tcNo.text.trim(),
        'city': _city.text.trim(),
        'district': _district.text.trim(),
        'postalCode': _postal.text.trim(),
        'addressLine': _address.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pop(context); // başarıyla kaydetti -> geri dön
    } on FirebaseException catch (e) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: '${e.code} - ${e.message}',
        fct: () {},
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adres Ekle')),
      body: AbsorbPointer(
        absorbing: _saving,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(children: [
              _input(
                  icon: Icons.person,
                  hint: 'Ad Soyad',
                  controller: _fullName),

              const SizedBox(height: 12),

              _input(
                  icon: Icons.badge,
                  hint: 'TC Kimlik No',
                  controller: _tcNo,
                  keyboardType: TextInputType.number),

              const SizedBox(height: 12),

              Row(
                  children: [
                Expanded(
                    child: _input(icon: Icons.location_city,
                        hint: 'İl',
                        controller: _city)),

                const SizedBox(width: 12),

                    Expanded(
                        child: _input(icon: Icons.maps_home_work,
                            hint: 'İlçe',
                            controller: _district)),
              ]),

              const SizedBox(height: 12),

              _input(
                  icon: Icons.markunread_mailbox,
                  hint: 'Posta Kodu',
                  controller: _postal,
                  keyboardType: TextInputType.number),

              const SizedBox(height: 12),

              _input(
                icon: Icons.home,
                hint: 'Adres',
                controller: _address,
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(_saving ? 'Kaydediliyor...' : 'Kaydet'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Zorunlu alan' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}