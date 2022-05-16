import 'package:flutter/material.dart';

class LoadingScreen {
  static Widget showLoading() {
    return Container(
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
