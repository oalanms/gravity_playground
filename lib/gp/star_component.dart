import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:gravity_playground/gp/gravity_playground_game.dart';

int initialId = 1;

class TailItem {
  final Vector2 position;
  final double timestamp;

  TailItem(this.position, this.timestamp);
}

enum StarStatus { fixed, free, debris }

class StarComponent extends PositionComponent
    with HasGameRef<GravityPlaygroundGame>, CollisionCallbacks {
  double currentTime = 0.0;

  final _componentId = initialId++;

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

  CircleHitbox? _hitbox;

  @override
  Future<void>? onLoad() {
    anchor = Anchor.center;
    _addOrUpdateHitbox();
    return super.onLoad();
  }

  void _addOrUpdateHitbox() {
    if (_hitbox != null) {
      _hitbox!.removeFromParent();
    }

    _hitbox = CircleHitbox(
      position: Vector2.zero(),
      radius: size.x / 1.95,
    );

    add(_hitbox!);
  }

  @override
  void onRemove() {
    if (_hitbox != null) {
      _hitbox!.removeFromParent();
    }
    super.onRemove();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (parent == null ||
        starStatus == StarStatus.fixed ||
        other is! StarComponent ||
        other.starStatus == StarStatus.debris ||
        other.parent == null) return;

    // Debris collided with another star
    if (starStatus == StarStatus.debris) {
      other.mass += mass;
      other.size += size * 0.001;

      _hitbox!.removeFromParent();
      other._addOrUpdateHitbox();
      removeFromParent();
      return;
    }

    if (other.starStatus == StarStatus.fixed ||
        other.starStatus == StarStatus.free) {
      int pieces = 20;

      removeFromParent();
      for (int i = 0; i < pieces; i++) {
        final direction = speed.normalized();

        // Angle gap to be used in random
        const diff = 3.14 / 8;

        // We rotate 90 degrees (pi / 4) and -90 degrees (-pi / 4)
        // This is the direction that the debris will move
        // To make it look better, we add a random variation to this angle. This is `diff`.
        final rightAngle = 3.14 / 4 + Random().nextDouble() * 2 * diff - diff;
        final leftAngle = -3.14 / 4 + Random().nextDouble() * -2 * diff + diff;

        // Choose one of the two angles randomly
        final angle = Random().nextBool() ? rightAngle : leftAngle;

        // Rotates the direction of the star by the chosen angle
        final rotatedDirection = direction..rotate(angle);

        final debriPosition = position -
            speed.normalized() * size.y -
            direction * size.x / 2 +
            rotatedDirection *
                ((Random().nextDouble() * size.x / 2) + size.x / 2);

        final debriSpeed = (rotatedDirection).normalized() *
            ((speed.x.abs() + speed.y.abs()) / 1.50);

        // Create the debris element
        final debri = StarComponent()
          ..color = color
          ..position = debriPosition
          ..speed = debriSpeed
          ..size = size / 2
          ..starStatus = StarStatus.debris;

        // Only add the debri if it's not colliding with the planet
        if (debri.distance(other) > debri.size.x / 2 + other.size.x / 2) {
          parent!.add(debri);
        }
      }
    }
  }

  // Will call _update with smaller steps of `dt`.
  // This will help to keep consistency with different playback speeds.
  @override
  void update(double dt) {
    double t = dt;
    const step = 0.005;
    while (t > 0) {
      t -= step;
      _update(step);
    }

    super.update(dt);
  }

  void _update(double dt) {
    // TODO: Check distance to the center instead of to (0,0)
    if (position.distanceTo(Vector2.zero()) >
        2 * (gameRef.size.x + gameRef.size.y)) {
      removeFromParent();
      return;
    }

    dt *= gameRef.playbackSpeed;
    currentTime += dt;

    if (starStatus == StarStatus.fixed) return;

    // Calculate gravity attraction from other stars
    for (final star in gameRef.children) {
      if (star is! StarComponent || star == this) continue;

      final distSquared = position.distanceToSquared(star.position);
      if (distSquared <= 1) continue;

      final attractionDirection = (star.position - position).normalized();

      final G = 512;
      double attractionForce =
          gameRef.attraction * G * (mass * star.mass) / (distSquared);

      // attractionForce = max(0.0000001, min(attractionForce, 10000 * gameRef.size.y + gameRef.size.x));

      speed += attractionDirection * attractionForce * dt;
    }

    // Only free-roaming stars have a tail
    if (starStatus == StarStatus.free) {
      final tailItem = TailItem(Vector2(position.x, position.y), currentTime);
      tail.add(tailItem);

      // Keep tail to the last 2 seconds
      while (tail.isNotEmpty && tail.first.timestamp < currentTime - 2) {
        tail.removeAt(0);
      }
    }

    // Apply speed
    position += speed * dt;
  }

  @override
  void render(Canvas canvas) {
    // For debug purposes
    // TextPaint textPaint = TextPaint(
    //   style: const TextStyle(
    //     color: Colors.white,
    //   ),
    // );

    // textPaint.render(canvas, "$mid", Vector2(30, 30));

    final paint = Paint()..color = color;

    for (int i = 0; i < tail.length - 1; i++) {
      paint.strokeWidth = i.isEven ? size.x / 4 : size.x / 8;
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

  @override
  void removeFromParent() {
    if (_hitbox != null) {
      _hitbox!.removeFromParent();
    }
    super.removeFromParent();
  }
}
