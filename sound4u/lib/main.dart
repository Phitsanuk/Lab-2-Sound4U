import 'package:flutter/material.dart';
import 'splash.dart';

void main() => runApp(Sound4U());

class Sound4U extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Sound4U', home: SplashScrn());
  }
}
