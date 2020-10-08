import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MenuEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends MenuEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class UploadPictureEvent extends MenuEvent {
  final File image;

  UploadPictureEvent({
    @required this.image,
  });

  List<Object> get props => [
        image,
      ];
}
