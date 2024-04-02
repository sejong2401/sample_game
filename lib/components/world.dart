import 'package:flame/components.dart';

class RayWorld extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('rayworld_background.png');
    size = sprite!.originalSize;
  }
}
