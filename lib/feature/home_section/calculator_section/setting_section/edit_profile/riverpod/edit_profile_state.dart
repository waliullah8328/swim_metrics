import 'dart:io';

class ProfileState {
  final String name;
  final String email;
  final String phone;
  final File? profileImage;

  ProfileState({
    this.name = "",
    this.email = "",
    this.phone = "",
    this.profileImage,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    File? profileImage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

