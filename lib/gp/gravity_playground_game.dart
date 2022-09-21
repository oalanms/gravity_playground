import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:gravity_playground/gp/scenes.dart';
import 'package:gravity_playground/gp/star_component.dart';

class GravityPlaygroundGame extends FlameGame
    with HasCollisionDetection, PanDetector {
  StarComponent? _newStar;
  double attraction = 1.0;
  double playbackSpeed = 1.0;

  List<StarComponent> frees = [];

  int _selectedScene = 1;
  int get selectedScene => _selectedScene;
  set selectedScene(int value) {
    _selectedScene = value % Scenes.allScenes(size).length;
    _loadScene();
  }

  @override
  Future<void>? onLoad() {
    // debugMode = true;
    camera.viewport = FixedResolutionViewport(size);
    _loadScene();
    return super.onLoad();
  }

  void _loadScene() {
    // TODO: better way to remove all children?
    for (var c in children) {
      c.removeFromParent();
    }
    children.removeWhere((_) => true);
    addAll(Scenes.allScenes(size)[_selectedScene]);
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
    frees.add(_newStar!);
    _newStar = null;
    super.onPanCancel();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    add(_newStar!);
    frees.add(_newStar!);
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

    double side = 0.05 * size.x;
    int rows = size.y ~/ side;
    int cols = size.x ~/ side;

    Paint gridPaint = Paint()..color = Colors.white.withOpacity(0.2);
    for (int i = 0; i < rows; i++) {
      canvas.drawLine(Offset(0, i * side), Offset(size.x, i * side), gridPaint);
    }

    for (int i = 0; i < cols; i++) {
      canvas.drawLine(Offset(i * side, 0), Offset(i * side, size.y), gridPaint);
    }
  }
}
