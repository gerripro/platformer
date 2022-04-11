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
import 'package:platformer/utils/configs.dart';
import 'package:platformer/utils/direction.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef, Move, HasHitboxes, Collidable {
  Player();

  final double _radius = 80;
  final double _speed = 200;
  double _animationSpeed = 0.3;
  late Vector2 _objectSize = Vector2(_radius, _radius);
  Vector2 velocity = Vector2.zero();
  int _xAxisInput = 0;
  int _yAxisInput = 0;

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
  }

  void moveRight(double delta) {
    position
        .add(Vector2(delta * _speed, 0)); //todo remove after implementing move
  }

  void movePlayer({JoystickDirection direction = JoystickDirection.idle}) {
    if (direction == JoystickDirection.right) {
      _xAxisInput = 1;
      animateRunRight();
    }
    if (direction == JoystickDirection.left) {
      _xAxisInput = -1;
      animateRunLeft();
    }
    if (direction == JoystickDirection.idle) {
      _xAxisInput = 0;
      animateStay();
    }
    if (direction == JoystickDirection.up) {
      // animateJump(); //todo implement jump
    }
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
    await animateStay();
    addHitbox(HitboxRectangle(relation: Vector2(0.52, 1)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.x = _xAxisInput * _speed;
    position += velocity * dt;
  }

  Async.Future<void> animateStay() async {
    _animationSpeed=0.3;
    double spriteSize = 96;
    String spritePath = Assets.playerStay;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    animation = _spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed);
  }

  Async.Future<void> animateRunRight() async {
    _animationSpeed=0.15;
    double spriteSize = 96;
    String spritePath = Assets.playerMove;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    animation = _spriteSheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 2);
  }

  Async.Future<void> animateRunLeft() async {
    _animationSpeed=0.15;
    double spriteSize = 96;
    String spritePath = Assets.playerMove;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    animation = _spriteSheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 2, to: 4);
  }
}
