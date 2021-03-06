import 'package:examaker/view/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class ExamTimer extends StatelessWidget {
  final int timeInSeconds;

  const ExamTimer(this.timeInSeconds, {Key? key}) : super(key: key);

  onEnd(BuildContext context) {
    print("Exam finished");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * timeInSeconds;
    CountdownTimerController controller = CountdownTimerController(
        endTime: endTime,
        onEnd: () => {
              //Stop and save examen
              //TODO: Examen opslaan

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()))
            });
    return CountdownTimer(
      controller: controller,
      endTime: endTime,
      textStyle: const TextStyle(fontSize: 20),
      onEnd: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()))
      },
    );
  }
}
