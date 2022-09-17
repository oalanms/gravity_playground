import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:gravity_playground/gp/star_component.dart';

class GravityPlaygroundGame extends FlameGame
    with HasCollisionDetection, PanDetector {
  StarComponent? _newStar;
  double attraction = 0.1;
  double playbackSpeed = 1.0;

  @override
  Future<void>? onLoad() {
    // debugMode = true;
    add(
      StarComponent()
        ..position = Vector2(0.35 * size.x, 0.65 * size.y)
        ..size = Vector2(40, 40)
        ..starStatus = StarStatus.fixed
        ..mass = 2000.0
        ..color = Colors.yellow,
    );

    add(
      StarComponent()
        ..position = Vector2(0.65 * size.x, 0.35 * size.y)
        ..size = Vector2(40, 40)
        ..starStatus = StarStatus.fixed
        ..mass = 2000.0
        ..color = Colors.yellow,
    );

    return super.onLoad();
  }

  @override
  void onPanDown(DragDownInfo info) {
    _newStar = StarComponent()
      ..position = Vector2(info.raw.localPosition.dx, info.raw.localPosition.dy)
      ..size = Vector2(25, 25)
      ..color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    super.onPanDown(info);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final clickPosition =
        Vector2(info.raw.localPosition.dx, info.raw.localPosition.dy);

    _newStar!.speed = _newStar!.position - clickPosition;
    super.onPanUpdate(info);
  }

  @override
  void onPanCancel() {
    add(_newStar!);
    _newStar = null;
    super.onPanCancel();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    add(_newStar!);
    _newStar = null;
    super.onPanEnd(info);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint();

    // Draw new star if it's being created
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
