import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Platform extends PositionComponent with HasHitboxes, Collidable {

  @override
  Future<void>? onLoad() {
    collidableType = CollidableType.passive;
    addHitbox(HitboxRectangle());
    return super.onLoad();
  }
}
