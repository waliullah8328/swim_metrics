// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) => PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  final int? id;
  final String? name;
  final double? price;
  final List<Feature>? features;

  PaymentModel({
    this.id,
    this.name,
    this.price,
    this.features,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: json["id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toJson())),
  };
}

class Feature {
  final int? id;
  final String? featureName;

  Feature({
    this.id,
    this.featureName,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json["id"],
    featureName: json["feature_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "feature_name": featureName,
  };
}
