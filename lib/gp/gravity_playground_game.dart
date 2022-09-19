import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:gravity_playground/gp/star_component.dart';

class GravityPlaygroundGame extends FlameGame
    with HasCollisionDetection, PanDetector {
  StarComponent? _newStar;
  double attraction = 1.0;
  double playbackSpeed = 1.0;

  @override
  Future<void>? onLoad() {
    // debugMode = true;
    camera.viewport = FixedResolutionViewport(size);
    add(
      StarComponent()
        ..position = Vector2(0.5 * size.x, 0.5 * size.y)
        ..size = Vector2(35, 35)
        ..starStatus = StarStatus.fixed
        ..mass = 9000.0
        ..color = Colors.yellow,
    );

    // add(
    //   StarComponent()
    //     ..position = Vector2(0.5 * size.x, 0.70 * size.y)
    //     ..size = Vector2(35, 35)
    //     ..starStatus = StarStatus.fixed
    //     ..mass = 300000.0
    //     ..color = Colors.yellow,
    // );

    // add(
    //   StarComponent()
    //     ..position = Vector2(0.25 * size.x, 0.5 * size.y)
    //     ..size = Vector2(35, 35)
    //     ..starStatus = StarStatus.fixed
    //     ..mass = 300000.0
    //     ..color = Colors.yellow,
    // );

    // add(
    //   StarComponent()
    //     ..position = Vector2(0.75 * size.x, 0.5 * size.y)
    //     ..size = Vector2(35, 35)
    //     ..starStatus = StarStatus.fixed
    //     ..mass = 300000.0
    //     ..color = Colors.yellow,
    // );

    // add(
    //   StarComponent()
    //     ..position = Vector2(0.5 * size.x, 0.35 * size.y)
    //     ..size = Vector2(35, 35)
    //     ..starStatus = StarStatus.fixed
    //     ..mass = 300000.0
    //     ..color = Colors.yellow,
    // );

    // add(
    //   StarComponent()
    //     ..position = Vector2(0.5 * size.x, 0.65 * size.y)
    //     ..size = Vector2(35, 35)
    //     ..starStatus = StarStatus.fixed
    //     ..mass = 300000.0
    //     ..color = Colors.yellow,
    // );

    return super.onLoad();
  }

  @override
  void onPanDown(DragDownInfo info) {
    super.onPanDown(info);
    _newStar = StarComponent()
      ..position = info.eventPosition.viewport
      ..size = Vector2(15, 15)
      ..color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    if (_newStar == null) return;
    _newStar!.speed = _newStar!.position - info.eventPosition.viewport;
  }

  // NOT a mistake. If you just tap the screen (and don't drag), it'll add the
  // star with speed = (0, 0);
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
    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
      ),
    );

    textPaint.render(canvas, "${children.length}", Vector2(50, 50));

    // Draw the new star if it's being created
    if (_newStar != null) {
      final paint = Paint()..color = _newStar!.color;
      final p1 = _newStar!.position - _newStar!.speed;
      final p2 = _newStar!.position;
      canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);

      canvas.drawOval(
        Rect.fromLTWH(
          p2.x - _newStar!.size.x / 2,
          p2.y - _newStar!.size.y / 2,
          _newStar!.size.x,
          _newStar!.size.y,
        ),
        paint,
      );
    }
  }
}
