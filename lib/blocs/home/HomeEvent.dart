import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends HomeEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
