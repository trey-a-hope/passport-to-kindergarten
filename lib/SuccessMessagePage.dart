import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'constants.dart';

class SuccessMessagePage extends StatelessWidget {
  SuccessMessagePage({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConfettiController _confettiController;

  @override
  Widget build(BuildContext context) {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    final List<String> messages = [
      'You did it!',
      'AWEsome reading, 15 books!',
      'Another stamp in your Passport!',
      'AWEsome Kid!',
      'Keep reading! Fill your Passport with stamps!',
      'AWEsome, AWEsome, AWEsome',
    ];

    Random random = Random();
    int randomNumber = random.nextInt(messages.length);

    final String message = messages[randomNumber];

    _confettiController.play();

    return Scaffold(
      key: _scaffoldKey,
      body: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ASSET_success_message_background),
                  fit: BoxFit.none,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: COLOR_NAVY,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    ASSET_p2k20_app_stamp_15_books_read,
                    width: 200,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                    true, // start again as soon as the animation is finished
                colors: [
                  COLOR_ORANGE,
                  COLOR_YELLOW,
                  COLOR_NAVY,
                ], // manually specify the colors to be used
              ),
            ),
          ],
        ),
      ),
    );
  }
}
