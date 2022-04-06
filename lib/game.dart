
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:platformer/units/enemy.dart';
import 'package:platformer/units/player.dart';

class MyGame extends FlameGame with HasTappables, HasCollidables{
  Player player = Player(radius: 50);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(player..position = size / 2);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    Vector2 tapPosition = info.eventPosition.game;
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
  }
}
