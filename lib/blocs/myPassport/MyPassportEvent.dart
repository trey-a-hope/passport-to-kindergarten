import 'package:equatable/equatable.dart';

abstract class MyPassportEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends MyPassportEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

