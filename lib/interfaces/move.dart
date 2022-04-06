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
import 'dart:ui' as ui;

abstract class Move {
  Vector2 movingPos = Vector2(0, 0);
  Async.Timer? _timer;

  void move(Vector2 targetPos,
      {required PositionComponent component, required double speed}) {
    _timer?.cancel();
    _timer = Async.Timer.periodic(const Duration(milliseconds: 10), (timer) {
      var deltaX = targetPos.x - component.position.x;
      var deltaY = targetPos.y - component.position.y;
      var xMovement = speed;
      var yMovement = speed;
      Vector2 delta = (targetPos - component.position).normalized();
      if ((deltaX < -xMovement || deltaX > xMovement) ||
          (deltaY < -yMovement || deltaY > yMovement)) {
        movingPos = delta * speed;
      } else {
        movingPos = Vector2(0, 0);
        timer.cancel();
        return;
      }
    });
  }
}
