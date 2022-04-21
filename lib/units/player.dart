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
import 'package:platformer/main.dart';
import 'package:platformer/scene/platform.dart';
import 'package:platformer/utils/configs.dart';
import 'package:platformer/utils/direction.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef, Move, HasHitboxes, Collidable {
  Player();

  final double _radius = 80;
  final double _speed = 200;
  final double _gravity = 10;
  bool isOnGround = true;
  final Vector2 _up = Vector2(0, -1);
  double _animationSpeed = 0.3;
  late SpriteAnimation currentAnimation;
  late Vector2 _objectSize = Vector2(_radius, _radius);
  Vector2 velocity = Vector2.zero();
  int _xAxisInput = 0;
  int _yAxisInput = 0;

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;
        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 1.9) - collisionNormal.length;
        collisionNormal.normalize();
        if (_up.dot(collisionNormal) > 0.9) {
          isOnGround = true;
        }
        position += collisionNormal.normalized().scaled(separationDistance);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  Async.Future<void> checkAnimation() async {
    if (isOnGround) {
      if (velocity.x > 0) {
        await animateRunRight();
      } else if (velocity.x == 0) {
        await animateStay();
      } else {
        await animateRunLeft();
      }
    } else {

      if (velocity.y < 0) {
        await animateJump();
        if (velocity.y >=-200) {
          await animateHover();
        }
      } else {
        await animateFall();
        if (velocity.y <=50) {
          await animateHover();
        }
      }
    }
  }

  void movePlayer({JoystickDirection direction = JoystickDirection.idle}) {
    if (direction == JoystickDirection.right) {
      _xAxisInput = 1;
    }
    if (direction == JoystickDirection.upRight) {
      _xAxisInput = 1;
      _yAxisInput = 1;
    }
    if (direction == JoystickDirection.left) {
      _xAxisInput = -1;
    }
    if (direction == JoystickDirection.upLeft) {
      _xAxisInput = -1;
      _yAxisInput = 1;
    }
    if (direction == JoystickDirection.idle) {
      _xAxisInput = 0;
      _yAxisInput = 0;
    }
    if (direction == JoystickDirection.up) {
      _yAxisInput = 1;
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
    await checkAnimation();
    animation = currentAnimation;
    addHitbox(HitboxRectangle(relation: Vector2(0.52, 1)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    checkAnimation();
    if (!animation!
        .getSprite()
        .image
        .isCloneOf(currentAnimation.getSprite().image)) {
      animation = currentAnimation;
    }
    velocity.x = _xAxisInput * _speed;
    velocity.y = velocity.y.clamp(-(_speed * 2), 350);
    velocity.y += _gravity;
    if (_yAxisInput == 1) {
      if (isOnGround) {
        velocity.y = -(_speed * 2);
        isOnGround = false;
      }
      _yAxisInput = 0;
    }
    if (velocity.y > 0) {
      isOnGround = false;
    }
    position += velocity * dt;
    boundPosition();
  }

  void boundPosition() {
    position.clamp(
      Vector2(game.levelBounds.topLeft.dx, game.levelBounds.topLeft.dy) +
          size / 2,
      Vector2(game.levelBounds.bottomRight.dx,
              game.levelBounds.bottomRight.dy) -
          size / 2,
    );
  }

  Async.Future<void> animateJump() async {
    _animationSpeed = 0.2;
    double spriteSize = 96;
    String spritePath = Assets.playerJump;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    currentAnimation = _spriteSheet.createAnimation(
        row: 0, from: 1, to: 4, stepTime: _animationSpeed);
  }

  Async.Future<void> animateFall() async {
    _animationSpeed = 0.2;
    double spriteSize = 96;
    String spritePath = Assets.playerFall;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    currentAnimation = _spriteSheet.createAnimation(
        row: 0, from: 5, to: 6, stepTime: _animationSpeed);
  }
  Async.Future<void> animateHover() async {
    _animationSpeed = 0.2;
    double spriteSize = 96;
    String spritePath = Assets.playerHover;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    currentAnimation = _spriteSheet.createAnimation(
        row: 0, from: 4, to: 5, stepTime: _animationSpeed);
  }
  Async.Future<void> animateStay() async {
    _animationSpeed = 0.3;
    double spriteSize = 96;
    String spritePath = Assets.playerStay;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    currentAnimation =
        _spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed);
  }

  Async.Future<void> animateRunRight() async {
    _animationSpeed = 0.3;
    double spriteSize = 96;
    String spritePath = Assets.playerMove;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    currentAnimation = _spriteSheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 0, to: 2);
  }

  Async.Future<void> animateRunLeft() async {
    _animationSpeed = 0.3;
    double spriteSize = 96;
    String spritePath = Assets.playerMove;
    var spriteSheet = await gameRef.images.load(spritePath);
    SpriteSheet _spriteSheet = SpriteSheet(
        image: spriteSheet, srcSize: Vector2(spriteSize, spriteSize));
    currentAnimation = _spriteSheet.createAnimation(
        row: 0, stepTime: _animationSpeed, from: 2, to: 4);
  }
}
