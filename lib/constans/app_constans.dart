
import 'package:ecommerce_flutter/models/categories_model.dart';
import 'package:ecommerce_flutter/services/assets_manages.dart';

class AppConstans {

  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static List<String> bannerImages = [
    AssetsManager.slide1,
    AssetsManager.slide2,
    AssetsManager.slide3,
    AssetsManager.slide4,
    AssetsManager.slide5,
    AssetsManager.slide6,
    AssetsManager.slide7,
  ];
  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "Bilgisayar",
      name: "Bilgisayar",
      image: AssetsManager.computer,
    ),
    CategoriesModel(
      id: "Telefon",
      name: "Telefon",
      image: AssetsManager.mobilephone,
    ),
    CategoriesModel(
      id: "Kamera",
      name: "Kamera",
      image: AssetsManager.camera,
    ),
    CategoriesModel(
      id: "Kitap",
      name: "Kitap",
      image: AssetsManager.bookss,
    ),
    CategoriesModel(
      id: "TV",
      name: "TV",
      image: AssetsManager.tv,
    ),
    CategoriesModel(
      id: "T-shirt",
      name: "T-shirt",
      image: AssetsManager.tshort,
    ),
    CategoriesModel(
      id: "Ayakkabı",
      name: "Ayakkabı",
      image: AssetsManager.shoes3,
    ),
  ];
}