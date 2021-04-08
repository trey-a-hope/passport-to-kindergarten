part of 'super_admin_bloc.dart';

abstract class SuperAdminState extends Equatable {
  const SuperAdminState();

  @override
  List<Object> get props => [];
}

class SuperAdminInitial extends SuperAdminState {}

class LoadingState extends SuperAdminState {
  final String text;

  LoadingState({
    @required this.text,
  });

  @override
  List<Object> get props => [text];
}

class LoadedState extends SuperAdminState {
  final List<BookModel> booksOfTheMonth;
  final Map<UserModel, List<UserModel>> teacherStudentMap;

  LoadedState({
    @required this.booksOfTheMonth,
    @required this.teacherStudentMap,
  });

  @override
  List<Object> get props => [
        booksOfTheMonth,
        teacherStudentMap,
      ];
}

class ErrorState extends SuperAdminState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
