import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/constants.dart';
import 'package:p/models/LogModel.dart';
import 'package:p/models/StampModel.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/models/VisitModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/LogService.dart';
import 'package:p/services/UserService.dart';

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

        Stream<QuerySnapshot> visitsStream =
            await locator<LogService>().streamVisitsForUser(
          uid: _currentUser.uid,
        );

        visitsStream.listen(
          (QuerySnapshot event) {
            List<VisitModel> visits = event.documents
                .map(
                  (doc) => VisitModel.fromDocumentSnapshot(ds: doc),
                )
                .toList();
            add(
              VisitsUpdatedEvent(visits: visits),
            );
          },
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is VisitsUpdatedEvent) {
      final List<VisitModel> visits = event.visits;

      _currentUser.visitSortBy = 'recent';

      visits.sort(
        (a, b) => b.modified.compareTo(a.modified),
      );

      for (int visitCount = 0; visitCount < visits.length; visitCount++) {
        final VisitModel visit = visits[visitCount];
        final List<LogModel> logs = await locator<LogService>().getLogs(
            uid: _currentUser.uid, collection: 'visits', documentID: visit.id);

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

        visit.logEvents = logEvents;
      }

      yield LoadedState(
        visits: visits,
        currentUser: _currentUser,
      );
    }

    if (event is CreateVisitLogEvent) {
      final String visitID = event.visitID;
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
          documentID: visitID,
          log: log,
        );

        String assetImagePath;
        switch (name) {
          case 'Dayton Art Institute':
            assetImagePath = ASSET_stamp_dayton_art_institute;
            break;
          case 'Dayton Metro Library':
            assetImagePath = ASSET_dayton_metro_library_logo;
            break;
          case 'Five Rivers Metro Park':
            assetImagePath = ASSET_five_rivers_metroparks_logo;
            break;
          case 'Boonshoft Museum of Discovery':
            assetImagePath = ASSET_boonshoft_logo;
            break;
          default:
            assetImagePath = ASSET_stamp_dayton_art_institute;
            break;
        }

        await locator<UserService>().createStamp(
          uid: _currentUser.uid,
          stamp: StampModel(
            name: name,
            assetImagePath: assetImagePath,
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
