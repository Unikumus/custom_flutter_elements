import 'package:flutter/material.dart';
import 'custom_slider/custom_slider.dart';

void main() {
  runApp(Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Colors.white,
    alignment: Alignment.center,
    child: const SizedBox(
      width: 300,
      height: 70,
      child: CustomSlider(
        sliderColor: Colors.green,
        start: 0,
        end: 100,
        textStyle: TextStyle(color: Colors.red, fontSize: 20),
      ),
    ),
  ));
}


