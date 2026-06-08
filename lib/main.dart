import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tower_defense_final/src/components/bullet.dart';
import 'package:tower_defense_final/src/components/enemy.dart';
import 'package:tower_defense_final/src/components/tile.dart';
import 'package:tower_defense_final/src/components/top_toolbar.dart';
import 'package:tower_defense_final/src/components/tower.dart';
import 'package:tower_defense_final/src/config.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget<MyGame>(
          game: MyGame(),
          overlayBuilderMap: {
            'TopToolbar': (context, game) => TopToolbar(game: game),
          },
          initialActiveOverlays: const ['TopToolbar'],
        ),
      ),
    ),
  );
}

class MyGame extends FlameGame with HasCollisionDetection {
  late List<List<Tile>> grid;
  final mapBlueprint = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 5, 5, 5, 7, 0, 2, 0, 1, 3],
    [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
    [0, 4, 0, 2, 0, 4, 0, 2, 0, 4, 0],
    [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
    [0, 4, 0, 2, 0, 4, 0, 2, 0, 4, 0],
    [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
    [0, 4, 0, 2, 0, 4, 0, 2, 0, 4, 0],
    [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
    [0, 4, 0, 2, 0, 4, 0, 2, 0, 4, 0],
    [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
    [0, 4, 0, 2, 0, 4, 0, 2, 0, 4, 0],
    [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
    [5, 6, 0, 2, 0, 8, 5, 5, 5, 6, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ];

  List<Vector2> get waypoints => [
    Vector2(0 * tileSize, 14 * tileSize),
    Vector2(1 * tileSize, 14 * tileSize),
    Vector2(1 * tileSize, 2 * tileSize),
    Vector2(5 * tileSize, 2 * tileSize),
    Vector2(5 * tileSize, 14 * tileSize),
    Vector2(9 * tileSize, 14 * tileSize),
    Vector2(9 * tileSize, 2 * tileSize),
    Vector2(10 * tileSize, 2 * tileSize),
  ];

  late Sprite grassSprite;
  late Sprite pathsFull;
  late Sprite pathDownRightTurn;
  late Sprite pathDownLeftTurn;
  late Sprite pathUpAndDown;
  late Sprite pathLeftAndRight;
  late Sprite pathUpLeftTurn;
  late Sprite pathUpRightTurn;

  late Sprite towerUpGrade1;
  late Sprite towerUpGrade2;
  late Sprite towerUpGrade3;
  late Sprite towerUpGrade4;
  late Sprite towerUpGrade5;
  late Sprite towerUpGrade6;
  late Sprite placeForTowerSprite;
  late Sprite playerSprite;

  late Sprite slimeEasySprite;
  late Sprite slimeNormalSprite;
  late Sprite slimeHardSprite;
  late Sprite slimeBossSprite;

  int currentWave = 0;
  final ValueNotifier<bool> isWaveActiveNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int> goldNotifier = ValueNotifier<int>(200);
  final ValueNotifier<int> hpNotifier = ValueNotifier<int>(1000);

  int get playerHp => hpNotifier.value;
  set playerHp(int newValue) => hpNotifier.value = newValue;

  int get gold => goldNotifier.value;
  set gold(int newValue) => goldNotifier.value = newValue;

  @override
  Future<void> onLoad() async {
    grassSprite = await loadSprite('grass.png');
    pathsFull = await loadSprite('pathsFull.png');
    pathDownRightTurn = await loadSprite('pathDownRightTurn.png');
    pathDownLeftTurn = await loadSprite('pathDownLeftTurn.png');
    pathUpAndDown = await loadSprite('pathUpAndDown.png');
    pathLeftAndRight = await loadSprite('pathLeftAndRight.png');
    pathUpLeftTurn = await loadSprite('pathUpLeftTurn.png');
    pathUpRightTurn = await loadSprite('pathUpRightTurn.png');

    towerUpGrade1 = await loadSprite('TowerUpGrade1.png');
    towerUpGrade2 = await loadSprite('TowerUpGrade2.png');
    towerUpGrade3 = await loadSprite('TowerUpGrade3.png');
    towerUpGrade4 = await loadSprite('TowerUpGrade4.png');
    towerUpGrade5 = await loadSprite('TowerUpGrade5.png');
    towerUpGrade6 = await loadSprite('TowerUpGrade6.png');
    placeForTowerSprite = await loadSprite('placeForTower.jpg');
    playerSprite = await loadSprite('playerBase.jpg');

    slimeEasySprite = await loadSprite('slimeEasy.png');
    slimeNormalSprite = await loadSprite('slimeNormal.png');
    slimeHardSprite = await loadSprite('slimeHard.png');
    slimeBossSprite = await loadSprite('slimeBoss.png');
    setupGrid();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isWaveActiveNotifier.value && children.whereType<Enemy>().isEmpty) {
      isWaveActiveNotifier.value = false;
    }
  }

  void damagePlayer(int damage) {
    int newHp = playerHp - damage;

    if (newHp <= 0) {
      playerHp = 0;

      paused = true;

      _showGameOverDialog();
      return;
    }
    playerHp -= damage;
  }

  void _showGameOverDialog() {
    final BuildContext? context = buildContext;
    if (context == null) return;

    showDialog(
      fullscreenDialog: true,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            "GAME OVER",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "What would you like to do ?",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: const Text("Quitter", style: TextStyle(color: Colors.red)),
            ),

            const SizedBox(width: 16),

            TextButton(
              onPressed: () {
                cleanMap();

                hpNotifier.value = 1000;
                goldNotifier.value = 200;
                currentWave = 0;
                isWaveActiveNotifier.value = false;
                paused = false;

                Navigator.pop(dialogContext);
              },
              child: Text("Rejouer", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void cleanMap() {
    final enemies = children.whereType<Enemy>();
    final bullets = children.whereType<Bullet>();
    final towers = children.whereType<Tower>();

    removeAll(enemies);
    removeAll(bullets);
    removeAll(towers);

    for (var row in grid) {
      for (var tile in row) {
        if (tile.tileType == 2 || (mapBlueprint[tile.gridY][tile.gridX] == 2)) {
          tile.sprite = placeForTowerSprite;
          tile.tileType = 2;
        }
        tile.attachedTower = null;
      }
    }
  }

  void setupGrid() {
    grid = List.generate(rows, (y) {
      return List.generate(cols, (x) {
        int tileType = mapBlueprint[y][x];
        final tile = Tile(x, y, tileType);
        add(tile);
        return tile;
      });
    });
  }

  Future<void> wave(List<Enemy> enemys) async {
    isWaveActiveNotifier.value = true;

    for (Enemy enemy in enemys) {
      add(enemy);
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  void startNextWave() {
    currentWave++;

    List<Enemy> enemiesToSpawn = [];

    EnemyType activeType;
    int enemyCount = 5 + currentWave;

    if (currentWave <= 5) {
      activeType = (currentWave % 2 == 0) ? EnemyType.normal : EnemyType.easy;
    } else if (currentWave <= 10) {
      activeType = EnemyType.hard;
    } else {
      activeType = EnemyType.hard;
    }
    for (int i = 0; i < enemyCount; i++) {
      enemiesToSpawn.add(Enemy(activeType, waveNumber: currentWave));
    }
    if (currentWave % 5 == 0) {
      enemiesToSpawn.add(Enemy(EnemyType.boss, waveNumber: currentWave));
    }
    if (currentWave >= 10) {
      enemiesToSpawn.add(Enemy(EnemyType.boss, waveNumber: currentWave));
    }
    wave(enemiesToSpawn);
  }

  bool isWaveActive() {
    return children.whereType<Enemy>().isNotEmpty;
  }
}
