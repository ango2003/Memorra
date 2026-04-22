import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/reminder_list_model.dart';
import '../models/reminder_model.dart';

class ReminderService {
  ReminderService.privateConstructor();
  static final ReminderService instance = ReminderService.privateConstructor();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get userId => auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _reminderListsRef {
    return firestore.collection('accounts').doc(userId).collection('reminder_lists');
  }

  CollectionReference<Map<String, dynamic>> _remindersRef(String listID) {
    return _reminderListsRef.doc(listID).collection('reminders');
  }

  Stream<List<ReminderList>> getReminderLists() {
    return _reminderListsRef
        .orderBy('reminder_date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReminderList.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<ReminderList> fetchReminderList(String listID) async {
    final doc = await _reminderListsRef.doc(listID).get();
    if (!doc.exists) {
      throw Exception('Reminder list not found');
    }
    return ReminderList.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> addReminderList({
    required String name,
    required DateTime reminderDate,
    required int notifId,
  }) async {
    await _reminderListsRef.add({
      'reminder_name': name,
      'reminder_date': Timestamp.fromDate(reminderDate),
      'notif_ID': notifId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteReminderList(String listID) async {
    await _reminderListsRef.doc(listID).delete();
  }

  Stream<List<Reminder>> getReminders(String listID) {
    return _remindersRef(listID)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reminder.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> addReminder(
    String listID,
    String name,
    String category,
  ) async {
    await _remindersRef(listID).add({
      'name': name,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteReminder(String listID, String reminderID) async {
    await _remindersRef(listID).doc(reminderID).delete();
  }
}
