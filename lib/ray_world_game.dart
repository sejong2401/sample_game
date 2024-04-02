import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'components/player.dart';
import 'components/world_collidable.dart';
import 'helpers/map_loader.dart';

import 'components/world.dart';
import 'helpers/direction.dart';

class RayWorldGame extends FlameGame with HasCollisionDetection, KeyboardEvents {
  final Player _player = Player();
  final RayWorld _world = RayWorld();

  @override
  Future<void> onLoad() async {
    await world.add(_world);
    await world.add(_player);

    _player.position = _world.size / 2;

    print('#### ${_player.size} / ${_player.position}');

    addWorldCollision();

    camera.follow(_player);
  }

  void onJoypadDirectionChanged(Direction direction) {
    _player.direction = direction;
  }

  void addWorldCollision() async {
    for (var rect in (await MapLoader.readRayWorldCollisionMap())) {
      add(WorldCollidable()
        ..position = Vector2(rect.left, rect.top)
        ..width = rect.width
        ..height = rect.height);
    }
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction? keyDirection;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      keyDirection = Direction.down;
    }

    if (isKeyDown && keyDirection != null) {
      _player.direction = keyDirection;
    } else if (!isKeyDown && _player.direction == keyDirection) {
      _player.direction = Direction.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
