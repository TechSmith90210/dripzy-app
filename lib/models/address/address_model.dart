class Address {
  final String id;
  final String userId;
  final bool isDefault;
  final String label;
  final String? receiverName;
  final String phone;
  final String line1;
  final String? line2;
  final String postalCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Address({
    required this.id,
    required this.userId,
    required this.isDefault,
    required this.label,
    required this.receiverName,
    required this.phone,
    required this.line1,
    required this.line2,
    required this.postalCode,
    this.createdAt,
    this.updatedAt,
  });

  // ---------------- JSON -> Model ----------------
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      isDefault: json['is_default'] ?? false,
      label: json['label'] ?? '',
      receiverName: json['receiver_name'],
      phone: json['phone'] ?? '',
      line1: json['line1'] ?? '',
      line2: json['line2'],
      postalCode: json['postal_code'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'is_default': isDefault,
      'label': label,
      'receiver_name': receiverName,
      'phone': phone,
      'line1': line1,
      'line2': line2,
      'postal_code': postalCode,
    };
  }

  Address copyWith({
    String? id,
    String? userId,
    bool? isDefault,
    String? label,
    String? receiverName,
    String? phone,
    String? line1,
    String? line2,
    String? postalCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      isDefault: isDefault ?? this.isDefault,
      label: label ?? this.label,
      receiverName: receiverName ?? this.receiverName,
      phone: phone ?? this.phone,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      postalCode: postalCode ?? this.postalCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}