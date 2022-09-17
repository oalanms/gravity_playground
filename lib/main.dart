import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent
    with HasGameRef<GravityPlayground> {
  Vector2 speed = Vector2.zero();
  bool isFixed = false;
  double mass = 1.0;
  Color color = Colors.blue;

  List<Vector2> tail = [];

  @override
  void update(double dt) {
    if (isFixed) return;
    var acc = Vector2.zero();
    for (final star in gameRef.children) {
      if (star == this) continue;
      if (star is! StarComponent) continue;

      final dir = star.position - position;
      final normDir = dir.normalized();

      final r = position.distanceTo(star.position);

      if (r < 1) continue;

      final G = star.mass / mass;
      final f = 0.1 * G * (mass * star.mass) / (r * r);

      final attraction = normDir * f;
      acc += attraction;
    }

    speed += acc;

    tail.add(Vector2(position.x, position.y));
    if (tail.length > 120) {
      tail.removeAt(0);
    }
    position += speed * dt;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;

    for (int i = 0; i < tail.length - 1; i++) {
      final p1 = Offset(-position.x, -position.y) + Offset(tail[i].x, tail[i].y);
      final p2 = Offset(-position.x, -position.y) + Offset(tail[i + 1].x, tail[i + 1].y);
      canvas.drawLine(p1, p2, paint);
    }

    canvas.drawOval(
      Rect.fromLTWH(
        -size.x / 2,
        -size.y / 2,
        size.x,
        size.y,
      ),
      paint,
    );
  }
}

class GravityPlayground extends FlameGame with PanDetector {
  StarComponent? _newStar;

  @override
  void onPanDown(DragDownInfo info) {
    _newStar = StarComponent()
      ..position =
          Vector2(info.raw.globalPosition.dx, info.raw.globalPosition.dy)
      ..size = Vector2(25, 25)
      ..color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    super.onPanDown(info);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final clickPosition =
        Vector2(info.raw.globalPosition.dx, info.raw.globalPosition.dy);

    _newStar!.speed = _newStar!.position - clickPosition;
    super.onPanUpdate(info);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    add(_newStar!);
    _newStar = null;
    super.onPanEnd(info);
  }

  @override
  Future<void>? onLoad() {
    add(
      StarComponent()
        ..position = Vector2(0.35 * size.x, 0.65 * size.y)
        ..size = Vector2(80, 80)
        ..isFixed = true
        ..mass = 1000.0
        ..color = Colors.yellow,
    );

    add(
      StarComponent()
        ..position = Vector2(0.65 * size.x, 0.35 * size.y)
        ..size = Vector2(80, 80)
        ..isFixed = true
        ..mass = 1000.0
        ..color = Colors.yellow,
    );

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint();

    // Draw new star
    if (_newStar != null) {
      paint.color = _newStar!.color;
      final p1 = _newStar!.position - _newStar!.speed;
      final p2 = _newStar!.position;
      canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
      canvas.drawOval(
          Rect.fromLTWH(
            _newStar!.position.x - _newStar!.size.x / 2,
            _newStar!.position.y - _newStar!.size.y / 2,
            _newStar!.size.x,
            _newStar!.size.y,
          ),
          paint);
    }
  }
}

void main() {
  final game = GravityPlayground();
  runApp(GameWidget(game: game));
}
