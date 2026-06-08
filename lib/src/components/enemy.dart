import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tower_defense_final/main.dart';
import 'package:tower_defense_final/src/config.dart';

enum EnemyType { easy, normal, hard, boss }

class Enemy extends SpriteComponent with HasGameReference<MyGame> {
  late double health;
  late double maxHealth;
  final double baseSpeed = 50;
  final int waveNumber;
  late int damage;

  int waypointIndex = 0;
  EnemyType enemyType;
  Vector2 moveDirection = Vector2.zero();

  Enemy(this.enemyType, {required this.waveNumber});

  @override
  Future<void> onLoad() async {
    _configureEnemy();

    add(RectangleHitbox());

    if (game.waypoints.isNotEmpty) {
      position = game.waypoints[0].clone();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (health <= 0) {
      removeFromParent();
      addGold();
      return;
    }

    if (waypointIndex >= game.waypoints.length) {
      game.damagePlayer(damage);
      removeFromParent();
      return;
    }

    Vector2 targetWaypoint = game.waypoints[waypointIndex];

    Vector2 direction = targetWaypoint - position;
    double distanceToTarget = direction.length;

    moveDirection = direction.normalized() * baseSpeed;

    if (distanceToTarget > 0) {
      position += direction.normalized() * baseSpeed * dt;
    }

    if (position.distanceTo(targetWaypoint) < 2) {
      position = targetWaypoint.clone();
      waypointIndex++;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (health < maxHealth && health > 0) {
      final barWidth = size.x;
      final barHeight = 6.0;
      final yOffset = -12.0;

      double healthPercentage = health / maxHealth;
      healthPercentage = healthPercentage.clamp(0.0, 1.0);

      final bgPaint = Paint()..color = const Color(0xFFFF3333);
      final bgRect = Rect.fromLTWH(0, yOffset, barWidth, barHeight);
      canvas.drawRect(bgRect, bgPaint);

      final fgPaint = Paint()..color = const Color(0xFF33FF33);
      final fgRect = Rect.fromLTWH(
        0,
        yOffset,
        barWidth * healthPercentage,
        barHeight,
      );
      canvas.drawRect(fgRect, fgPaint);
    }
  }

  void addGold() {
    switch (enemyType) {
      case EnemyType.easy:
        game.gold = game.gold + 50;
        break;
      case EnemyType.normal:
        game.gold += 100;
        break;
      case EnemyType.hard:
        game.gold += 250;
        break;
      case EnemyType.boss:
        game.gold += 600;
        break;
    }
  }

  void _configureEnemy() {
    switch (enemyType) {
      case EnemyType.easy:
        health = 300;
        maxHealth = 300;
        damage = 50;
        size = Vector2.all(tileSize);
        sprite = game.slimeEasySprite;
        break;
      case EnemyType.normal:
        health = 700;
        maxHealth = 700;
        damage = 150;
        size = Vector2.all(tileSize + 1);
        sprite = game.slimeNormalSprite;
        break;
      case EnemyType.hard:
        health = 1400;
        maxHealth = 1400;
        damage = 250;
        size = Vector2.all(tileSize + 3);
        sprite = game.slimeHardSprite;
        break;
      case EnemyType.boss:
        health = 3600;
        maxHealth = 3600;
        damage = 500;
        size = Vector2.all(tileSize + 5);
        sprite = game.slimeBossSprite;
        break;
    }
    double boostFactor = 1.0 + (waveNumber * 0.15);
    health = health * boostFactor;
    maxHealth = health;
  }
}
