part of 'super_admin_bloc.dart';

abstract class SuperAdminEvent extends Equatable {
  const SuperAdminEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends SuperAdminEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class UpdateBookGivenEvent extends SuperAdminEvent {
  final String bookID;
  final bool given;

  UpdateBookGivenEvent({
    @required this.bookID,
    @required this.given,
  });

  @override
  List<Object> get props => [
        bookID,
        given,
      ];
}
