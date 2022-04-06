import 'dart:async' as Async;
import 'dart:math' as math;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame/geometry.dart';

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:platformer/interfaces/move.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef, Move, HasHitboxes, Collidable {
  final double radius;
  final double speed;

  Player({required this.radius, this.speed = 5});

  int _level = 1;
  double _radius = 50;
  double _speed = 10;
  double _animationSpeed = 0.1;
  late Vector2 _objectSize = Vector2(_radius, _radius);
  String spritePath = 'sprites/moon/spritesheet_moon.png';

  void eat(PositionComponent enemy) {
    if (enemy.size.x <= size.x && enemy.size.y <= size.y) {
      _level += 1;
      _radius = _radius * 1.1;
      _animationSpeed = _animationSpeed * 1.1;
      animate();
      _speed = _speed * 0.9;
      _objectSize = Vector2(_radius, _radius);
      enemy.removeFromParent();
    } else {
      print('you\'ve got eaten');
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    eat(other);
    super.onCollision(intersectionPoints, other);
  }

  @override
  void move(Vector2 targetPos, {PositionComponent? component, double? speed}) {
    component = this;
    speed = _speed;
    super.move(targetPos, component: component, speed: speed);
  }

  @override
  Async.Future<void>? onLoad() async {
    _objectSize = Vector2(_radius, _radius);
    size = _objectSize;
    anchor = Anchor.center;
    await animate();
    addHitbox(HitboxCircle());
    return super.onLoad();
  }

  Async.Future<void> animate() async {
    double spriteSize = 48;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    animation = _spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(movingPos);
    size = _objectSize;
  }
}
