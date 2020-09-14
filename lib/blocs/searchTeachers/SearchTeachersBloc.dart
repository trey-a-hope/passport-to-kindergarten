import 'dart:async';
import 'package:meta/meta.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:bloc/bloc.dart';
import 'package:p/services/AuthService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart' as SEARCH_TEACHERS_BP;

class SearchTeachersBloc extends Bloc<SEARCH_TEACHERS_BP.SearchTeachersEvent,
    SEARCH_TEACHERS_BP.SearchTeachersState> {
  final SEARCH_TEACHERS_BP.SearchTeachersRepository searchTeachersRepository;
  SearchTeachersBloc({@required this.searchTeachersRepository})
      : super(
          SEARCH_TEACHERS_BP.SearchTeachersStateStart(),
        );

  // @override
  // Stream<
  //     Transition<SEARCH_TEACHERS_BP.SearchTeachersEvent,
  //         SEARCH_TEACHERS_BP.SearchTeachersState>> transformEvents(
  //   Stream<SEARCH_TEACHERS_BP.SearchTeachersEvent> events,
  //   Stream<
  //               Transition<SEARCH_TEACHERS_BP.SearchTeachersEvent,
  //                   SEARCH_TEACHERS_BP.SearchTeachersState>>
  //           Function(
  //     SEARCH_TEACHERS_BP.SearchTeachersEvent event,
  //   )
  //       transitionFn,
  // ) {
  //   return events.deb
  //       .debounceTime(const Duration(milliseconds: 300))
  //       .switchMap(transitionFn);
  // }

  @override
  void onTransition(
      Transition<SEARCH_TEACHERS_BP.SearchTeachersEvent,
              SEARCH_TEACHERS_BP.SearchTeachersState>
          transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<SEARCH_TEACHERS_BP.SearchTeachersState> mapEventToState(
    SEARCH_TEACHERS_BP.SearchTeachersEvent event,
  ) async* {
    if (event is SEARCH_TEACHERS_BP.LoadPageEvent) {
      try {
//todo:
      } catch (error) {
        print(error.toString()); //todo: Display error message.
      }
    }

    if (event is SEARCH_TEACHERS_BP.TextChangedEvent) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SEARCH_TEACHERS_BP.SearchTeachersStateStart();
      } else {
        yield SEARCH_TEACHERS_BP.SearchTeachersStateLoading();
        try {
          final List<UserModel> results =
              await searchTeachersRepository.search(term: searchTerm, profileType: PROFILE_TYPE.TEACHER.name);


          if (results.isEmpty) {
            yield SEARCH_TEACHERS_BP.SearchTeachersStateNoResults();
          } else {
            yield SEARCH_TEACHERS_BP.SearchTeachersStateFoundResults(teachers: results);
          }
        } catch (error) {
          yield SEARCH_TEACHERS_BP.SearchTeachersStateError(error: error);
        }
      }
    }
  }
}
