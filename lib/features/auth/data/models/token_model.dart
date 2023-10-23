
class TokenModel {
  final String token;

  TokenModel({
    required this.token,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json['token'],
    );
  }
}
