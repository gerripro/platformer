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
import 'package:platformer/utils/direction.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef, Move, HasHitboxes, Collidable {
  Player();

  double _radius = 80;
  double _speed = 10;
  double _animationSpeed = 0.3;
  late Vector2 _objectSize = Vector2(_radius, _radius);

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
  }

  void moveRight(double delta){
    position.add(Vector2(delta * _speed, 0)); //todo remove after implementing move
  }

  void movePlayer({Direction direction = Direction.none}) {
    if (direction == Direction.right){
      animateRunRight();
    }
    if (direction == Direction.left){
      animateRunLeft();
    }
    if (direction == Direction.none){
      animateStay();
    }
    if (direction == Direction.up){
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
    debugMode = true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // moveRight(dt);
  }

  Async.Future<void> animateStay() async {
    double spriteSize = 96;
    String spritePath = 'hero-stay.png';
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    animation = _spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed);
  }

  Async.Future<void> animateRunRight() async {
    double spriteSize = 96;
    String spritePath = 'hero-move.png';
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    animation = _spriteSheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 2);
  }

  Async.Future<void> animateRunLeft() async {
    double spriteSize = 96;
    String spritePath = 'hero-move.png';
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    animation = _spriteSheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 2, to: 4);
  }
}
