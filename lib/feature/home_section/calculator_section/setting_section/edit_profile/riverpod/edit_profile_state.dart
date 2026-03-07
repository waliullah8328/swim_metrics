class ProfileState {
  final String name;
  final String email;
  final String phone;

  ProfileState({
    this.name = "",
    this.email = "",
    this.phone = "",
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

