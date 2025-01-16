


class CurrentUser {
  String? email;
  String? password;
  String? fcmToken;
  String? fullName;
  String? apiKey;
  String? userId;
  String? image;
  String? locale;
  String? phone;
  String? userName;
  String? citiesId;


  CurrentUser({
    this.userId,
    this.email,
    this.password,
    this.fullName,
    this.apiKey,
    this.fcmToken,
    this.image,
    this.locale,
    this.userName,
    this.citiesId,
    this.phone,

  });

  CurrentUser.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    fullName = json['full_name'];
    image = json['image'];
    apiKey = json['api_key'];
    fcmToken = json['fcmToken'];
    locale = json['locale'];
    userName = json['user_name'];

  }

}