import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String fullName;
  final String tcNo;
  final String city;
  final String district;
  final String postalCode;
  final String addressLine;
  final Timestamp? createdAt;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.tcNo,
    required this.city,
    required this.district,
    required this.postalCode,
    required this.addressLine,
    this.createdAt,
  });

  factory AddressModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      tcNo: data['tcNo'] ?? '',
      city: data['city'] ?? '',
      district: data['district'] ?? '',
      postalCode: data['postalCode'] ?? '',
      addressLine: data['addressLine'] ?? '',
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'tcNo': tcNo,
    'city': city,
    'district': district,
    'postalCode': postalCode,
    'addressLine': addressLine,
    'createdAt': createdAt,
  };
}