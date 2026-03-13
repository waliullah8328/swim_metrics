

import 'dart:convert';

GetMeModel getMeFromJson(String str) => GetMeModel.fromJson(json.decode(str));

String getMeToJson(GetMeModel data) => json.encode(data.toJson());

class GetMeModel {
  int? id;
  String? name;
  String? email;
  dynamic phone;
  String? profilePicture;


  GetMeModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profilePicture,
  });

  factory GetMeModel.fromJson(Map<String, dynamic> json) => GetMeModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profilePicture: json["profile_picture"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "profile_picture": profilePicture,
  };
}
