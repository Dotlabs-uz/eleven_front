
class TokenModel {
  final bool status;
  final String token;

  TokenModel({
    required this.status,
    required this.token,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      status: json['status'],
      token: json['token'],
    );
  }
}
