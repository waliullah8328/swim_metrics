import 'dart:convert';

UserPlanModel userPlanModelFromJson(String str) =>
    UserPlanModel.fromJson(json.decode(str));

String userPlanModelToJson(UserPlanModel data) =>
    json.encode(data.toJson());

class UserPlanModel {
  final String? plan;
  final List<String> features;
  final DateTime? planStartDate;
  final DateTime? planEndDate;
  final int? remainingDays;
  final double? actualPrice;
  final double? youHavePaid;
  final String? promo; // ✅ better type
  final double? discountPercentage; // ✅ better type

  UserPlanModel({
    this.plan,
    required this.features,
    this.planStartDate,
    this.planEndDate,
    this.remainingDays,
    this.actualPrice,
    this.youHavePaid,
    this.promo,
    this.discountPercentage,
  });

  factory UserPlanModel.fromJson(Map<String, dynamic> json) {
    return UserPlanModel(
      plan: json["plan"],

      // ✅ SAFE list parsing
      features: json["features"] == null
          ? []
          : List<String>.from(json["features"].map((x) => x.toString())),

      planStartDate: json["plan_start_date"] != null
          ? DateTime.parse(json["plan_start_date"])
          : null,

      planEndDate: json["plan_end_date"] != null
          ? DateTime.parse(json["plan_end_date"])
          : null,

      remainingDays: json["remaining_days"],

      // ✅ safe double parsing
      actualPrice: (json["actual_price"] as num?)?.toDouble(),
      youHavePaid: (json["you_have_paid"] as num?)?.toDouble(),

      promo: json["promo"]?.toString(),

      discountPercentage:
      (json["discount_percentage"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "plan": plan,
    "features": features,
    "plan_start_date": planStartDate?.toIso8601String(),
    "plan_end_date": planEndDate?.toIso8601String(),
    "remaining_days": remainingDays,
    "actual_price": actualPrice,
    "you_have_paid": youHavePaid,
    "promo": promo,
    "discount_percentage": discountPercentage,
  };
}