import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class TodayReminders extends StatelessWidget {
  const TodayReminders({super.key});
  
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final userId = FirebaseAuth.instance.currentUser!.uid;

    Timestamp.fromDate(startOfDay);
    Timestamp.fromDate(endOfDay);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final double fontSize = base * 0.02;
    final FontWeight fontWeight = FontWeight.w600;

    Color reminderColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;

    final stream = FirebaseFirestore.instance
        .collection('accounts')
        .doc(userId)
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
          return Center(
            child: Text(
              'You currently have no reminders set to go off today.\nCheck the reminders page to see all of your schedules reminders.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: reminderColor,
                fontSize: fontSize * 2,
                fontWeight: fontWeight,
              )
            )
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index];

            final time = (data['reminder_date'] as Timestamp).toDate();

            return Card(
              color: Colors.transparent,
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: Icon(
                  Icons.alarm,
                  color: reminderColor,
                ),
                title: Text(
                  data['reminder_name'] ?? '',
                  style: TextStyle(
                    color: reminderColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
                trailing: Text(
                  TimeOfDay.fromDateTime(time).format(context),
                  style: TextStyle(
                    color: reminderColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              )
            );
          }
        );
      },
    );
  }
}