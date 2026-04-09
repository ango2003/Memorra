import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/nav_bar.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';
import '../services/notif_service.dart';

class ReminderCollectionPage extends StatelessWidget {
  const ReminderCollectionPage({super.key});

  Future<DateTime?> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  int createUniqueID() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  void createNewReminder(BuildContext context) {
    final controller = TextEditingController();
    final timeController = TextEditingController();
    DateTime? selectedReminderDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Reminder"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Reminder Name"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Select Reminder Date & Time",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final selectedDateTime = await pickDate(context);
                if (selectedDateTime != null) {
                  selectedReminderDate = selectedDateTime;
                  timeController.text = selectedDateTime.toString();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final userID = FirebaseAuth.instance.currentUser!.uid;
              final reminderListName = controller.text.trim();
              final notifID = createUniqueID();

              if (reminderListName.isNotEmpty && selectedReminderDate != null) {
                if (context.mounted) Navigator.pop(context);

                await FirebaseFirestore.instance
                    .collection('accounts')
                    .doc(userID)
                    .collection('reminder_lists')
                    .add({
                  'reminder_name': reminderListName,
                  'reminder_date': selectedReminderDate,
                  'notif_ID': notifID,
                });

                await NotifService.instance.scheduleWithTimer(
                  notifID,
                  reminderListName,
                  selectedReminderDate!,
                );
              }
            },
            child: Text("Create"),
          ),
        ],
      ),
    );
  }

  void deleteReminder(BuildContext context, String reminderListID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Reminder"),
        content: Text("Are you sure you want to delete this reminder?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final userID = FirebaseAuth.instance.currentUser!.uid;

              await FirebaseFirestore.instance
                  .collection('accounts')
                  .doc(userID)
                  .collection('reminder_lists')
                  .doc(reminderListID)
                  .delete();

              if (context.mounted) Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser!.uid;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final titleFontSize = base * 0.08;
    final hPadding = width * 0.01;
    final wPadding = height * 0.01;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () => createNewReminder(context),
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: sizeboxSize),

              /// Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: wPadding),
                child: Text(
                  "Your Reminders",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),

              /// Divider
              Divider(
                color: isDark ? Colors.white : Colors.black54,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),

              SizedBox(height: sizeboxSize),

              /// Reminder List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('accounts')
                      .doc(userID)
                      .collection('reminder_lists')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            "No reminders yet",
                            style: TextStyle(
                              fontSize: base * 0.06,
                              color: titleColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final reminderID = doc.id;

                        final date = data['reminder_date'] != null
                            ? (data['reminder_date'] as Timestamp).toDate()
                            : null;

                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.only(bottom: sizeboxSize),
                          child: ListTile(
                            title: Text(data['reminder_name']),
                            subtitle: Text(
                              date != null
                                  ? date.toLocal().toString()
                                  : "No date set",
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deleteReminder(context, reminderID),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: NavBar(currentIndex: 1),
      ),
    );
  }
}
