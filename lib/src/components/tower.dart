import 'package:flame/components.dart';
import 'package:tower_defense_final/main.dart';
import 'package:tower_defense_final/src/components/bullet.dart';
import 'package:tower_defense_final/src/components/enemy.dart';
import 'package:tower_defense_final/src/config.dart';

enum TowerType { upgrade1, upgrade2, upgrade3, upgrade4, upgrade5, upgrade6 }

class Tower extends SpriteComponent with HasGameReference<MyGame> {
  Enemy? currentTarget;
  final double range = 128;
  late Timer shootTimer;

  TowerType towerType = TowerType.upgrade1;

  late int towerUpgradeCost;
  late int towerSellValue;
  late double damage;

  @override
  Future<void> onLoad() async {
    _configureTower();
    size = Vector2(tileSize + 12, tileSize + 24);

    shootTimer = Timer(
      1.5,
      repeat: true,
      onTick: () {
        shoot();
      },
    );
  }

  @override
  void update(double dt) {
    Iterable<Enemy> enemys = game.children.whereType<Enemy>();
    shootTimer.update(dt);

    if (currentTarget != null) {
      double distance = position.distanceTo(currentTarget!.position);

      if (distance > range || currentTarget!.health <= 0) {
        currentTarget = null;
      }
    }

    if (currentTarget == null) {
      for (Enemy enemy in enemys) {
        double distance = position.distanceTo(enemy.position);
        if (distance <= range) {
          currentTarget = enemy;
          break;
        }
      }
    }

    if (currentTarget != null && shootTimer.finished) {
      shootTimer.reset();
    }
  }

  void shoot() {
    if (currentTarget != null && currentTarget!.health > 0) {
      game.add(
        Bullet(
          position: position.clone(),
          target: currentTarget!,
          damage: damage,
        ),
      );
    }
  }

  void upgradeTower() {
    switch (towerType) {
      case TowerType.upgrade1:
        towerType = TowerType.upgrade2;
        break;
      case TowerType.upgrade2:
        towerType = TowerType.upgrade3;

        break;
      case TowerType.upgrade3:
        towerType = TowerType.upgrade4;

        break;
      case TowerType.upgrade4:
        towerType = TowerType.upgrade5;

        break;
      case TowerType.upgrade5:
        towerType = TowerType.upgrade6;

        break;
      case TowerType.upgrade6:
        break;
    }
    _configureTower();
  }

  void _configureTower() {
    switch (towerType) {
      case TowerType.upgrade1:
        towerUpgradeCost = 150;
        towerSellValue = 90;
        sprite = game.towerUpGrade1;
        damage = 100;
        break;
      case TowerType.upgrade2:
        towerUpgradeCost = 250;
        towerSellValue = 200;
        sprite = game.towerUpGrade2;
        damage = 150;
        break;
      case TowerType.upgrade3:
        towerUpgradeCost = 350;
        towerSellValue = 300;
        sprite = game.towerUpGrade3;
        damage = 200;
        break;
      case TowerType.upgrade4:
        towerUpgradeCost = 650;
        towerSellValue = 550;
        sprite = game.towerUpGrade4;
        damage = 250;
        break;
      case TowerType.upgrade5:
        towerUpgradeCost = 1000;
        towerSellValue = 800;
        sprite = game.towerUpGrade5;
        damage = 500;
        break;
      case TowerType.upgrade6:
        towerUpgradeCost = 1500;
        towerSellValue = 1250;
        sprite = game.towerUpGrade6;
        damage = 1000;
        break;
    }
  }
}
