import 'package:flutter/material.dart';
import 'package:tower_defense_final/main.dart';

class TopToolbar extends StatelessWidget {
  final MyGame game;

  const TopToolbar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: SafeArea(
        child: Card(
          color: Colors.black.withValues(alpha: 0.75),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: Column(
              children: [
                Row(
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

                    ValueListenableBuilder<int>(
                      valueListenable: game.hpNotifier,
                      builder: (context, currentHp, child) {
                        final double hpPercent = (currentHp / 1000).clamp(
                          0.0,
                          1.0,
                        );

                        Color barColor = Colors.green;
                        if (hpPercent < 0.25) {
                          barColor = Colors.red;
                        } else if (hpPercent < 0.6) {
                          barColor = Colors.orange;
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "HP : $currentHp / 1000",
                              style: TextStyle(
                                color: barColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 120,
                              height: 8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: hpPercent,
                                  backgroundColor: Colors.grey[800],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    barColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    ValueListenableBuilder<bool>(
                      valueListenable: game.isWaveActiveNotifier,
                      builder: (context, isWaveActive, child) {
                        return Row(
                          children: [
                            Text(
                              "Vague : ${game.currentWave}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton(
                              onPressed: isWaveActive
                                  ? null
                                  : () {
                                      game.startNextWave();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isWaveActive
                                    ? Colors.grey
                                    : Colors.green,
                              ),
                              child: Text(
                                isWaveActive
                                    ? 'Combat en cours...'
                                    : 'Lancer Vague ${game.currentWave + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
