class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final bool isVerified;
  final bool isActive;
  final bool isGuest;
  final bool isPro;
  final int proLevel;
  final DateTime? proExpiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userType;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.isVerified = false,
    this.isActive = true,
    this.isGuest = false,
    this.isPro = false,
    this.proLevel = 1,
    this.proExpiryDate,
    required this.createdAt,
    required this.updatedAt,
    this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'isVerified': isVerified,
      'isActive': isActive,
      'isGuest': isGuest,
      'isPro': isPro,
      'proLevel': proLevel,
      'proExpiryDate': proExpiryDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userType': userType,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      isGuest: json['isGuest'] ?? false,
      isPro: json['isPro'] ?? false,
      proLevel: json['proLevel'] ?? 1,
      proExpiryDate: json['proExpiryDate'] != null 
          ? DateTime.parse(json['proExpiryDate']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userType: json['userType'],
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? isVerified,
    bool? isActive,
    bool? isGuest,
    bool? isPro,
    int? proLevel,
    DateTime? proExpiryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userType,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      isGuest: isGuest ?? this.isGuest,
      isPro: isPro ?? this.isPro,
      proLevel: proLevel ?? this.proLevel,
      proExpiryDate: proExpiryDate ?? this.proExpiryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userType: userType ?? this.userType,
    );
  }
}
