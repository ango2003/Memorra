import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';
import '../services/notif_service.dart';
import '../services/reminder_service.dart';
import '../models/reminder_list_model.dart';


class ReminderCollectionPage extends StatelessWidget {
  const ReminderCollectionPage({super.key});


  Future<DateTime?> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );


    if (!context.mounted || date == null) return null;


    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );


    if (!context.mounted || time == null) return null;


    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }


  int createUniqueID() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

/*
  void createNewReminder(BuildContext context) {
    final controller = TextEditingController();
    final timeController = TextEditingController();
    DateTime? selectedReminderDate;


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Reminder"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Reminder Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: const InputDecoration(
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
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final reminderListName = controller.text.trim();
              final notifID = createUniqueID();


<<<<<<< HEAD
=======
              if (reminderListName.isNotEmpty && selectedReminderDate != null) {
                await ReminderService.instance.addReminderList(
                  name: reminderListName,
                  reminderDate: selectedReminderDate!,
                  notifId: notifID,
                );
               
                //Add event stuff


                await NotifService.instance.scheduleWithTimer(
                  notifID,
                  reminderListName,
                  selectedReminderDate!,
                );


                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
*/

  void createNewReminder(BuildContext context) {
    final controller = TextEditingController();
    final timeController = TextEditingController();
    DateTime? selectedReminderDate;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final double boxCurve = 20;
    final titleFontSize = width * 0.05;
    final inputFontSize = width * 0.03;
    final buttonFontSize = width * 0.02;

    Color bgColor = isDark ? AppColors.popUpBGDark.withValues(alpha: 0.6) : AppColors.popUpBGLight;
    Color buttonBGColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight;
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color inputHintColor = isDark ? AppColors.hintTextDark : AppColors.hintTextLight;
    Color inputColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(boxCurve),
        ),
        backgroundColor: bgColor,
        title: Text(
          "Create New\nReminder",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleFontSize,
            color: titleColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              style: TextStyle(
                color: inputColor,
                fontSize: inputFontSize,
              ),
              decoration: InputDecoration(
                hintText: "Reminder Name",
                hintStyle: TextStyle(
                  color: inputHintColor,
                  fontSize: inputFontSize,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: inputHintColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: inputColor),
                ),
              ),
            ),

            const SizedBox(height: 16),
            
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: const InputDecoration(
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
            child: Text(
              "Cancel",
              style: TextStyle(
                color: titleColor,
                fontSize: buttonFontSize,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBGColor,
            ),
            onPressed: () async {
              final reminderListName = controller.text.trim();
              final notifID = createUniqueID();

>>>>>>> origin/main
              if (reminderListName.isNotEmpty && selectedReminderDate != null) {
                await ReminderService.instance.addReminderList(
                  name: reminderListName,
                  reminderDate: selectedReminderDate!,
                  notifId: notifID,
                );

                await NotifService.instance.scheduleWithTimer(
                  notifID,
                  reminderListName,
                  selectedReminderDate!,
                );


                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(
              "Create",
              style: TextStyle(
                color: titleColor,
                fontSize: buttonFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }


  void deleteReminder(BuildContext context, String reminderListID) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final double boxCurve = 20;
    final titleFontSize = width * 0.05;
    final subtitleFontSize = width * 0.03;
    final buttonFontSize = width * 0.025;

    Color bgColor = isDark ? AppColors.popUpBGDark.withValues(alpha: 0.6) : AppColors.popUpBGLight;
    Color buttonBGColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight;
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color subtitleColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(boxCurve),
        ),
        backgroundColor: bgColor,
        title: Text(
          "Delete Reminder",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleFontSize,
            color: titleColor,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this reminder?"
          "\n(You cannot undo once deleted)",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: subtitleColor,
            fontSize: subtitleFontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: titleColor,
                fontSize: buttonFontSize,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBGColor,
            ),
            onPressed: () async {
              await ReminderService.instance.deleteReminderList(reminderListID);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: TextStyle(
                color: titleColor,
                fontSize: buttonFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;


    final base = width < height ? width : height;

<<<<<<< HEAD

    final sizeboxSize = base * 0.05;
=======
    final sizeboxSize = base * 0.01;
>>>>>>> origin/main
    final titleFontSize = base * 0.08;
    final wPadding = width * 0.001;
    final hPadding = height * 0.01;

    final reminderFontSize = base * 0.04;
    final addIconSize = base * 0.06;
    final reminderLetterSpacing = 1.2;
    final subtitleFontSize = base * 0.02;
    final addFontSize = base * 0.035;
    final double reminderCornerRadius = 25;
    final double newReminderButtonHeight = base * 0.14;
    final double addBoxCurve = newReminderButtonHeight * 0.4;


    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color addButtonBackgroundColor = isDark ? AppColors.buttonBackgroundDark : AppColors.buttonBackgroundLight.withValues(alpha: 0.75);
    Color addButtonTextColor = isDark ? AppColors.buttonTextDark : AppColors.buttonTextLight;    
    Color reminderTextColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color subtitleColor = isDark ? AppColors.subtitleDark : AppColors.subtitleLight;
    Color reminderBoxColor = isDark ? AppColors.listBGDark.withValues(alpha: 0.4) : AppColors.listBGLight.withValues(alpha: 0.4);
    Color deletereminderIcon = isDark ? AppColors.deleteListDark : AppColors.deleteListLight;


    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        floatingActionButton: SizedBox(
          height: newReminderButtonHeight,
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(addBoxCurve),
            ),
            backgroundColor: addButtonBackgroundColor,
            foregroundColor: addButtonTextColor,
            onPressed: () => createNewReminder(context),
            icon: Icon(Icons.add, size: addIconSize),
            label: Text(
              "Add New\nReminder",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: addFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: sizeboxSize),


              /// Title
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding,
                  vertical: wPadding,
                ),
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

<<<<<<< HEAD

              SizedBox(height: sizeboxSize),
=======
              SizedBox(height: sizeboxSize * 5),
>>>>>>> origin/main


              /// Reminder List
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: StreamBuilder<List<ReminderList>>(
                  stream: ReminderService.instance.getReminderLists(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }


                    final reminderLists = snapshot.data!;


                    if (reminderLists.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            "No reminders yet",
                            style: TextStyle(
                              fontSize: base * 0.06,
                              color: titleColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      );
                    }


                    return Column(
                      children: reminderLists.map((list) {
                        return Container(
                          margin: EdgeInsets.only(bottom: sizeboxSize),
                          decoration: BoxDecoration(
                            color: reminderBoxColor,
                            borderRadius: BorderRadius.circular(reminderCornerRadius),
                          ),
                          child: ListTile(
                            title: Text(
                              list.name,
                              style: TextStyle(
                                color: reminderTextColor,
                                fontSize: reminderFontSize,
                                fontWeight: FontWeight.w400,
                                letterSpacing: reminderLetterSpacing,
                              ),
                            ),
                            subtitle: Text(
                              list.reminderDate.toLocal().toString(),
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: subtitleFontSize,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: deletereminderIcon,
                                size: reminderFontSize * 1.2,
                              ),
                              onPressed: () => deleteReminder(context, list.id),
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


        bottomNavigationBar: const NavBar(currentIndex: 1),
      ),
    );
  }
<<<<<<< HEAD
}



=======
}
>>>>>>> origin/main
