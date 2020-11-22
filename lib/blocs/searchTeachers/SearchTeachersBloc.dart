import 'dart:async';
import 'package:meta/meta.dart';
import 'package:p/constants.dart';
import 'package:p/models/UserModel.dart';
import 'package:bloc/bloc.dart';
import 'Bloc.dart';
import 'package:rxdart/rxdart.dart';

class SearchTeachersBloc
    extends Bloc<SearchTeachersEvent, SearchTeachersState> {
  final SearchTeachersRepository searchTeachersRepository;
  SearchTeachersBloc({@required this.searchTeachersRepository})
      : super(
          SearchTeachersStateStart(),
        );

  @override
  Stream<Transition<SearchTeachersEvent, SearchTeachersState>> transformEvents(
      Stream<SearchTeachersEvent> events,
      TransitionFunction<SearchTeachersEvent, SearchTeachersState>
          transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 300)),
      transitionFn,
    );
  }

  @override
  void onTransition(
      Transition<SearchTeachersEvent, SearchTeachersState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<SearchTeachersState> mapEventToState(
    SearchTeachersEvent event,
  ) async* {
    if (event is LoadPageEvent) {
      try {
        yield SearchTeachersStateStart();
      } catch (error) {
        print(error.toString()); //TODO: Display error message.
      }
    }

    if (event is TextChangedEvent) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchTeachersStateStart();
      } else {
        yield SearchTeachersStateLoading();
        try {
          final List<UserModel> results = await searchTeachersRepository.search(
              term: searchTerm, profileType: PROFILE_TYPE.TEACHER.name);

          if (results.isEmpty) {
            yield SearchTeachersStateNoResults();
          } else {
            yield SearchTeachersStateFoundResults(teachers: results);
          }
        } catch (error) {
          yield SearchTeachersStateError(error: error);
        }
      }
    }
  }
}
