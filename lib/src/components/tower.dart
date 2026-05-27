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

  @override
  Future<void> onLoad() async {
    size = Vector2.all(tileSize + 5);
    sprite = game.towerUpGrade1;
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

      if (distance > range || currentTarget!.health == 0) {
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
      game.add(Bullet(position: position.clone(), target: currentTarget!));
    }
  }
}
