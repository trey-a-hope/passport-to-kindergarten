part of 'student_details_bloc.dart';

abstract class StudentDetailsState extends Equatable {
  const StudentDetailsState();

  @override
  List<Object> get props => [];
}

class StudentDetailsInitialState extends StudentDetailsState {}

class StudentDetailsLoadingState extends StudentDetailsState {}

class StudentDetailsLoadedState extends StudentDetailsState {
  final UserModel student;

  StudentDetailsLoadedState({
    @required this.student,
  });

  @override
  List<Object> get props => [
        student,
      ];
}

class StudentDetailsErrorState extends StudentDetailsState {
  final dynamic error;

  StudentDetailsErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
