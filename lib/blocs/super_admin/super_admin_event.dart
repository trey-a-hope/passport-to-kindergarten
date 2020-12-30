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
