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
    final calendarFontSize = base * 0.05;
    final horizontalSpacing = width * 0.02;
    final hPadding = width * 0.01;
    final wPadding = height * 0.01;
    final dividerThickness = height * 0.005;
    final dividerIndent = width * 0.075;
    final double dividerCurve = 45;
    final double calendarRadius = 50;
    final double calendarPadding = 8;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    Color calendarBackgroundColor = Colors.grey.withValues(alpha: 0.2);
    Color todayColorHighlight = AppColors.buttonBackgroundDark.withValues(alpha: 0.5);
    Color selectedColorHighlight = AppColors.popUpBGDark;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Column(
          children: [
            SizedBox(height: sizeboxSize),

            Text(
              'Calendar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            Divider(
              color: titleColor,
              thickness: dividerThickness,
              indent: dividerIndent,
              endIndent: dividerIndent,
              radius: BorderRadius.circular(dividerCurve),
            ),

            SizedBox(height: sizeboxSize * 2),

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
                      Container(
                        decoration: BoxDecoration(
                          color: calendarBackgroundColor,
                          borderRadius: BorderRadius.circular(calendarRadius),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: hPadding, vertical: wPadding,),
                        padding: EdgeInsets.only(top: wPadding, bottom: wPadding * 2),
                      
                        child: TableCalendar(
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
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible: false,

                            titleTextStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),

                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: titleColor,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: titleColor,
                            ),
                          ),

                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w600,
                            ),
                            weekendStyle: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w600
                            ),
                          ),

                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: todayColorHighlight,
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: selectedColorHighlight,
                              shape: BoxShape.circle,
                            ),
                            selectedTextStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            defaultTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                            weekendTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                            outsideTextStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            disabledTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: sizeboxSize),

                      Expanded(
                        child: selectedReminders.isEmpty
                          ?  Center(
                            child: Text(
                              _selectedDay == null
                                ? 'Tap a date to view reminders'
                                : 'No reminders for \n${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: calendarFontSize,
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