import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter_frontend/models/user_model.dart';
import 'package:flutter_frontend/services/validation_service.dart';
import '../widgets/today_reminders.dart';
import '../widgets/home_tile.dart';
import '../widgets/nav_bar.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';
import '../services/reminder_service.dart';
import '../services/notif_service.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDialogOpen = false;
  AppUser? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final fetchedUser = await authService.value.fetchUser(widget.userId);
      if (mounted) {
        setState(() {
          user = fetchedUser;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

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

    return DateTime(
        date.year, date.month, date.day, time.hour, time.minute);
  }

    int createUniqueID() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  void createNewReminder(BuildContext context) {
    if (_isDialogOpen) return; // guard: ignore extra taps
    _isDialogOpen = true;

    final controller = TextEditingController();
    final timeController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedReminderDate;
    bool isLoading = false;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;

    const double boxCurve = 20;
    final titleFontSize = width * 0.05;
    final inputFontSize = width * 0.03;
    final buttonFontSize = width * 0.02;

    Color bgColor = isDark
        ? AppColors.popUpBGDark.withValues(alpha: 0.9)
        : AppColors.popUpBGLight;
    Color buttonBGColor = isDark
        ? AppColors.buttonBackgroundDark
        : AppColors.buttonBackgroundLight;
    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color inputHintColor =
        isDark ? AppColors.hintTextDark : AppColors.hintTextLight;
    Color inputColor =
        isDark ? AppColors.subtitleDark : AppColors.subtitleLight;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(boxCurve),
          ),
          backgroundColor: bgColor,
          title: Text(
            "Create New\nReminder",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: titleFontSize, color: titleColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                enabled: !isLoading,
                style: TextStyle(color: inputColor, fontSize: inputFontSize),
                decoration: InputDecoration(
                  hintText: "Reminder Name",
                  hintStyle: TextStyle(
                      color: inputHintColor, fontSize: inputFontSize),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: inputHintColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: inputColor),
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                enabled: !isLoading,
                style: TextStyle(color: inputColor, fontSize: inputFontSize),
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(
                      color: inputHintColor, fontSize: inputFontSize),
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
                enabled: !isLoading,
                decoration: const InputDecoration(
                  hintText: "Select Reminder Date & Time",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: isLoading
                    ? null
                    : () async {
                        final selectedDateTime = await pickDate(context);
                        if (selectedDateTime != null) {
                          setDialogState(() {
                            selectedReminderDate = selectedDateTime;
                            timeController.text =
                                selectedDateTime.toString();
                          });
                        }
                      },
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
              child: Text(
                "Cancel",
                style:
                    TextStyle(color: titleColor, fontSize: buttonFontSize),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: buttonBGColor),
              onPressed: isLoading
                  ? null
                  : () async {
                      final reminderListName = controller.text.trim();

                      final nameError = ValidationService.validateTextField(
                        reminderListName,
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
                      if (selectedReminderDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a date and time"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      setDialogState(() => isLoading = true);

                      try {
                        final notifID = createUniqueID();

                        await ReminderService.instance.addReminderList(
                          name: reminderListName,
                          reminderDate: selectedReminderDate!,
                          description: descriptionController.text.trim(),
                          notifId: notifID,
                        );

                        await NotifService.instance.scheduleWithTimer(
                          notifID,
                          reminderListName,
                          selectedReminderDate!,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Reminder created successfully!"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error creating reminder: $e"),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        setDialogState(() => isLoading = false);
                      }
                    },
              child: Text(
                "Create",
                style:
                    TextStyle(color: titleColor, fontSize: buttonFontSize),
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() => _isDialogOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final titleFontSize = base * 0.08;
    final fontSize = base * 0.08;
    final horizontalSpacing = width * 0.02;
    final hPadding = width * 0.01;
    final wPadding = height * 0.01;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;

    if (isLoading) {
      return AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: sizeboxSize),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: wPadding),
                child: Text(
                  "How Can We Help ${user?.name ?? 'Today'}?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
              Divider(
               color: titleColor,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: sizeboxSize),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Today's Reminders:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: titleFontSize * 0.6,
                                  fontWeight: FontWeight.bold,
                                  color: titleColor,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const SizedBox(
                                height: 300,
                                child: TodayReminders(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizeboxSize),
                    Row(
                      children: [
                        Expanded(
                          child: HomeTile(
                            title: "Go to Reminders",
                            onTap: () {
                              Navigator.pushNamed(context, '/reminderpage');
                            },
                            inMiddle: true,
                            alignment: CrossAxisAlignment.center,
                          ),
                        ),
                        SizedBox(width: horizontalSpacing),
                        Expanded(
                          child: HomeTile(
                            title: "Friend Gift Ideas",
                            onTap: () {
                              Navigator.pushNamed(context, '/wip');
                            },
                            inMiddle: true,
                            alignment: CrossAxisAlignment.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizeboxSize),
                    Row(
                      children: [
                        Expanded(
                          child: HomeTile(
                            title: "Set New Reminder",
                            onTap: () {
                              createNewReminder(context);
                            },
                            inMiddle: false,
                            alignment: CrossAxisAlignment.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizeboxSize),
                  ],
                ),
              )
            ],
          )        
        ),
        bottomNavigationBar: NavBar(
          currentIndex: 0,
        ),
      ),
    );
  }
}
