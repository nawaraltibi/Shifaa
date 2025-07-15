class UserAuthModel {
  final bool hasAccount;
  final bool twoFactorEnabled;
  final String? token;
  final Map<String, dynamic>? user;

  UserAuthModel({
    required this.hasAccount,
    required this.twoFactorEnabled,
    this.token,
    this.user,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return UserAuthModel(
      hasAccount: data['has_account'] ?? false,
      twoFactorEnabled: data['two_factor_enabled'] ?? false,
      token: data['token'],
      user: data['user'],
    );
  }
}
