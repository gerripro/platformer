import 'dart:async';
import 'dart:math' as math;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'dart:ui' as ui;

import 'package:platformer/interfaces/move.dart';

class Creature extends SpriteAnimationComponent with HasGameRef, Move {
  @override
  void move(Vector2 targetPos,
      {PositionComponent? component, required double speed}) {
    component = this;
    super.move(targetPos, component: component, speed: speed);
  }

  @override
  void update(double dt) {
    position.add(movingPos);
    super.update(dt);
  }

  @override
  Future<void>? onLoad() async {
    double _objectSize = 200;
    double spriteSize = 48;
    var objectSize = Vector2(_objectSize, _objectSize);
    var spriteSheet =
        await gameRef.images.load('sprites/moon/spritesheet_moon.png');
    SpriteSheet _spriteSheet =
        SpriteSheet(image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    animation = _spriteSheet.createAnimation(row: 0, stepTime: 0.09);
    size = objectSize;
    anchor = Anchor.center;
    return super.onLoad();
  }
}
