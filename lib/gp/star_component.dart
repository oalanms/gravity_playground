import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:gravity_playground/gp/gravity_playground_game.dart';

class TailItem {
  final Vector2 position;
  final double timestamp;

  TailItem(this.position, this.timestamp);
}

enum StarStatus { fixed, free, debris }

class StarComponent extends PositionComponent
    with HasGameRef<GravityPlaygroundGame>, CollisionCallbacks {
  double currentTime = 0.0;

  // Current star speed
  Vector2 speed = Vector2.zero();

  // Star mass
  double mass = 1.0;

  // Star color
  Color color = Colors.blue;

  // Tail of the star
  List<TailItem> tail = [];

  // Star position status
  StarStatus starStatus = StarStatus.free;

  CircleHitbox hitbox = CircleHitbox(radius: 0.0);

  void updateHitBox() {
    hitbox.removeFromParent();
    hitbox = CircleHitbox(
      position: Vector2.zero(),
      radius: size.x / 2,
    );

    add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (starStatus == StarStatus.fixed) return;
    if (other is! StarComponent) return;
    if (other.starStatus == StarStatus.debris) return;
    if (other.parent == null) return;

    if (starStatus == StarStatus.debris) {
      other.mass += mass;
      other.size += size * 0.1;

      other.updateHitBox();
      removeFromParent();
      return;
    }

    if (other.starStatus == StarStatus.fixed ||
        other.starStatus == StarStatus.free) {
      int pieces = 20;

      removeFromParent();
      for (int i = 0; i < pieces; i++) {
        final direction = speed.normalized();
        const diff = 3.14 / 8;
        final rightAngle = 3.14 / 4 + Random().nextDouble() * 2 * diff - diff;
        final leftAngle = -3.14 / 4 + Random().nextDouble() * -2 * diff + diff;

        final angle = Random().nextBool() ? rightAngle : leftAngle;

        final rotatedDirection = direction..rotate(angle);

        final debri = StarComponent()
          ..color = color
          ..position =
              position - direction * size.x / 4 + rotatedDirection * Random().nextDouble() * size.x / 2
          ..speed = (rotatedDirection).normalized() *
              Random().nextDouble() *
              (speed.x.abs() + speed.y.abs())
          ..size = size / (pieces.toDouble() / 6)
          ..starStatus = StarStatus.debris;

        if (debri.distance(other) > debri.size.x / 2 + other.size.x / 2) {
          parent!.add(debri);
        }
      }
    }
  }

  @override
  Future<void>? onLoad() {
    anchor = Anchor.center;

    updateHitBox();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    dt *= gameRef.playbackSpeed;
    currentTime += dt;
    super.update(dt);

    if (starStatus == StarStatus.fixed) return;

    // Calculate gravity attraction from other stars
    for (final star in gameRef.children) {
      if (star is! StarComponent) continue;
      if (star == this) continue;

      final distSquared = position.distanceToSquared(star.position);
      if (distSquared < 1) continue;

      final attractionDirection = (star.position - position).normalized();

      final G = star.mass / mass;
      final attractionForce = G * (mass * star.mass) / (distSquared);

      speed += attractionDirection * attractionForce * dt;
    }

    if (starStatus == StarStatus.free) {
      final tailItem = TailItem(Vector2(position.x, position.y), currentTime);
      tail.add(tailItem);

      // Keep tail to the last 2 seconds
      tail.removeWhere((element) => element.timestamp < currentTime - 2);
    }

    position += speed * dt;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;

    for (int i = 0; i < tail.length - 1; i++) {
      final centerOffset =
          Offset(-position.x + size.x / 2, -position.y + size.y / 2);
      final p1 = Offset(tail[i].position.x, tail[i].position.y) + centerOffset;
      final p2 =
          Offset(tail[i + 1].position.x, tail[i + 1].position.y) + centerOffset;
      canvas.drawLine(p1, p2, paint);
    }

    canvas.drawOval(
      Rect.fromLTWH(
        0.0,
        0.0,
        size.x,
        size.y,
      ),
      paint,
    );
  }
}
