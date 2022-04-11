import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:platformer/scene/platform.dart';
import 'package:platformer/utils/configs.dart';
import 'package:tiled/tiled.dart';
import 'package:platformer/units/player.dart';

class Level extends Component {
  final String levelName;

  Level(this.levelName) : super();
  TiledComponent? level;
  ObjectGroup? _spawnActors;

  @override
  Future<void>? onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(96));
    _spawnActors = level!.tileMap.getObjectGroupFromLayer(Tiles.spawnActors);
    loadObjects(level!);
    add(level!);

    return super.onLoad();
  }

  Future<void> loadPlayer(Player player) async {
    var playerOnPoint = _spawnActors!.objects
        .firstWhere((element) => element.type == Tiles.player);
    player.position = Vector2(playerOnPoint.x, playerOnPoint.y);
    add(player);
  }

  void loadObjects(TiledComponent level) {
    ObjectGroup spawnObjects =
    level.tileMap.getObjectGroupFromLayer(Tiles.spawnObjects);
    for (final spawnObject in spawnObjects.objects) {
      if (spawnObject.type == Tiles.platform) {
        Platform platform = Platform()
        ..position = Vector2(spawnObject.x, spawnObject.y)
        ..size = Vector2(spawnObject.width, spawnObject.height);
        add(platform);
      }
    }
  }
}
