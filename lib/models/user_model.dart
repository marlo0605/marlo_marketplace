// ============================================================
// MODEL: user_model.dart
// Bertanggung jawab menyimpan data pengguna
// ============================================================
 
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final List<AddressModel> addresses;
  final int loyaltyPoints;
 
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.addresses = const [],
    this.loyaltyPoints = 0,
  });
 
  AddressModel? get defaultAddress {
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
  }
 
  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<AddressModel>? addresses,
    int? loyaltyPoints,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      addresses: addresses ?? this.addresses,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    );
  }
}
 
class AddressModel {
  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final bool isDefault;
 
  AddressModel({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    this.isDefault = false,
  });
 
  String get fullAddress => '$address, $city, $province $postalCode';
 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'recipientName': recipientName,
      'phone': phone,
      'address': address,
      'city': city,
      'province': province,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }
 
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      label: map['label'],
      recipientName: map['recipientName'],
      phone: map['phone'],
      address: map['address'],
      city: map['city'],
      province: map['province'],
      postalCode: map['postalCode'],
      isDefault: map['isDefault'] ?? false,
    );
  }
}