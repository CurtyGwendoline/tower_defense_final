import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tower_defense_final/main.dart';
import 'package:tower_defense_final/src/config.dart';

enum EnemyType { easy, normal, hard, boss }

class Enemy extends SpriteComponent with HasGameReference<MyGame> {
  late double health;
  final double baseSpeed = 50;

  int waypointIndex = 0;
  EnemyType enemyType;
  Vector2 moveDirection = Vector2.zero();

  Enemy(this.enemyType);

  @override
  Future<void> onLoad() async {
    _configureEnemy();

    // debugMode = true;

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

  void addGold() {
    switch (enemyType) {
      case EnemyType.easy:
        game.gold = game.gold + 10;
        break;
      case EnemyType.normal:
        game.gold += 50;
        break;
      case EnemyType.hard:
        game.gold += 100;
        break;
      case EnemyType.boss:
        game.gold += 300;
        break;
    }
  }

  void _configureEnemy() {
    switch (enemyType) {
      case EnemyType.easy:
        health = 100;
        size = Vector2.all(tileSize);
        sprite = game.slimeEasySprite;
        break;
      case EnemyType.normal:
        health = 250;
        size = Vector2.all(tileSize + 1);
        sprite = game.slimeNormalSprite;
        break;
      case EnemyType.hard:
        health = 500;
        size = Vector2.all(tileSize + 3);
        sprite = game.slimeHardSprite;
        break;
      case EnemyType.boss:
        health = 800;
        size = Vector2.all(tileSize + 5);
        sprite = game.slimeBossSprite;
        break;
    }
  }
}
