import 'package:flutter/material.dart';

MaterialColor generateMaterialColor(Color color) {
  var hslColor = HSLColor.fromColor(color);

  return MaterialColor(color.value, {
    for (var i in [50, 100, 200, 300, 400, 500, 600, 700, 800, 900])
      i: hslColor.withLightness(1 - (i.toDouble() / 1000.0)).toColor()
  });
}