import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistItem {
  final String id;
  final String name;
  final String category;

  WishlistItem({
    required this.id,
    required this.name,
    required this.category,
  });

  factory WishlistItem.fromFirestore(Map<String, dynamic> data, String id) {
    return WishlistItem(
      id: id,
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? 'Other',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
    };
  }
}

class AppUser {
  String? id;
  String? name;
  String? email;
  String? profilePictureUrl;
  List<String> interests;
  List<WishlistItem> wishlist;

  AppUser({
    this.id,
    this.name,
    this.email,
    this.profilePictureUrl,
    List<String>? interests,
    List<WishlistItem>? wishlist,
  })  : interests = interests ?? [],
        wishlist = wishlist ?? [];

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final fullName =
        data['name'] as String? ??
        '${data['firstName'] as String? ?? ''} ${data['lastName'] as String? ?? ''}'
            .trim();

    return AppUser(
      id: doc.id,
      name: fullName.isNotEmpty ? fullName : null,
      email: data['email'] as String?,
      profilePictureUrl: data['profilePictureUrl'] as String?,
      interests: List<String>.from(data['interests'] ?? []),
      // wishlist is loaded separately from subcollection
    );
  }

  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(
      id: user.uid,
      name: user.displayName,
      email: user.email,
      profilePictureUrl: user.photoURL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
      'interests': interests,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
      'interests': interests,
    };
  }
}