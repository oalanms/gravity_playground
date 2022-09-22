import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gravity_playground/gp/star_component.dart';

class Scenes {
  static Color get randomColor =>
      Colors.primaries[Random().nextInt(Colors.primaries.length)];

  static List<StarComponent> scene1(Vector2 size) => [
        StarComponent()
          ..position = Vector2(0.5 * size.x, 0.5 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,
      ];

  static List<StarComponent> scene2(Vector2 size) => [
        StarComponent()
          ..position = Vector2(0.35 * size.x, 0.5 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.65 * size.x, 0.5 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,
      ];

  static List<StarComponent> scene3(Vector2 size) => [
        StarComponent()
          ..position = Vector2(0.5 * size.x, 0.35 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.35 * size.x, 0.65 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.65 * size.x, 0.65 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,
      ];

  static List<StarComponent> scene4(Vector2 size) => [
        StarComponent()
          ..position = Vector2(0.35 * size.x, 0.35 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.65 * size.x, 0.65 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.65 * size.x, 0.35 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.35 * size.x, 0.65 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,
      ];
  static List<StarComponent> scene5(Vector2 size) => [
        StarComponent()
          ..position = Vector2(0.35 * size.x, 0.35 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.55 * size.x, 0.35 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.75 * size.x, 0.35 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.45 * size.x, 0.55 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.65 * size.x, 0.55 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,
      ];

  static List<StarComponent> scene6(Vector2 size) => [
        StarComponent()
          ..position = Vector2(0.5 * size.x, 0.25 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.5 * size.x, 0.5 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

        StarComponent()
          ..position = Vector2(0.5 * size.x, 0.75 * size.y)
          ..size = Vector2.all(30)
          ..mass = 20000
          ..starStatus = StarStatus.fixed
          ..color = Colors.yellow,

      ];

  static List<List<StarComponent>> allScenes(Vector2 size) => [
        scene1(size),
        scene2(size),
        scene3(size),
        scene4(size),
        scene5(size),
        scene6(size),
      ];
}
