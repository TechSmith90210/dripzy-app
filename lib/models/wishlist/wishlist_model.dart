import 'dart:convert';
import 'wishlist_item_model.dart';

class Wishlist {
  final List<WishlistItem> items;

  const Wishlist({
    required this.items,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => WishlistItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  Wishlist copyWith({
    List<WishlistItem>? items,
  }) {
    return Wishlist(
      items: items ?? this.items,
    );
  }

  static Wishlist fromJsonString(String jsonString) =>
      Wishlist.fromJson(json.decode(jsonString));

  String toJsonString() => json.encode(toJson());
}
