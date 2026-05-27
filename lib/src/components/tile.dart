import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tower_defense_final/main.dart';
import 'package:tower_defense_final/src/components/tower.dart';
import 'package:tower_defense_final/src/config.dart';

class Tile extends SpriteComponent with TapCallbacks, HasGameReference<MyGame> {
  bool isPathVisual = false;
  final int gridX;
  final int gridY;
  final int tileType;

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
    if (sprite == game.placeForTowerSprite) {
      final tower = Tower();

      tower.position = position.clone();

      sprite = game.grassSprite;

      game.add(tower);
    }
  }
}
