import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/EntryModel.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/UserService.dart';
import 'package:p/services/VisitService.dart';

import 'Bloc.dart';

abstract class VisitingLogDelegate {
  void showMessage({@required String message});
}

class VisitingLogBloc extends Bloc<VisitingLogEvent, VisitingLogState> {
  VisitingLogBloc() : super(null);

  VisitingLogDelegate _visitingLogDelegate;
  UserModel _currentUser;

  void setDelegate({@required VisitingLogDelegate delegate}) {
    this._visitingLogDelegate = delegate;
  }

  @override
  Stream<VisitingLogState> mapEventToState(VisitingLogEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        List<String> visitEntriesIDs = (await locator<LogService>()
                .retrieveEntries(uid: _currentUser.uid, type: 'visits'))
            .map((visitEntry) => visitEntry.entryID)
            .toList();

        //Validate that this student has an entry for every visit currently.
        List<String> visitsIDs =
            (await locator<VisitService>().retrieveVisits())
                .map((visit) => visit.id)
                .toList();

        for (var i = 0; i < visitsIDs.length; i++) {
          if (!visitEntriesIDs.contains(visitsIDs[i])) {
            await locator<LogService>().createEntry(
              uid: _currentUser.uid,
              type: 'visits',
              entry: EntryModel(
                id: null,
                entryID: visitsIDs[i],
                created: DateTime.now(),
                modified: DateTime.now(),
                logCount: 0,
              ),
            );
          }
        }

        Stream<QuerySnapshot> entriesStream = await locator<LogService>()
            .streamEntries(uid: _currentUser.uid, type: 'visits');

        entriesStream.listen(
          (QuerySnapshot event) {
            List<EntryModel> visitEntries = event.documents
                .map(
                  (doc) => EntryModel.fromDocSnapshot(ds: doc),
                )
                .toList();

            add(
              VisitsUpdatedEvent(visitEntries: visitEntries),
            );
          },
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is VisitsUpdatedEvent) {
      final List<EntryModel> visitEntries = event.visitEntries;

      _currentUser.bookSortBy = 'recent';

      visitEntries.sort(
        (a, b) => b.modified.compareTo(a.modified),
      );

      for (int i = 0; i < visitEntries.length; i++) {
        EntryModel visitEntry = visitEntries[i];

        final VisitModel visit = await locator<VisitService>()
            .retrieveVisit(visitID: visitEntry.entryID);

        visitEntry.visit = visit;

        final List<LogModel> logs = await locator<LogService>().retrieveLogs(
          uid: _currentUser.uid,
          type: 'visits',
          idOfEntry: visitEntry.id,
        );

        Map<DateTime, List<LogModel>> logEvents =
            Map<DateTime, List<LogModel>>();

        logs.forEach(
          (LogModel log) {
            DateTime dayKey = DateTime(
              log.created.year,
              log.created.month,
              log.created.day,
            );

            if (logEvents.containsKey(dayKey)) {
              if (!logEvents[dayKey].contains(log)) {
                logEvents[dayKey].add(log);
              }
            } else {
              logEvents[dayKey] = [log];
            }
          },
        );

        visitEntry.logEvents = logEvents;
      }
      yield LoadedState(
        visitEntries: visitEntries,
        currentUser: _currentUser,
      );
    }

    if (event is CreateVisitLogEvent) {
      final String idOfEntry = event.idOfEntry;
      final DateTime date = event.date;
      final String name = event.visitName;

      try {
        final LogModel log = LogModel(
          created: date,
          id: null,
        );

        locator<LogService>().createLog(
          uid: _currentUser.uid,
          collection: 'visits',
          idOfEntry: idOfEntry,
          log: log,
        );

        String imgUrl;
        switch (name) {
          case 'Dayton Art Institute':
            imgUrl = STAMP_DAYTON_ART_INSTITUE;
            break;
          case 'Dayton Metro Library':
            imgUrl = STAMP_DAYTON_METRO_LIBRARY;
            break;
          case 'Five Rivers Metro Park':
            imgUrl = STAMP_FIVE_RIVERS_METROPARKS;
            break;
          case 'Boonshoft Museum of Discovery':
            imgUrl = STAMP_BOONSHOFT;
            break;
          default:
            imgUrl = STAMP_DAYTON_ART_INSTITUE;
            break;
        }

        await locator<UserService>().createStamp(
          uid: _currentUser.uid,
          stamp: StampModel(
            name: name,
            imgUrl: imgUrl,
            created: DateTime.now(),
            id: null,
          ),
        );

        _visitingLogDelegate.showMessage(message: 'Log added!');
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
