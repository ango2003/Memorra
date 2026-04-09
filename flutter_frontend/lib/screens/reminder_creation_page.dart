import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../models/reminder_model.dart';
import '../services/reminder_service.dart';

class ListPage extends StatefulWidget {
  final String listID;

  const ListPage({super.key, required this.listID});

  @override
  State<ListPage> createState() => _ListPageState();
}

void createNewItem(BuildContext context, String listID) {
  final nameController = TextEditingController();
  final categoryController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Add New Reminder Item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Reminder Name"),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: categoryController,
            decoration: const InputDecoration(hintText: "Reminder Category"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final reminderName = nameController.text.trim();
            final reminderCategory = categoryController.text.trim();
            if (reminderName.isNotEmpty) {
              await ReminderService.instance.addReminder(
                listID,
                reminderName,
                reminderCategory,
              );
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text("Add"),
        ),
      ],
    ),
  );
}

void deleteGift(BuildContext context, String listID, String reminderID) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Reminder Item"),
      content: const Text(
        "Are you sure you want to delete this reminder item?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await ReminderService.instance.deleteReminder(listID, reminderID);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Page")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewItem(context, widget.listID),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Reminder>>(
        stream: ReminderService.instance.getReminders(widget.listID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reminders = snapshot.data!;

          if (reminders.isEmpty) {
            return const Center(child: Text('No reminder items yet'));
          }

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return ListTile(
                title: Text(reminder.name),
                subtitle: Text(reminder.category),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      deleteGift(context, widget.listID, reminder.id),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const NavBar(currentIndex: -1),
    );
  }
}
