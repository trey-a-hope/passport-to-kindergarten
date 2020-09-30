// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:p/models/BookModel.dart';
// import 'package:p/models/UserModel.dart';

// class ReadingLogAddState extends Equatable {
//   const ReadingLogAddState();
//   @override
//   List<Object> get props => [];
// }

// class LoadingState extends ReadingLogAddState {}

// class LoadedState extends ReadingLogAddState {
//   final bool autoValidate;
//   final GlobalKey<FormState> formKey;
//   final UserModel user;
//   final BookModel book;

//   LoadedState({
//     @required this.user,
//     @required this.autoValidate,
//     @required this.formKey,
//     @required this.book,
//   });

//   @override
//   List<Object> get props => [
//         user,
//         autoValidate,
//         formKey,
//         book,
//       ];
// }

// class ErrorState extends ReadingLogAddState {
//   final dynamic error;

//   ErrorState({
//     @required this.error,
//   });

//   @override
//   List<Object> get props => [
//         error,
//       ];
// }
