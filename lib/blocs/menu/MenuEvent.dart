import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends MenuEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
