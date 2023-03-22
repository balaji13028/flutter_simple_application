import 'package:flutter/material.dart';

class ColorPalette {
  static const Gradient primaryGradient = LinearGradient(colors: [
    Color.fromRGBO(4, 9, 35, 1),
    Color.fromRGBO(39, 105, 170, 1),
  ], begin: FractionalOffset.bottomLeft, end: FractionalOffset.topCenter);

  static const Gradient secondryGradient = LinearGradient(colors: [
    Color.fromRGBO(4, 9, 35, 1),
    Color.fromRGBO(39, 105, 170, 1),
  ], begin: FractionalOffset.center, end: FractionalOffset.center);
}
