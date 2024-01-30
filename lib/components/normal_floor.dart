import 'dart:math';

import 'package:endless_game/utilities/asset_paths.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../endless_world.dart';

/// The [Obstacle] component can represent three different types of obstacles
/// that the player can run into.
class NormalFloor extends SpriteComponent with HasWorldReference<EndlessWorld> {
  NormalFloor.small({super.position})
      : _srcSize = Vector2.all(16),
        _srcPosition = Vector2.all(32),
        super(
        size: Vector2.all(150),
        anchor: Anchor.bottomLeft,
      );

  NormalFloor.tall({super.position})
      : _srcSize = Vector2(32, 48),
        _srcPosition = Vector2.zero(),
        super(
        size: Vector2(200, 250),
        anchor: Anchor.bottomLeft,
      );

  NormalFloor.wide({super.position})
      : _srcSize = Vector2(32, 16),
        _srcPosition = Vector2(48, 32),
        super(
        size: Vector2(200, 100),
        anchor: Anchor.bottomLeft,
      );

  /// Generates a random obstacle of type [ObstacleType].
  factory NormalFloor.random({
    Vector2? position,
    Random? random,
    bool canSpawnTall = true,
  }) {
    final values = canSpawnTall
        ? const [NormalFloorType.small, NormalFloorType.tall, NormalFloorType.wide]
        : const [NormalFloorType.small, NormalFloorType.wide];
    final type = values.random(random);
    switch (type) {
      case NormalFloorType.small:
        return NormalFloor.small(position: position);
      case NormalFloorType.tall:
        return NormalFloor.tall(position: position);
      case NormalFloorType.wide:
        return NormalFloor.wide(position: position);
    }
  }

  final Vector2 _srcSize;
  final Vector2 _srcPosition;

  @override
  Future<void> onLoad() async {
    // Since all the obstacles reside in the same image, srcSize and srcPosition
    // are used to determine what part of the image that should be used.
    sprite = await Sprite.load(
      AssetPaths.ground_grass,
      srcSize: _srcSize,
      srcPosition: _srcPosition,
    );
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= world.speed * dt;
    if (position.x + size.x < -world.size.x / 2) {
      removeFromParent();
    }
  }
}

enum NormalFloorType {
  small,
  tall,
  wide,
}
