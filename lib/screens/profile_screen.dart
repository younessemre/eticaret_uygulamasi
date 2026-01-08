import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:ecommerce_flutter/providers/user_provider.dart';
import 'package:ecommerce_flutter/screens/adress_screen.dart';
import 'package:ecommerce_flutter/screens/auth/login.dart';
import 'package:ecommerce_flutter/screens/init_screen/viewed_recently.dart';
import 'package:ecommerce_flutter/screens/init_screen/wishlist.dart';
import 'package:ecommerce_flutter/services/assets_manages.dart';
import 'package:ecommerce_flutter/services/myapp_functions.dart';
import 'package:ecommerce_flutter/widgets/app_name_text.dart';
import 'package:ecommerce_flutter/widgets/loading_manager.dart';
import 'package:ecommerce_flutter/widgets/order/order_screen.dart';
import 'package:ecommerce_flutter/widgets/subtitle_text.dart';
import 'package:ecommerce_flutter/widgets/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_flutter/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';

import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() => _isLoading = true);
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> _handleLogout() async {
    final wishProv = Provider.of<WishlistProvider>(context, listen: false);
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    final userProv = Provider.of<UserProvider>(context, listen: false);

    await MyAppFunctions.showErrorOrWaningDialog(
      context: context,
      subtitle: "Emin misiniz?",
      isError: false,
      fct: () async {
        try {
          await FirebaseAuth.instance.signOut();
        } finally {
          // Lokal providerları temizle
          wishProv.clearLocalWishlist();
          cartProv.clearLocalCart();
          userProv.clearUserLocal();
          setState(() {
            user = null;
            userModel = null;
          });
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routName,
            (route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.card),
        ),
        title: const AppNameTextWidget(label: "Profil Ekranı", fontSize: 20),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:
              user == null ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            // Giriş uyarısı
            Visibility(
              visible: user == null,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: TitleTextWidget(label: "Lütfen giriş yapınız..."),
              ),
            ),

            // Kullanıcı bilgileri
            if (userModel != null)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.background,
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(userModel!.userImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextWidget(label: userModel!.userName),
                        const SizedBox(height: 6),
                        SubTitleTextWidget(label: userModel!.userEmail),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 15),

            if (userModel != null)
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(thickness: 1),
                    const SizedBox(height: 5),
                    CustomListTile(
                      imagePath: AssetsManager.bagimg2,
                      text: "Tüm Siparişler",
                      function: () {
                        Navigator.pushNamed(context, OrderScreen.routName);
                      },
                    ),
                    CustomListTile(
                      imagePath: AssetsManager.bagimg1,
                      text: "Favoriler",
                      function: () {
                        Navigator.pushNamed(context, WishlistScreen.routName);
                      },
                    ),
                    CustomListTile(
                      imagePath: AssetsManager.clock,
                      text: "Görüntülenenler",
                      function: () {
                        Navigator.pushNamed(
                            context, ViewedRecentlyScreen.routName);
                      },
                    ),
                    CustomListTile(
                      imagePath: AssetsManager.location,
                      text: "Adresler",
                      function: () {
                        Navigator.pushNamed(context, AddressesScreen.routName);
                      },
                    ),
                    CustomListTile(
                      imagePath: AssetsManager.privacy,
                      text: "Ayarlar",
                      function: () {},
                    ),
                    const SizedBox(height: 5),
                    const Divider(thickness: 1),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: Text(themeProvider.getIsDarkTheme
                          ? "Dark Mode"
                          : "Light Mode"),
                      value: themeProvider.getIsDarkTheme,
                      onChanged: (value) {
                        themeProvider.setDarkTheme(themeValue: value);
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            Center(
              child: ElevatedButton.icon(
                icon: Icon(user == null ? Icons.login : Icons.logout),
                label: Text(user == null ? "Giriş Yap" : "Çıkış Yap"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () async {
                  if (user == null) {
                    Navigator.pushNamed(context, LoginScreen.routName);
                  } else {
                    await _handleLogout();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });

  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => function(),
      title: SubTitleTextWidget(label: text),
      leading: Image.asset(imagePath, height: 34),
      trailing: const Icon(CupertinoIcons.chevron_right),
    );
  }
}
