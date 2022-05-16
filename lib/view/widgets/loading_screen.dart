import 'package:flutter/material.dart';

class LoadingScreen {
  static Widget showLoading([String? text]) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            text != null ? Text(text) : const Text("Laden...")
          ],
        ),
      ),
    );
  }
}
