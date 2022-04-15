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
  late Rect levelBounds;

  JoystickComponent joystick = JoystickComponent(
      size: 50,
      position: Vector2(150, 150),
      knob: Cursor()); // todo replace with JoystickComponent

  @override
  Future<void> onLoad() async {
    debugMode = true;
    camera.viewport = FixedResolutionViewport(
        Vector2(960, 540)); //(1980,1024));//(960, 540));
    await loadLevel(Assets.level1);
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    camera.followComponent(player, worldBounds: levelBounds);
    await super.onLoad();
  }

  Future<void> loadLevel(String levelName) async {
    currentLevel?.removeFromParent();
    currentLevel = Level(levelName);
    await add(currentLevel!);
    var map2 = currentLevel!.level!.tileMap.map;
    levelBounds = Rect.fromLTWH(
      0,
      0,
      (map2.width * map2.tileWidth).toDouble(),
      (map2.height * map2.tileHeight).toDouble(),
    );
    currentLevel!.loadPlayer(player);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    Vector2 tapPosition = info.eventPosition.viewport;
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
