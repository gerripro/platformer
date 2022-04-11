import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:platformer/utils/configs.dart';
import 'package:tiled/tiled.dart';
import 'package:platformer/units/player.dart';

class Level extends Component {
  final String levelName;

  Level(this.levelName) : super();
  TiledComponent? level;
  ObjectGroup? _spawnPointsLayer;

  @override
  Future<void>? onLoad() async {
    level = await TiledComponent.load(levelName, Vector2.all(96));
    _spawnPointsLayer = level!.tileMap.getObjectGroupFromLayer(Tiles.spawnPoints);
    add(level!);

    return super.onLoad();
  }

  Future<void> loadPlayer(Player player) async {
    var playerOnPoint = _spawnPointsLayer!.objects
        .firstWhere((element) => element.type == Tiles.player);
    player.position=Vector2(playerOnPoint.x,playerOnPoint.y);
    add(player);
  }

  // void loadObjects(TiledComponent level) {
  //   for (final spawnPoint in _spawnPointsLayer.objects) {
  //     if (spawnPoint.type == 'Player') {
  //       Player player = Player()
  //         ..position = Vector2(spawnPoint.x, spawnPoint.y);
  //       add(player);
  //     }
  //   }
  // }
}
