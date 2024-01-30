import 'dart:math';

import 'package:endless_game/utilities/asset_paths.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../endless_world.dart';

/// The [Obstacle] component can represent three different types of obstacles
/// that the player can run into.
class NailsFloor extends SpriteComponent with HasWorldReference<EndlessWorld> {
  NailsFloor.small({super.position})
      : _srcSize = Vector2.all(16),
        _srcPosition = Vector2.all(32),
        super(
        size: Vector2.all(150),
        anchor: Anchor.bottomLeft,
      );

  NailsFloor.tall({super.position})
      : _srcSize = Vector2(32, 48),
        _srcPosition = Vector2.zero(),
        super(
        size: Vector2(200, 250),
        anchor: Anchor.bottomLeft,
      );

  NailsFloor.wide({super.position})
      : _srcSize = Vector2(32, 16),
        _srcPosition = Vector2(48, 32),
        super(
        size: Vector2(200, 100),
        anchor: Anchor.bottomLeft,
      );

  /// Generates a random obstacle of type [ObstacleType].
  factory NailsFloor.random({
    Vector2? position,
    Random? random,
    bool canSpawnTall = true,
  }) {
    final values = canSpawnTall
        ? const [NailsType.small, NailsType.tall, NailsType.wide]
        : const [NailsType.small, NailsType.wide];
    final obstacleType = values.random(random);
    switch (obstacleType) {
      case NailsType.small:
        return NailsFloor.small(position: position);
      case NailsType.tall:
        return NailsFloor.tall(position: position);
      case NailsType.wide:
        return NailsFloor.wide(position: position);
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

enum NailsType {
  small,
  tall,
  wide,
}
