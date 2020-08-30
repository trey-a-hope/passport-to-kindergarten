import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class SpinnerWidget extends StatelessWidget {
  SpinnerWidget({Key key, this.text}) : super(key: key);

  final String text; //Text that's displayed under spinner.

  @override
  Widget build(BuildContext context) {
    return GFLoader(type: GFLoaderType.circle);
  }
}
