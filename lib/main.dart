import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class Star extends PositionComponent {
  Vector2 speed = Vector2.zero();
  bool isFixed = false;
  double mass = 1.0;
  Color color = Colors.blue;

  List<Vector2> tail = [];
}

class GravityPlayground extends Game with PanDetector {
  Star? _newStar;

  @override
  void onPanDown(DragDownInfo info) {
    _newStar = Star()
      ..position =
          Vector2(info.raw.globalPosition.dx, info.raw.globalPosition.dy)
      ..size = Vector2(40, 40)
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
    _stars.add(_newStar!);
    _newStar = null;
    super.onPanEnd(info);
  }

  final List<Star> _stars = [];

  @override
  Future<void>? onLoad() {
    _stars.add(
      Star()
        ..position = Vector2(100, 100)
        ..size = Vector2(50, 50)
        ..speed = Vector2(25, 0),
    );
    _stars.add(
      Star()
        ..position = Vector2(0.35 * size.x, 0.65 * size.y)
        ..size = Vector2(80, 80)
        ..isFixed = true
        ..mass = 1000.0
        ..color = Colors.yellow,
    );

    _stars.add(
      Star()
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

    for (final star in _stars) {
      paint.color = star.color;

      for(int i = 0; i < star.tail.length-1; i++){
          final p1 = Offset(star.tail[i].x, star.tail[i].y);
          final p2 = Offset(star.tail[i+1].x, star.tail[i+1].y);
          canvas.drawLine(p1, p2, paint);
      }

      canvas.drawOval(
          Rect.fromLTWH(
            star.position.x - star.size.x / 2,
            star.position.y - star.size.y / 2,
            star.size.x,
            star.size.y,
          ),
          paint);
    }
  }

  @override
  void update(double dt) {
    for (final star in _stars) {
      if (star.isFixed) continue;

      var acc = Vector2.zero();
      for (final oStar in _stars) {
        if (oStar == star) continue;

        final dir = oStar.position - star.position;
        final normDir = dir.normalized();

        final r = star.position.distanceTo(oStar.position);

        if (r < 1) continue;

        final G = oStar.mass / star.mass;
        final f = 0.1 * G * (star.mass * oStar.mass) / (r * r);

        final attraction = normDir * f;
        acc += attraction;
      }

      star.speed += acc;
    }

    for (final star in _stars) {
      star.tail.add(Vector2(star.position.x, star.position.y));
      if(star.tail.length > 120){
          star.tail.removeAt(0);
      }
      star.position += star.speed * dt;
    }
  }
}

void main() {
  final game = GravityPlayground();
  runApp(GameWidget(game: game));
}
