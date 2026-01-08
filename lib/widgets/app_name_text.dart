import 'package:ecommerce_flutter/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({
    super.key,
    required this.label,
    this.fontSize = 30});

  final double fontSize;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: TitleTextWidget(
        label: label,
        fontSize: fontSize,),
      period: const Duration(seconds: 1),
      baseColor: Colors.grey,
      highlightColor: Colors.white,);
  }
}