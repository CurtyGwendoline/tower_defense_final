import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tower_defense_final/src/components/enemy.dart';
import 'package:tower_defense_final/src/components/top_toolbar.dart';
import 'package:tower_defense_final/src/config.dart';
import 'src/components/tile.dart';

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

  final ValueNotifier<int> goldNotifier = ValueNotifier<int>(200);

  int get gold => goldNotifier.value;
  set gold(int newValue) => goldNotifier.value = newValue;

  late List<List<Tile>> grid;

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
    playerSprite = await loadSprite('playerBase.png');

    slimeEasySprite = await loadSprite('slimeEasy.png');
    slimeNormalSprite = await loadSprite('slimeNormal.png');
    slimeHardSprite = await loadSprite('slimeHard.png');
    slimeBossSprite = await loadSprite('slimeBoss.png');
    setupGrid();
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
    for (Enemy enemy in enemys) {
      add(enemy);

      await Future.delayed(const Duration(seconds: 3));
    }
  }
}
