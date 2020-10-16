import 'dart:ui';

import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:flutter/material.dart' hide Image;

import 'balls.dart';
import 'boundaries.dart';
import 'contact_callbacks_sample.dart';

class Platform extends BodyComponent {
  final Vector2 position;

  Platform(Forge2DGame game, this.position) : super(game);

  @override
  Body createBody() {
    FixtureDef fd = FixtureDef();
    PolygonShape sd = PolygonShape();
    sd.setAsBoxXY(14.8, 0.125);
    fd.shape = sd;

    BodyDef bd = BodyDef();
    bd.position = position;
    final body = world.createBody(bd);
    return body..createFixtureFromFixtureDef(fd);
  }
}

class DominoBrick extends BodyComponent {
  final Vector2 position;

  DominoBrick(Forge2DGame game, this.position) : super(game);

  @override
  Body createBody() {
    FixtureDef fd = FixtureDef();
    PolygonShape sd = PolygonShape();
    sd.setAsBoxXY(0.125, 2.0);
    fd.shape = sd;
    fd.density = 25.0;

    BodyDef bd = BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position = position;

    fd.friction = .5;
    return world.createBody(bd)..createFixtureFromFixtureDef(fd);
  }
}

class DominoSample extends Forge2DGame with TapDetector {
  DominoSample(Vector2 viewportSize)
      : super(
          scale: 8.0,
          gravity: Vector2(0, -10.0),
        ) {
    viewport.resize(viewportSize);
    // TODO: Fix bug with sleeping bodies midair
    world.setAllowSleep(false);
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    //add(Floor(this));

    for (int i = 0; i < 8; i++) {
      final position = Vector2(0.0, -30.0 + 5 * i);
      add(Platform(this, position));
    }

    final numberOfRows = 10;
    final numberPerRow = 25;
    for (int i = 0; i < numberOfRows; ++i) {
      for (int j = 0; j < numberPerRow; j++) {
        final position =
            Vector2(-14.75 + j * (29.5 / (numberPerRow - 1)), -27.7 + 5 * i);
        add(DominoBrick(this, position));
      }
    }
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 screenPosition =
        Vector2(details.globalPosition.dx, details.globalPosition.dy);
    add(Ball(screenPosition, this, radius: 1.0));
  }
}