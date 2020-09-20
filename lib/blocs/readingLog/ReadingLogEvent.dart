import 'package:equatable/equatable.dart';

abstract class ReadingLogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ReadingLogEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
