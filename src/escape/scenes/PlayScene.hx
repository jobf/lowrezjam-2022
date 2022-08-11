package escape.scenes;

import escape.ShipTrackingBackground;
import core.Emitter;
import escape.Weapon.ProjectileType;
import escape.scenes.BaseScene.TitleScene;
import escape.scenes.BaseScene.MovieScene;
import escape.Configuration;
import escape.scenes.CutScene;
import tyke.App;
import core.Actor;
import echo.Echo;
import echo.Body;
import core.Controller;
import tyke.Loop;
import Main;
import tyke.Graphics;
import tyke.Glyph;
import peote.view.Color;

class PlayScene extends FullScene {
	var background:ShipTrackingBackground;
	var level:Level;
	var ship:Ship;
	var controller:Controller;
	var hudTiles:SpriteRenderer;
	var levelConfig:LevelConfig;
	var shipActorSystem:ActorSystem;
	var sun:Sun;
	var levelIndex:Int;

	public function new(app:App, nextLevelIndex:Int) {
		levelIndex = nextLevelIndex;
		this.levelConfig = Configuration.levels[nextLevelIndex];
		level = new Level(levelConfig.ldtk_level_id);

		if (level.levelStyle == Neutralize) {
			backgroundColor = 0xf79617ff;
		}

		if (level.levelStyle == Escape) {
			backgroundColor = 0x00000000;
		}

		super(app, backgroundColor, 0, 0);
		trace('start of level ${level.levelStyle}');
	}

	override function create() {
		super.create();
		// @:privateAccess
		// stage.globalFrameBuffer.display.xOffset -= 64;
		// emitterTiles = stage.createSpriteRendererFor("assets/sprites/64x4-tiles.png", 8, 8, true, 640, 640); // tiles14px; //
		emitterTiles = spaceLevelTilesNear;
		hudTiles = stage.createSpriteRendererFor("assets/sprites/64x8-tiles.png", 64, 8, true, 640, 640); // tiles14px; //
		// hudTiles = stage.createSpriteRendererFor("assets/sprites/64x14-tiles.png", 64, 14, true, 640, 640); // tiles14px; //
		// var f = hudFrame.makeSprite(64 + 32, 32, 64, 0);
		// world.width = 256;
		// world.height = 256;
		world.dispose();
		world = Echo.start({
			width: 1024,
			height: 1024,
			gravity_y: 100,
			iterations: 2
		});

		level.initLevel(debugShapes, spaceLevelTiles, world, app.core.peoteView, [spaceLevelTilesFar, spaceLevelTiles, spaceLevelTilesNear]);

		var shipOptions:ActorOptions = {
			spriteTileSize: 14,
			spriteTileIdStart: 16,
			shape: RECT,
			makeCore: actorFactory,
			debugColor: 0xff202080,
			collisionType: VEHICLE,
			bodyOptions: {
				shape: {
					solid: false,
					// radius: radius,
					width: 8,
					height: 4,
				},
				mass: 1,
				x: 16,
				y: 32,
				kinematic: true
			}
		};

		shipActorSystem = {
			world: world,
			tiles: tiles14px,
			shapes: debugShapes,
			peoteView: app.core.peoteView
		};

		var shipSpeed = 2.0;
		var maxTravelDistance = 40;
		var projectileType = level.levelStyle == Neutralize ? BOMB : STANDARD;
		var projectileConfig = Configuration.projectiles[projectileType];

		if (level.levelStyle == Neutralize) {
			projectileConfig.totalShots = level.countSolarTargets();
		}
		ship = new Ship(shipOptions, shipActorSystem, shipSpeed, maxTravelDistance, hudTiles, projectileConfig, projectileSprites);

		if (level.levelStyle != Neutralize) {
			background = new StarField(ship, 256, 128, starSpriteRenderer);
		} else {
			background = new SunSurface(ship, Std.int(level.finishLine.core.body.x * 3.0), 128, tiles640px);
		}

		if (level.levelStyle == Escape) {
			var sunActorSystem:ActorSystem = {
				world: world,
				tiles: tiles14px,
				shapes: debugShapes,
				peoteView: app.core.peoteView
			};

			sun = new Sun(sunActorSystem);

			// register ship and sun collisions
			world.listen(ship.core.body, sun.core.body, {
				enter: (shipBody, sunBody, collisionData) -> {
					sunBody.collider.collideWith(shipBody, emitter);
					shipBody.collider.collideWith(sunBody, emitter);
				},
			});

			audio.playMusic('assets/audio/bg-a-147bpm.ogg');
		} else {
			var bg = level.levelStyle == Neutralize ? "f" : "b";
			audio.playMusic('assets/audio/bg-$bg.ogg');
		}

		controller = new Controller(app.window, {
			onControlUp: isDown -> ship.moveUp(isDown),
			onControlRight: isDown -> ship.moveRight(isDown),
			onControlLeft: isDown -> ship.moveLeft(isDown),
			onControlDown: isDown -> ship.moveDown(isDown),
			onControlAction: isDown -> ship.action(isDown)
		});
		controller.enable();

		emitter = new Emitter(emitterTiles);
		// register ship and obstacle collisions
		world.listen(ship.core.body, level.obstacles, {
			enter: (shipBody, obstacleBody, collisionData) -> {
				if (obstacleBody.obstacleConfiguration != null) {
					ship.core.sprite.shake(app.core.peoteView.time);
				}
				obstacleBody.collider.collideWith(shipBody, emitter);
				shipBody.collider.collideWith(obstacleBody, emitter);
			},
		});

		// register projectile and obstacle collisions
		world.listen(ship.weapon.projectiles, level.obstacles, {
			enter: (projectileBody, obstacleBody, collisionData) -> {
				obstacleBody.collider.collideWith(projectileBody, emitter);
				projectileBody.collider.collideWith(obstacleBody, emitter);
			},
		});

		// register ship and finish line collisions
		world.listen(ship.core.body, level.finishLine.core.body, {
			enter: (shipBody, finishLineBody, collisionData) -> {
				isLevelEnded = true;
				trace('finish line!!!!!!!!<<<<<<');
			},
		});

		#if debug
		drawGrid();
		#end
	}

	override function destroy() {
		super.destroy();
		controller.disable();
	}

	// var isLevelComplete:Bool = false;
	var isLevelEnded:Bool = false;
	var isLevelStopping:Bool = false;

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		emitter.update(elapsedSeconds);
		if (isLevelStopping) {
			return;
		}
		ship.update(elapsedSeconds);
		var speedMod = ship.getSpeedMod() * 2.5;
		background.update(elapsedSeconds);

		for (a in level.actors) {
			a.setSpeedMod(speedMod);
			a.update(elapsedSeconds);
			level.finishLine.core.body.velocity.x = Configuration.baseVelocityX * speedMod;
		}

		if (!ship.hasShields) {
			isLevelEnded = true;

			isLevelStopping = true;
			trace('\n - \n ---- game over \n - \n ');
			final fadeOutIncrement = 0.4;
			audio.stopMusic(() -> app.changeScene(new MovieScene(app, Configuration.gameOverScene, new PlayScene(app, levelIndex))), fadeOutIncrement);
		}

		if (isLevelEnded && ship.hasShields) {
			trace('level complete');
			isLevelStopping = true;
			// if was a bombing level and the targets are not destroyed, it's game over with super nova
			if (level.levelStyle == Neutralize) {
				var targetActors = level.actors.filter(obstacle -> obstacle.core.body.collider.type == TARGET);
				var targetActorsAlive = targetActors.filter(obstacle -> obstacle.core.sprite.tile != obstacle.core.body.obstacleConfiguration.spriteTileIdEnd);
				var restartNeutralizeLevel = targetActorsAlive.length > 0;
				trace(' num targets  ${targetActors.length} num alive ${targetActorsAlive.length}');
				if (restartNeutralizeLevel) {
					trace('restarting neutralize effort');
					isLevelStopping = true;
					audio.stopMusic(() -> app.changeScene(new MovieScene(app, levelConfig.cutSceneConfig, new PlayScene(app, levelIndex))));
					// app.changeScene(new MovieScene(app, levelConfig.cutSceneConfig, scene -> app.changeScene(new PlayScene(app, levelIndex))));
					return;
				}
			}
			// else play next level scene
			switch levelConfig.nextLevel {
				// case Intro: setCutScene(Configuration.introCutScene);
				// case GameOver: setCutScene(Configuration.gameOverScene);
				// case GameWin: setCutScene(Configuration.gameWinScene);
				case NextLevel(nextLevelIndex):
					trace('\n - \n ---- change to next level \n - \n ');
					// app.changeScene(new PlayScene(Configuration.levels[nextLevelIndex], app));

					audio.stopMusic(() -> app.changeScene(new MovieScene(app, Configuration.levels[nextLevelIndex].cutSceneConfig,
						new PlayScene(app, nextLevelIndex))));
				case _:
					trace('\n - \n ---- game WON \\o/ \\o/ \\o/ \n - \n ');
					audio.stopMusic(() -> app.changeScene(new MovieScene(app, Configuration.gameWinScene, null)));
			}
		}
	}

	var emitterTiles:SpriteRenderer;

	var emitter:Emitter;
}
