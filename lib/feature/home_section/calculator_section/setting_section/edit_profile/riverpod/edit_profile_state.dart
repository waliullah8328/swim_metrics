import 'dart:io';

class ProfileState {
  final String name;
  final String email;
  final String phone;
  final File? profileImage;
  final bool isLoading;
  final bool isPasswordLoading;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ProfileState({
    this.name = "",
    this.email = "",
    this.phone = "",
    this.profileImage,
    this.isLoading = false,
    this.newPassword = '',
    this.confirmPassword = '',
    this.currentPassword = '',
    this.isPasswordLoading = false,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    File? profileImage,
    bool? isLoading,
    String? newPassword,
    String? confirmPassword,
    String? currentPassword,
    bool? isPasswordLoading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      isLoading: isLoading??this.isLoading,
      newPassword: newPassword?? this.newPassword,
      confirmPassword: confirmPassword?? this.confirmPassword,
      currentPassword: currentPassword?? this.currentPassword,
      isPasswordLoading: isPasswordLoading??this.isPasswordLoading
    );
  }
}

