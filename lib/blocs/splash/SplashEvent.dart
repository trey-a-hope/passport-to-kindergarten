import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends SplashEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}
