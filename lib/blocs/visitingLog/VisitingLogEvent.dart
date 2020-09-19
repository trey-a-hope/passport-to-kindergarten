import 'package:equatable/equatable.dart';

abstract class VisitingLogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends VisitingLogEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
