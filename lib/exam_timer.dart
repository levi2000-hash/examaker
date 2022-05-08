import 'package:examaker/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class ExamTimer extends StatelessWidget {
  final int timeInSeconds;
  ExamTimer(this.timeInSeconds);

  onEnd(BuildContext context) {
    print("Exam finished");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * timeInSeconds;
    CountdownTimerController controller = CountdownTimerController(
        endTime: endTime,
        onEnd: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()))
            });
    return CountdownTimer(
      controller: controller,
      endTime: endTime,
      onEnd: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()))
      },
    );
  }
}
