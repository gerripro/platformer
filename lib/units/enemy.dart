import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'dart:async' as Async;

import 'package:platformer/interfaces/move.dart';

class Enemy extends PositionComponent
    with HasGameRef, Move, HasHitboxes, Collidable {
  final double radius;
  final Color color;
  final double speed;

  Enemy({required this.radius, required this.color, this.speed = 10});

  late Async.Timer _timer;

  @override
  void move(Vector2? targetPos, {PositionComponent? component, double? speed}) {
    targetPos = Vector2(Random().nextInt(gameRef.size.x.toInt()).toDouble(),
        Random().nextInt(gameRef.size.y.toInt()).toDouble());
    component = this;
    speed = this.speed;
    super.move(targetPos, component: component, speed: speed);
  }

  @override
  void onRemove() {
    _timer.cancel();
    super.onRemove();
  }

  @override
  Future<void>? onLoad() async {
    addHitbox(HitboxCircle());
    _timer = Async.Timer.periodic(const Duration(milliseconds: 500), (timer) {
      move(null);
    });
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {}

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    var sizeObj = Vector2(radius, radius);
    size = sizeObj * 2;
    canvas.drawCircle(Offset(radius, radius), radius, Paint()..color = color);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(movingPos);
  }
}
