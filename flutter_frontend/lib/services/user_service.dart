import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

const List<String> kUserCategories = [
  'Books',
  'Electronics',
  'Clothing',
  'Food & Drink',
  'Gaming',
  'Music',
  'Sports',
  'Travel',
  'Beauty',
  'Home & Garden',
  'Toys',
  'Movies & TV',
  'Other',
];

class UserService {
  UserService._privateConstructor();
  static final UserService instance = UserService._privateConstructor();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  Future<AppUser?> fetchUser(String userId) async {
  try {
    final user = await authService.value.fetchUser(userId);
    user.wishlist = await fetchWishlist(userId);
    return user;
  } catch (e) {
    return null;
  }
}

  Future<List<WishlistItem>> fetchWishlist(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .get();
    return snapshot.docs
        .map((doc) => WishlistItem.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateInterests(List<String> interests) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .update({'interests': interests});
  }

  Future<void> addWishlistItem(String name, String category) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('wishlist')
        .add({'name': name, 'category': category});
  }

  Future<void> removeWishlistItem(String itemId) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('wishlist')
        .doc(itemId)
        .delete();
  }
}