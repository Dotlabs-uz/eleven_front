class RequestSmsCodeModel {
  final String phoneNumber;

  RequestSmsCodeModel({
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['phone'] = phoneNumber;

    return data;
  }
}
