import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:platformer/units/enemy.dart';
import 'package:platformer/units/player.dart';
import 'package:platformer/utils/direction.dart';

class MyGame extends FlameGame with HasTappables, HasCollidables {
  Player player = Player();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(player..position = size / 2);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    Vector2 tapPosition = info.eventPosition.game;
    if (tapPosition.x > (player.position.x + 20)) {
      player.movePlayer(direction: Direction.right);
    } else if (tapPosition.x < (player.position.x - 20)) {
      player.movePlayer(direction: Direction.left);
    } else {
      player.movePlayer(direction: Direction.none);
    }
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
  }
}
