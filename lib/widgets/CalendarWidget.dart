import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarController calendarController;
  final Map<DateTime, List<dynamic>> events;
  final Function(DateTime, List<dynamic>) onDaySelected;
  final Function(DateTime, DateTime, CalendarFormat) onVisibleDaysChanged;
  const CalendarWidget(
      {@required this.calendarController,
      @required this.events,
      @required this.onDaySelected,
      @required this.onVisibleDaysChanged});

  @override
  Widget build(BuildContext context) {
    HeaderStyle headerStyle = HeaderStyle(
      formatButtonTextStyle:
          TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
      formatButtonDecoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(16.0),
      ),
    );

    CalendarStyle calendarStyle = CalendarStyle(
      selectedColor: Colors.red[400],
      todayColor: Colors.red[200],
      markersColor: Colors.black,
      outsideDaysVisible: false,
    );

    return TableCalendar(
      calendarController: calendarController,
      events: events,
      // holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: calendarStyle,
      headerStyle: headerStyle,
      onDaySelected: onDaySelected,
      onVisibleDaysChanged: onVisibleDaysChanged,
    );
  }
}
