import 'package:flutter/material.dart';

final colors = <Color>[Colors.pink, Colors.deepOrangeAccent];
final colors2 = <Color>[
  Colors.white,
  Colors.blueAccent.withAlpha(10),
];

final mainGradient = LinearGradient(colors: colors);

final drawerBodyGradient =
    LinearGradient(colors: colors2);

final scaffoldBodyGradient = LinearGradient(colors: colors);

bool displayMobileLayout(BuildContext context) =>
    MediaQuery.of(context).size.width < 720;
