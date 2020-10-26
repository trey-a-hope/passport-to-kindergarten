import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/ChildLogModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';
import 'Bloc.dart';

abstract class VisitingLogLogsDelegate {
  void showMessage({@required String message});
  void clearForm();
}

class VisitingLogLogsBloc
    extends Bloc<VisitingLogLogsEvent, VisitingLogLogState> {
  VisitingLogLogsBloc({
    @required this.title,
    @required this.initialSelectedDay,
  }) : super(null);

  final String title;

  VisitingLogLogsDelegate _visitingLogLogsDelegate;
  UserModel _currentUser;
  final DateTime initialSelectedDay;
  Map<DateTime, List<ChildLogModel>> _events =
      Map<DateTime, List<ChildLogModel>>();

  void setDelegate({@required VisitingLogLogsDelegate delegate}) {
    this._visitingLogLogsDelegate = delegate;
  }

  @override
  Stream<VisitingLogLogState> mapEventToState(
      VisitingLogLogsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> logsStream =
            await locator<LogService>().streamVisitLogs(
          uid: _currentUser.uid,
          title: title,
        );

        logsStream.listen((QuerySnapshot event) {
          List<ChildLogModel> logs = event.documents
              .map((doc) => ChildLogModel.fromDocumentSnapshot(ds: doc))
              .toList();
          add(LogsUpdatedEvent(logs: logs));
        });

        // yield LoadedState(
        //   user: _currentUser,
        //   dateKey:  dateKey,
        //   autoValidate: false,
        //   formKey: GlobalKey<FormState>(),
        // );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is LogsUpdatedEvent) {
      final List<ChildLogModel> logs = event.logs;

      _events.clear();

      logs.forEach(
        (ChildLogModel log) {
          DateTime dayKey = DateTime(
            log.created.year,
            log.created.month,
            log.created.day,
          );

          if (_events.containsKey(dayKey)) {
            if (!_events[dayKey].contains(log)) {
              _events[dayKey].add(log);
            }
          } else {
            _events[dayKey] = [log];
          }
        },
      );

      final DateTime today = DateTime.now().add(Duration(days: 17));

      yield LoadedState(
        user: _currentUser,
        title: title,
        events: _events,
        dateKey: DateTime(
          today.year,
          today.month,
          today.day,
        ),
        initialSelectedDay: initialSelectedDay,
      );
    }

    if (event is OnDaySelectedEvent) {
      final DateTime selectedDay = event.selectedDay;

      yield LoadedState(
        user: _currentUser,
        title: title,
        events: _events,
        dateKey: DateTime(
          selectedDay.year,
          selectedDay.month,
          selectedDay.day,
        ),
        initialSelectedDay: initialSelectedDay,
      );
    }

    // if (event is SubmitEvent) {
    //   final String description = event.description;
    //   final GlobalKey<FormState> formKey = event.formKey;

    //   if (formKey.currentState.validate()) {
    //     yield LoadingState();

    //     try {
    //       LogModel visitLog = LogModel(
    //           id: null,
    //           description: description,
    //           created: DateTime.now(),
    //           bookTitle: 'Visit Title');

    //       // locator<LogService>().createVisitLog(
    //       //   uid: _currentUser.uid,
    //       //   log: visitLog,
    //       // );

    //       yield LoadedState(
    //         user: _currentUser,
    //         autoValidate: false,
    //         formKey: formKey,
    //       );

    //       _visitingLogLogsDelegate.clearForm();
    //       _visitingLogLogsDelegate.showMessage(message: 'Visit log added.');
    //     } catch (error) {
    //       _visitingLogLogsDelegate.showMessage(message: error.toString());
    //     }
    //   }

    //   //todo: submit visit log.
    // }
  }
}
