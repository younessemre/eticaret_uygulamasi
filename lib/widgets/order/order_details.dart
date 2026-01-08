import 'package:ecommerce_flutter/providers/product_provider.dart';
import 'package:ecommerce_flutter/widgets/title_text.dart';
import 'package:ecommerce_flutter/widgets/subtitle_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routName = "/OrderDetailsScreen";

  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigator.pushNamed(..., arguments: {'orderNo': String, 'total': double, 'items': List})
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final String orderNo = (args?['orderNo'] ?? '-').toString();
    final double total =
        (args?['total'] is num) ? (args!['total'] as num).toDouble() : 0.0;
    final List items =
        (args?['items'] is List) ? List.from(args!['items']) : const [];

    final products = context.read<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sipariş No: $orderNo'),
      ),

      //Sipariş toplam değeri
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SubTitleTextWidget(
                label: 'Toplam:', fontWeight: FontWeight.w700),
            SubTitleTextWidget(
                label: '\$${total.toStringAsFixed(2)}',
                color: Colors.red,
                fontWeight: FontWeight.w800),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleTextWidget(
                label: 'Sipariş Özeti',
                fontSize: 18,
                fontWeight: FontWeight.w700),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (context, i) {
                  final row = (items[i] is Map) ? items[i] as Map : const {};
                  final String pid = (row['productId'] ?? '').toString();
                  final int qty =
                      int.tryParse((row['quantity'] ?? '1').toString()) ?? 1;

                  final product = products.findByProId(pid);
                  final String title = product?.productTitle ?? 'Ürün';
                  final String priceStr = product?.productPrice ?? '0';
                  final double price = double.tryParse(priceStr) ?? 0;
                  final String image = product?.productImage ?? '';

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // Ürün görseli
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: image.isEmpty
                            ? Container(
                                height: 56,
                                width: 56,
                                color: Theme.of(context).cardColor,
                                child: const Icon(Icons.image_not_supported))
                            : FancyShimmerImage(
                                imageUrl: image,
                                height: 56,
                                width: 56,
                                boxFit: BoxFit.cover),
                      ),

                      const SizedBox(width: 12),

                      //Ürün başlığı ve adet
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubTitleTextWidget(
                                label: title, fontWeight: FontWeight.w700),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                SubTitleTextWidget(
                                    label: '\$${price.toStringAsFixed(2)}'),
                                const SizedBox(width: 12),
                                SubTitleTextWidget(label: 'Adet: $qty'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SubTitleTextWidget(
                        label: '\$${(price * qty).toStringAsFixed(2)}',
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
