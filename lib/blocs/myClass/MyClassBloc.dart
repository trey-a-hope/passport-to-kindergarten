import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/ServiceLocator.dart';
import 'package:p/models/UserModel.dart';
import 'package:p/services/AuthService.dart';
import 'package:p/services/BookService.dart';
import 'package:p/services/UserService.dart';
import 'package:p/services/VisitService.dart';
import 'MyClassEvent.dart';
import 'MyClassState.dart';

class MyClassBloc extends Bloc<MyClassEvent, MyClassState> {
  MyClassBloc() : super(null);

  UserModel _currentUser;
  List<UserModel> _students;
  List<String> _visitsIDs;
  List<String> _booksOfTheMonthIDs;

  @override
  Stream<MyClassState> mapEventToState(MyClassEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _visitsIDs = (await locator<VisitService>().retrieveVisits())
            .map((visit) => visit.id)
            .toList();

        _booksOfTheMonthIDs =
            (await locator<BookService>().retrieveBooksOfTheMonth())
                .map((bookOfTheMonth) => bookOfTheMonth.id)
                .toList();

        Stream<QuerySnapshot> studentsStream = await locator<UserService>()
            .streamStudentsForTeacher(teacherUID: _currentUser.uid);

        studentsStream.listen(
          (QuerySnapshot event) {
            List<UserModel> students = event.documents
                .map((doc) => UserModel.fromDocumentSnapshot(ds: doc))
                .toList();

            add(StudentsUpdatedEvent(students: students));
          },
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is StudentsUpdatedEvent) {
      try {
        _students = event.students;

        yield LoadedState(
          user: _currentUser,
          students: _students,
          visitsIDs: _visitsIDs,
          booksOfTheMonthIDs: _booksOfTheMonthIDs,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
