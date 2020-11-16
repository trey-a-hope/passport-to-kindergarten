import 'package:flutter/material.dart';
import 'package:p/constants.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final int _titleCharLimit = 20;

  AppBarWidget({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          ASSET_p2k20_app_header_bar,
          width: screenWidth,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title.length > _titleCharLimit
                  ? '${title.substring(0, _titleCharLimit)}...'
                  : title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
