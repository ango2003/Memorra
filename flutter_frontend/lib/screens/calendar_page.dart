import 'package:flutter/material.dart';
import '../models/reminder_list_model.dart';
import '../services/reminder_service.dart';
import '../widgets/background.dart';
import '../widgets/nav_bar.dart';
import '../themes/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final Stream<List<ReminderList>> _reminderStream;
  DateTime _currentDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
     _reminderStream = ReminderService.instance.getReminderLists();
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

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(""),
        ),
        body: Column(
          children: [
            Text(
              'Calendar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<List<ReminderList>>(
                stream: _reminderStream,
                builder:(context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error state
                  if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load requests'));
                  }

                  final reminders = snapshot.data ?? [];
                  final selectedReminders = reminders.where((reminder) {return isSameDay(reminder.reminderDate, _selectedDay);}).toList();

                  return Column(
                    children: [
                      TableCalendar(
                        focusedDay: _currentDay,
                        firstDay: DateTime.utc(2026, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),

                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },

                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _currentDay = focusedDay;
                          });
                        },
                      ),

                      SizedBox(height: sizeboxSize),

                      Expanded(
                        child: selectedReminders.isEmpty
                          ?  Center(
                            child: Text(
                              _selectedDay == null
                                ? 'Tap a date to view reminders'
                                : 'No reminders for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                              style: TextStyle(
                                fontSize: fontSize,
                                color: titleColor,
                              ),
                            )
                          )
                          : ListView.builder(
                            itemCount: selectedReminders.length,
                            itemBuilder: (context, index) {
                              final reminder = selectedReminders[index];
                              return ListTile(
                                title: Text(reminder.name),
                                subtitle: Text(reminder.reminderDate.toString()),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                }
              )
            ),
            ],
          ),
          bottomNavigationBar: NavBar(
            currentIndex: 1,
          ),
        ),
    );
  }
}