import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:platformer/scene/cursor.dart';
import 'package:platformer/scene/level.dart';
import 'package:platformer/units/enemy.dart';
import 'package:platformer/units/player.dart';
import 'package:platformer/utils/configs.dart';
import 'package:platformer/utils/direction.dart';
import 'package:flame/flame.dart';

class MyGame extends FlameGame
    with HasTappables, HasDraggables, HasCollidables {
  Player player = Player();
  Level? currentLevel;

  JoystickComponent joystick = JoystickComponent(
      size: 50,
      position: Vector2(150, 150),
      knob: Cursor()); // todo replace with JoystickComponent

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(Vector2(960, 540));
    await loadLevel(Assets.level1);
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    await super.onLoad();
  }

  Future<void> loadLevel(String levelName) async {
    currentLevel?.removeFromParent();
    currentLevel = Level(levelName);
    await add(currentLevel!);
    currentLevel!.loadPlayer(player);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    Vector2 tapPosition = info.eventPosition.game;
    add(joystick..position = tapPosition);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    remove(joystick);
    super.onTapUp(pointerId, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo details) {
    player.movePlayer(direction: joystick.direction);
    super.onDragUpdate(pointerId, details);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo details) {
    player.movePlayer(direction: JoystickDirection.idle);
    remove(joystick);
    super.onDragEnd(pointerId, details);
  }
}
