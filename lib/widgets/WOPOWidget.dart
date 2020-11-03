// import 'package:flutter/material.dart';

// class WOPOWidget extends StatefulWidget {
//   const WOPOWidget({
//     Key key,
//     @required this.currentUser,
//   }) : super(key: key);

//   final String currentUser;

//   @override
//   State createState() => WOPOWidgetState(
//         currentUser: currentUser,
//       );
// }

// class WOPOWidgetState extends State<WOPOWidget> {
//   WOPOWidgetState({
//     @required this.currentUser,
//   });

//   final String currentUser;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       onExpansionChanged: (bool open) {
//         if (!open) {
//           _myClassBloc.add(
//             SelectDateForBookEvent(
//               selectedDate: null,
//               studentUID: student.uid,
//               bookID: book.id,
//             ),
//           );
//         }
//       },
//       title: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.transparent,
//           child: Text(
//             '${book.logCount}',
//             style: TextStyle(
//               color: COLOR_ORANGE,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: NetworkImage(DUMMY_PROFILE_PHOTO_URL),
//             ),
//             SizedBox(
//               width: 15,
//             ),
//             Text(
//               '${book.title}',
//               style: TextStyle(
//                 color: COLOR_NAVY,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           ],
//         ),
//         onTap: () {},
//       ),
//       children: selectedDateForBookLogs != null
//           ? [
//               TableCalendar(
//                 calendarController: _calendarController,
//                 events: events,
//                 startingDayOfWeek: StartingDayOfWeek.sunday,
//                 initialSelectedDay: selectedDateForBookLogs,
//                 calendarStyle: CalendarStyle(
//                   selectedColor: Colors.deepOrange[400],
//                   todayColor: Colors.deepOrange[200],
//                   markersColor: Colors.black,
//                   outsideDaysVisible: false,
//                 ),
//                 headerStyle: HeaderStyle(
//                   formatButtonTextStyle:
//                       TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
//                   formatButtonDecoration: BoxDecoration(
//                     color: Colors.deepOrange[400],
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 onDaySelected: (DateTime day, List events) {
//                   // _readingLogLogsBloc.add(
//                   //   READING_LOG_LOGS_BP
//                   //       .OnDaySelectedEvent(
//                   //           selectedDay:
//                   //               day),
//                   // );
//                 },
//                 onVisibleDaysChanged:
//                     (DateTime first, DateTime last, CalendarFormat format) {},
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               FullWidthButtonWidget(
//                 buttonColor: COLOR_NAVY,
//                 text:
//                     'Add Log for ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
//                 textColor: Colors.white,
//                 onPressed: () async {
//                   final bool confirm = await locator<ModalService>()
//                       .showConfirmation(
//                           context: context,
//                           title: 'Add Log for ${book.title}',
//                           message: 'Are you sure?');

//                   if (!confirm) return;

//                   _myClassBloc.add(
//                     CreateLogForStudentEvent(
//                       studentUID: student.uid,
//                       bookID: book.id,
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//             ]
//           : [
//               Container(
//                 height: 50,
//                 color: COLOR_YELLOW,
//                 child: Center(
//                   child: Text(
//                     'Wow! You have read this book ${book.logCount} times!',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(
//                                 2020,
//                                 1,
//                               ),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'January',
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(
//                                 2020,
//                                 2,
//                               ),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'February',
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(
//                                 2020,
//                                 3,
//                               ),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'March',
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(
//                                 2020,
//                                 4,
//                               ),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'April',
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(
//                                 2020,
//                                 5,
//                               ),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'May',
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(
//                                 2020,
//                                 6,
//                               ),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'June',
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(
//                                 2020,
//                                 7,
//                               ),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'July',
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(2020, 8),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'August',
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(2020, 9),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'September',
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(2020, 10),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'October',
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(2020, 11),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'November',
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: FullWidthButtonWidget(
//                         textColor: Colors.white,
//                         onPressed: () {
//                           _myClassBloc.add(
//                             SelectDateForBookEvent(
//                               studentUID: student.uid,
//                               bookID: book.id,
//                               selectedDate: DateTime(2020, 12),
//                             ),
//                           );
//                         },
//                         buttonColor: COLOR_NAVY,
//                         text: 'December',
//                       ),
//                     ),
//                   )
//                 ],
//               )
//             ],
//     );
//   }
// }
