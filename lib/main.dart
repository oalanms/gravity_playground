import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Star extends PositionComponent {
  Vector2 speed = Vector2.zero();
}

class GravityPlayground extends Game {
  final List<Star> _stars = [];

  GravityPlayground() {
    _stars.add(
      Star()
        ..position = Vector2(100, 100)
        ..size = Vector2(50, 50)
        ..speed = Vector2(10, 10),
    );
    _stars.add(
      Star()
        ..position = Vector2(250, 250)
        ..size = Vector2(50, 80),
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.blue;
    for (final star in _stars) {
      canvas.drawOval(
          Rect.fromLTWH(
            star.position.x,
            star.position.y,
            star.size.x,
            star.size.y,
          ),
          paint);
    }
  }

  @override
  void update(double dt) {
    for (final star in _stars) {
      star.position += star.speed * dt;
    }
  }
}

void main() {
  final game = GravityPlayground();
  runApp(GameWidget(game: game));
}
