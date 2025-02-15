class UserData {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? role;
  double? walletBalance;
  String? createdAt;

  UserData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.role,
    this.walletBalance,
    this.createdAt,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
    walletBalance = json['walletBalance']?.toDouble();
    createdAt = json['createdAt'];
  }

  /// Use this JSON when adding a new user
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id ?? DateTime.now().millisecondsSinceEpoch.toString();
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['role'] = role;
    data['walletBalance'] = walletBalance ?? 0.0;
    data['createdAt'] = createdAt ?? DateTime.now().toString();
    return data;
  }
}
