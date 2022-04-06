
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class Cursor extends PositionComponent with Tappable {
  Cursor(//Vector2 position
   );
  final double _cursorSize = 10;

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset.zero, _cursorSize, Paint()..color = Colors.green);
    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(_cursorSize, _cursorSize);
    anchor = Anchor.center;
  }
}
