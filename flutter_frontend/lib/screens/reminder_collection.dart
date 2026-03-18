import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_frontend/widgets/nav_bar.dart';
import 'package:flutter_frontend/services/notif_service.dart';

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

    return DateTime(
      date.year, 
      date.month, 
      date.day, 
      time.hour, 
      time.minute
    );
  }

  int createUniqueID() { // Generate a unique ID based on the current timestamp
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  void createNewReminder(BuildContext context ) {
    // Controllers and variable to store selected date and time
    final controller  = TextEditingController();
    final timeController = TextEditingController();
    DateTime? selectedReminderDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Reminder List"),
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
                  selectedReminderDate = selectedDateTime; // Store the selected date and time in a variable
                  timeController.text = selectedDateTime.toString();
                }
                
              },
            )
          ]
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final userID = FirebaseAuth.instance.currentUser!.uid;
              final reminderListName = controller.text.trim();
              final int notifID = createUniqueID(); // Generate a unique notification ID for this reminder
              if (reminderListName.isNotEmpty) {

                if (context.mounted) {
                  Navigator.pop(context);
                }
                await FirebaseFirestore.instance
                    .collection('accounts')
                    .doc(userID)
                    .collection('reminder_lists')
                    .add({ // Add both the reminder name and the selected date and time to Firestore
                      'reminder_name': reminderListName,
                      'reminder_date': selectedReminderDate,
                      'notif_ID': notifID, // Generate a unique notification ID for this reminder
                    });
                // await NotifService.instance.scheduleNotification( // Schedule a local notification for the selected date and time
                //   id: notifID, // Use the unique notification ID generated for this reminder
                //   title: reminderListName,
                //   body: "You have a reminder set for ${selectedReminderDate.toString()}",
                //   scheduledDate: selectedReminderDate!,
                // );

                await NotifService.instance.scheduleWithTimer(
                  notifID, // Use the unique notification ID generated for this reminder
                  reminderListName,
                  "You have a reminder set for ${selectedReminderDate.toString()}",
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
        title: Text("Delete Reminder List"),
        content: Text("Are you sure you want to delete this reminder list?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final userID = FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

    return Scaffold(
      appBar: AppBar(title: Text("Reminders")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewReminder(context),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance // Access Firestore instance
            .collection('accounts')
            .doc(userID)
            .collection('reminder_lists')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data

          final docs = snapshot.data!.docs; // Get list of documents in the 'reminder_lists' collection
          
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>; // Get data of each document as a Map
              final reminderlistID = docs[index].id;
              return ListTile(
                title: Text(data['reminder_name']),
                subtitle: Text(data['reminder_date'] != null 
                  ? DateTime.parse(data['reminder_date'].toDate().toString()).toLocal().toString() 
                  : "No date set"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteReminder(context, reminderlistID),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 3,
      ),
    );
  }
}