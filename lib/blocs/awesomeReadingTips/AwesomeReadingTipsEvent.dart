import 'package:equatable/equatable.dart';

abstract class AwesomeReadingTipsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends AwesomeReadingTipsEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
