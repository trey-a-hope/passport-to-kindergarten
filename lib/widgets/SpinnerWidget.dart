import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:p/constants.dart';

class SpinnerWidget extends StatelessWidget {
  SpinnerWidget({Key key, this.text = 'Loading...'}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GFLoader(
            type: GFLoaderType.circle,
            loaderColorOne: colorOrange,
            loaderColorTwo: colorNavy,
            loaderColorThree: colorYellow,
          ),
          SizedBox(
            height: 20,
          ),
          Text(text),
        ],
      ),
    );
  }
}
