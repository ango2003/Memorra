import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/validation_service.dart';
import '../widgets/nav_bar.dart';
import '../models/reminder_model.dart';
import '../services/reminder_service.dart';

class ListPage extends StatefulWidget {
  final String listID;

  const ListPage({super.key, required this.listID});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool _isDialogOpen = false;

  void createNewItem(BuildContext context, String listID) {
    if (_isDialogOpen) return; // guard: ignore extra taps
    _isDialogOpen = true;

    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Add New Reminder Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                enabled: !isLoading,
                decoration:
                    const InputDecoration(hintText: "Reminder Name"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                enabled: !isLoading,
                decoration:
                    const InputDecoration(hintText: "Reminder Category"),
              ),
              if (isLoading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final reminderName = nameController.text.trim();
                      final reminderCategory =
                          categoryController.text.trim();

                      final nameError = ValidationService.validateTextField(
                        reminderName,
                        "Reminder name",
                        minLength: 1,
                        maxLength: 100,
                      );
                      if (nameError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(nameError),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      if (reminderCategory.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a category"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      setDialogState(() => isLoading = true);

                      try {
                        await ReminderService.instance.addReminder(
                          listID,
                          reminderName,
                          reminderCategory,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Reminder added successfully!"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error adding reminder: $e"),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        setDialogState(() => isLoading = false);
                      }
                    },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    ).whenComplete(() => _isDialogOpen = false); // always release the guard
  }

  void deleteReminder(BuildContext context, String listID, String reminderID) {
    if (_isDialogOpen) return; // guard: ignore extra taps
    _isDialogOpen = true;

    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Delete Reminder Item"),
          content: isLoading
              ? const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                )
              : const Text(
                  "Are you sure you want to delete this reminder item?"),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setDialogState(() => isLoading = true);

                      try {
                        await ReminderService.instance
                            .deleteReminder(listID, reminderID);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Reminder deleted successfully!"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error deleting reminder: $e"),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        setDialogState(() => isLoading = false);
                      }
                    },
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    ).whenComplete(() => _isDialogOpen = false);
  }

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
                  onPressed: () => deleteReminder(
                      context, widget.listID, reminder.id),
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