import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255, // Alpha (不透明)
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
  );
}