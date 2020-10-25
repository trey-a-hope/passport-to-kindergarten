import 'package:equatable/equatable.dart';

abstract class VisitingLogVisitsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends VisitingLogVisitsEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
