import 'dart:math';
import 'package:flutter/material.dart';

Color hslToColor(double h, double s, double l) {
  double r, g, b;

  h /= 360.0;

  if (s == 0.0) {
    r = g = b = l; // achromatic
  } else {
    double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    double p = 2 * l - q;
    r = hueToRgb(p, q, h + 1.0/3.0);
    g = hueToRgb(p, q, h);
    b = hueToRgb(p, q, h - 1.0/3.0);
  }
  Color rgb = Color.fromRGBO(to255(r), to255(g), to255(b), 1);
  return rgb;
}

int to255(double v) { return min(255,256 * v).round(); }

double hueToRgb(double p, double q, double t) {
  if (t < 0.0)
    t += 1.0;
  if (t > 1.0)
    t -= 1.0;
  if (t < 1.0/6.0)
    return p + (q - p) * 6.0 * t;
  if (t < 1.0/2.0)
    return q;
  if (t < 2.0/3.0)
    return p + (q - p) * (2.0/3.0 - t) * 6.0;
  return p;
}

double colorToHue(Color color) {
  double r = color.red.toDouble();
  double g = color.green.toDouble();
  double b = color.blue.toDouble();

  double max = (r > g && r > b) ? r : (g > b) ? g : b;
  double min = (r < g && r < b) ? r : (g < b) ? g : b;

  double h, s, l;
  l = (max + min) / 2.0;

  if (max == min) {
    h = s = 0.0;
  } else {
    double d = max - min;
    s = (l > 0.5) ? d / (2.0 - max - min) : d / (max + min);

    if (r > g && r > b)
      h = (g - b) / d + (g < b ? 6.0 : 0.0);

    else if (g > b)
      h = (b - r) / d + 2.0;

    else
      h = (r - g) / d + 4.0;

    h /= 6.0;
  }

//  double[] hsl = {h, s, l};
  return h * 360;
}