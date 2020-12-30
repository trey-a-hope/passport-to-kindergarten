import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/constants.dart';
import 'package:p/models/BookModel.dart';
import 'package:p/widgets/AppBarWidget.dart';
import 'package:p/widgets/SpinnerWidget.dart';

part 'super_admin_event.dart';
part 'super_admin_state.dart';
part 'super_admin_view.dart';

class SuperAdminBloc extends Bloc<SuperAdminEvent, SuperAdminState> {
  SuperAdminBloc() : super(SuperAdminInitial());

  @override
  Stream<SuperAdminState> mapEventToState(
    SuperAdminEvent event,
  ) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        //fetch books of the month
        //fetch all students and group by teacher, (Map<UserModel, List<UserModel>)

        yield LoadedState(booksOfTheMonth: []);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
