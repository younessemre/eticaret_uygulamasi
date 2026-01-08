import 'package:ecommerce_flutter/root_screen.dart';
import 'package:ecommerce_flutter/widgets/subtitle_text.dart';
import 'package:ecommerce_flutter/widgets/title_text.dart';
import 'package:flutter/material.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  final String imagePath, title, subtitle, buttonText;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: size.height*0.35,
            ),

            const TitleTextWidget(
                label: "",
              fontSize: 40,
              color:Colors.red
            ),

            SubTitleTextWidget(
                label: title,
              fontWeight: FontWeight.w800,
              fontSize: 25,
            ),

            SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SubTitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical:  15),
              ),
                onPressed: onPressed,
                child: Text(buttonText,style: TextStyle(fontSize: 15),))
        ],
      ),
      ),
    );
  }
}
