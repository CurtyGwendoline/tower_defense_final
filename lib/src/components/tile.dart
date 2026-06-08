import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tower_defense_final/main.dart';
import 'package:tower_defense_final/src/components/tower.dart';
import 'package:tower_defense_final/src/config.dart';

class Tile extends SpriteComponent with TapCallbacks, HasGameReference<MyGame> {
  final int gridX;
  final int gridY;
  int tileType;

  Tower? attachedTower;

  Tile(this.gridX, this.gridY, this.tileType);

  @override
  Future<void> onLoad() async {
    position = Vector2(gridX * tileSize, gridY * tileSize);
    size = Vector2.all(tileSize);
    updateSprite();
  }

  void updateSprite() {
    switch (tileType) {
      case 0:
        sprite = game.grassSprite;
        break;
      case 1:
        sprite = game.pathUpLeftTurn;
        break;
      case 2:
        sprite = game.placeForTowerSprite;
        break;
      case 3:
        sprite = game.playerSprite;
        break;
      case 4:
        sprite = game.pathLeftAndRight;
        break;
      case 5:
        sprite = game.pathUpAndDown;
      case 6:
        sprite = game.pathDownRightTurn;
      case 7:
        sprite = game.pathUpRightTurn;
      case 8:
        sprite = game.pathDownLeftTurn;
        break;
      default:
        sprite = game.grassSprite;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    final BuildContext? context = game.buildContext;
    if (context == null) return;

    if (tileType == 2 && attachedTower == null) {
      if (game.isWaveActive()) return;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              "Tower Construction",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Would you like to build a basic defensive tower here?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (game.gold >= tower1BuyCost) {
                    game.gold -= tower1BuyCost;

                    final newTower = Tower();
                    newTower.position = position.clone();
                    sprite = game.grassSprite;

                    attachedTower = newTower;

                    game.add(newTower);
                  }

                  Navigator.pop(dialogContext);
                },
                child: Text(
                  "Build ($tower1BuyCost Gold)",
                  style: TextStyle(
                    color: game.gold >= tower1BuyCost
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    if (attachedTower != null) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              "Tower Management",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Would you like to upgrade or sell your tower?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (game.gold >= attachedTower!.towerUpgradeCost) {
                    game.gold -= attachedTower!.towerUpgradeCost;

                    attachedTower!.upgradeTower();
                  }
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  "upgrade ${attachedTower!.towerType != TowerType.upgrade6 ? attachedTower!.towerUpgradeCost : "Maxed"}",
                  style: TextStyle(
                    color: game.gold >= attachedTower!.towerUpgradeCost
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  game.gold += attachedTower!.towerSellValue;
                  game.remove(attachedTower!);
                  attachedTower = null;
                  sprite = game.placeForTowerSprite;
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  "Sell (${attachedTower!.towerSellValue} Gold)",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 223, 211, 52),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
