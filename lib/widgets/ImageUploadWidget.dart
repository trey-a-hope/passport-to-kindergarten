import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p/constants.dart';

class ImageUploadWidget extends StatelessWidget {
  final String imgUrl;
  final Function showSelectImageDialog;

  ImageUploadWidget(
      {Key key, @required this.imgUrl, @required this.showSelectImageDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Stack(children: <Widget>[
        GFAvatar(
          radius: 60,
          backgroundImage: NetworkImage(imgUrl),
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.orange,
          child: Center(
            child: IconButton(
              icon: Icon(
                MdiIcons.camera,
                size: 30,
                color: Colors.white,
              ),
              onPressed: showSelectImageDialog,
            ),
          ),
        ),
      ]),
    );
  }
}
