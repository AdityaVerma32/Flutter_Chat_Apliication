class ChatUser {
  ChatUser({
    required this.LastActive,
    required this.image,
    required this.about,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.pushToken,
    required this.name,
    required this.email,
  });
  late String LastActive;
  late String image;
  late String about;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String pushToken;
  late String name;
  late String email;

  // Converting Json data to dart Object

  ChatUser.fromJson(Map<String, dynamic> json) {
    LastActive = json['Last_active'] ?? "";
    image = json['image'] ?? "";
    about = json['about'] ?? "";
    createdAt = json['created_at'] ?? "";
    isOnline = json['is_online'] ?? "";
    id = json['id'] ?? "";
    pushToken = json['push_token'] ?? "";
    name = json['name'] ?? "";
    email = json['email'] ?? "";
  }

  // When we need to send data top server
  // Data can be converted to json
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Last_active'] = LastActive;
    data['image'] = image;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['push_token'] = pushToken;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
