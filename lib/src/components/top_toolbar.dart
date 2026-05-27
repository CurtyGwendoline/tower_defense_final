import 'package:flutter/material.dart';
import 'package:tower_defense_final/main.dart';
import 'package:tower_defense_final/src/components/enemy.dart';

class TopToolbar extends StatelessWidget {
  final MyGame game;

  const TopToolbar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    List<Enemy> wave1Enemys = [
      Enemy(EnemyType.easy),
      Enemy(EnemyType.easy),
      Enemy(EnemyType.easy),
    ];
    List<Enemy> wave2Enemys = [
      Enemy(EnemyType.normal),
      Enemy(EnemyType.normal),
      Enemy(EnemyType.normal),
    ];
    List<Enemy> wave3Enemys = [
      Enemy(EnemyType.hard),
      Enemy(EnemyType.hard),
      Enemy(EnemyType.hard),
    ];
    List<Enemy> waveBossEnemys = [
      Enemy(EnemyType.hard),
      Enemy(EnemyType.hard),
      Enemy(EnemyType.boss),
    ];
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: SafeArea(
        child: Card(
          color: Colors.black.withValues(alpha: 0.75),
          elevation: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: game.goldNotifier,
                      builder: (context, currentGold, child) {
                        return Text(
                          "Gold : $currentGold",
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => game.wave(wave1Enemys),
                          child: const Text('Wave 1'),
                        ),
                        TextButton(
                          onPressed: () => game.wave(wave2Enemys),
                          child: const Text('Wave 2'),
                        ),
                        TextButton(
                          onPressed: () => game.wave(wave3Enemys),
                          child: const Text('Wave 3'),
                        ),
                        TextButton(
                          onPressed: () => game.wave(waveBossEnemys),
                          child: const Text('Boss'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
