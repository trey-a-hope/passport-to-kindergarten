part of 'super_admin_bloc.dart';

abstract class SuperAdminState extends Equatable {
  const SuperAdminState();

  @override
  List<Object> get props => [];
}

class SuperAdminInitial extends SuperAdminState {}

class LoadingState extends SuperAdminState {}

class LoadedState extends SuperAdminState {
  final List<BookModel> booksOfTheMonth;

  LoadedState({
    @required this.booksOfTheMonth,
  });

  @override
  List<Object> get props => [
        booksOfTheMonth,
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
