import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends AdminEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
