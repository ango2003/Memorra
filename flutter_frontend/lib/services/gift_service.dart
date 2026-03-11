import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/gift_model.dart';
import '../models/gift_list_model.dart';

class GiftService {
  GiftService.privateConstructor();
  static final GiftService instance = GiftService.privateConstructor(); 
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get userId => auth.currentUser!.uid;

  // Fetch gift lists for the current user
  Stream<List<GiftList>> getGiftLists() {
    return firestore
        .collection('accounts')
        .doc(userId)
        .collection('gift_lists')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GiftList.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> addGiftList(String recipient) async {
    await firestore
      .collection('accounts')
      .doc(userId)
      .collection('gift_lists')
      .add({
        'gift_recipient': recipient,
        'createdAt' : FieldValue.serverTimestamp(),
      });
  }

  Future<void> deleteGiftList(String listID) async {

    await firestore
        .collection('accounts')
        .doc(userId)
        .collection('gift_lists')
        .doc(listID)
        .delete();
  }

  // Create gift for a specific list
  Stream<List<Gift>> getGifts(String listID) {
    return firestore
        .collection('accounts')
        .doc(userId)
        .collection('gift_lists')
        .doc(listID)
        .collection('gifts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Gift.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> addGift(String listID, String name, String category) async {
    await firestore
      .collection('accounts')
      .doc(userId)
      .collection('gift_lists')
      .doc(listID)
      .collection('gifts')
      .add({
        'name': name, 
        'category': category,
        'createdAt' : FieldValue.serverTimestamp(),
      });
  }

  Future<void> deleteGift(String listID, String giftID) async {
    await firestore
        .collection('accounts')
        .doc(userId)
        .collection('gift_lists')
        .doc(listID)
        .collection('gifts')
        .doc(giftID)
        .delete();
  }
}