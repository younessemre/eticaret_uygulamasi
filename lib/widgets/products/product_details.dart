import 'package:ecommerce_flutter/providers/cart_provider.dart';
import 'package:ecommerce_flutter/providers/product_provider.dart';
import 'package:ecommerce_flutter/widgets/products/heart_btn.dart';
import 'package:ecommerce_flutter/widgets/subtitle_text.dart';
import 'package:ecommerce_flutter/widgets/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routName = "/ProductDetailsScreen";

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductProvider>(context);

    final String? productId =
        ModalRoute.of(context)!.settings.arguments as String?;

    final getCurrProduct =
        productId == null ? null : productsProvider.findByProId(productId);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürün Sayfası"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
      ),
      body: getCurrProduct == null
          ? const Center(child: Text("Ürün bulunamadı"))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 7),
                  FancyShimmerImage(
                    imageUrl: getCurrProduct.productImage,
                    height: size.height * 0.35,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  getCurrProduct.productTitle,
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30, width: 20),
                              SubTitleTextWidget(
                                label: "\$${getCurrProduct.productPrice}",
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HeartButtonWidget(
                                productId: getCurrProduct.productId,
                                bkgColor: Colors.red.shade500,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight - 10,
                                  child: ElevatedButton.icon(
                                    icon: Icon(
                                      cartProvider.isProdinCart(
                                              productId:
                                                  getCurrProduct.productId)
                                          ? Icons.check
                                          : Icons.shopping_cart,
                                    ),
                                    label: Text(
                                      cartProvider.isProdinCart(
                                              productId:
                                                  getCurrProduct.productId)
                                          ? "Ürün Sepete Eklendi"
                                          : "Sepete Ekle",
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade500,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (cartProvider.isProdinCart(
                                          productId:
                                              getCurrProduct.productId)) {
                                        return;
                                      }
                                      cartProvider.addProductCart(
                                        productId: getCurrProduct.productId,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleTextWidget(label: "Hakkında"),
                        SubTitleTextWidget(
                          label: getCurrProduct.productCategory,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SubTitleTextWidget(
                      label: getCurrProduct.productDescription,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
