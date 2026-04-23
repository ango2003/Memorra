import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodayReminders extends StatelessWidget {
  const TodayReminders({super.key});
  
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    Timestamp.fromDate(startOfDay);
    Timestamp.fromDate(endOfDay);

    final stream = FirebaseFirestore.instance
        .collection('accouns')
        .doc('user_id')
        .collection('reminder_lists')
        .where('reminder_date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),)
        .where('reminder_date', isLessThan: Timestamp.fromDate(endOfDay),)
        .orderBy('reminder_date')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No reminders for today'));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index];

            final time = (data['reminder_date'] as Timestamp).toDate();

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.alarm),
                title: Text(data['title'] ?? ''),
                trailing: Text(TimeOfDay.fromDateTime(time).format(context)),
              )
            );
          }
        );
      },
    );
  }
}