import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tower_defense_final/main.dart';
import 'package:tower_defense_final/src/components/enemy.dart';

class Bullet extends CircleComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  late Vector2 travelDirection;

  final double speed = 250;
  final double damage = 25;

  Enemy target;

  Bullet({required Vector2 position, required this.target})
    : super(position: position);

  @override
  FutureOr<void> onLoad() {
    double distance = position.distanceTo(target.position);
    double timeToTarget = distance / speed;

    Vector2 enemyVelocity = target.moveDirection;

    Vector2 predictedPosition =
        target.position + (enemyVelocity * timeToTarget);

    travelDirection = (predictedPosition - position).normalized() * speed;

    radius = 4;
    paint = Paint()..color = Colors.white;
    anchor = Anchor.center;

    add(CircleHitbox());
  }

  @override
  @override
  void update(double dt) {
    position += travelDirection * dt;

    if (position.x < 0 ||
        position.x > game.size.x ||
        position.y < 0 ||
        position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other == target) {
      target.health -= damage;
      removeFromParent();
    }
  }
}
