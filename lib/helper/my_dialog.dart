import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyDiaLog{
  static Widget loading() {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.2),
        ),
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.blue,
          size: 50,
        ),
      ),
    );
  }
}