import 'package:flutter/material.dart';

class FullWidthButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color buttonColor;
  final Color textColor;

  FullWidthButtonWidget(
      {Key key,
      @required this.onPressed,
      @required this.text,
      @required this.buttonColor,
      @required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontFamily: 'SFUIDisplay',
          fontWeight: FontWeight.bold,
        ),
      ),
      color: buttonColor,
      elevation: 0,
      minWidth: width * 0.85,
      height: 50,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
