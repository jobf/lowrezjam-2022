package escape.scenes;

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
	var starField:StarField;
	var level:Level;
	var ship:Ship;
	var controller:Controller;
	var hudTiles:SpriteRenderer;
	var levelConfig:LevelConfig;
	var shipActorSystem:ActorSystem;
	var sun:Sun;
	var sunSurface:Sprite;
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
		@:privateAccess
		stage.globalFrameBuffer.display.xOffset -= 64;
		hudTiles = tiles14px; // stage.createSpriteRendererFor("assets/sprites/64x14-tiles.png", 64, 14, true);
		var f = hudFrame.makeSprite(64 + 32, 32, 64, 0);
		// world.width = 256;
		// world.height = 256;
		world.dispose();
		world = Echo.start({
			width: 1024,
			height: 1024,
			gravity_y: 100,
			iterations: 2
		});

		level.initLevel(debugShapes, spaceLevelTiles, world, app.core.peoteView);

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
				x: 90,
				y: 40,
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
			sunSurface = tiles640px.makeSprite(0, 0, 640, 0);
			sunSurface.w = Std.int(level.finishLine.core.body.x + 100);
			sunSurface.x = (sunSurface.w / 2);
			behaviours.push(new CountDown(0.3, () -> {
				sunSurface.rotation += 0.3;
				sunSurface.x -= 20;
			}, true));
		}
		ship = new Ship(shipOptions, shipActorSystem, shipSpeed, maxTravelDistance, hudTiles, projectileConfig);
		
		if(level.levelStyle != Neutralize)
		{
			starField = new StarField(ship, 256, 128, starSpriteRenderer);
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
					sunBody.collider.collideWith(shipBody);
					shipBody.collider.collideWith(sunBody);
				},
			});
		}

		controller = new Controller(app.window, {
			onControlUp: isDown -> ship.moveUp(isDown),
			onControlRight: isDown -> ship.moveRight(isDown),
			onControlLeft: isDown -> ship.moveLeft(isDown),
			onControlDown: isDown -> ship.moveDown(isDown),
			onControlAction: isDown -> ship.action(isDown)
		});
		controller.enable();

		// register ship and obstacle collisions
		world.listen(ship.core.body, level.obstacles, {
			enter: (shipBody, obstacleBody, collisionData) -> {
				obstacleBody.collider.collideWith(shipBody);
				shipBody.collider.collideWith(obstacleBody);
			},
		});

		// register projectile and obstacle collisions
		world.listen(ship.weapon.projectiles, level.obstacles, {
			enter: (projectileBody, obstacleBody, collisionData) -> {
				obstacleBody.collider.collideWith(projectileBody);
				projectileBody.collider.collideWith(obstacleBody);
			},
		});

		// register ship and finish line collisions
		world.listen(ship.core.body, level.finishLine.core.body, {
			enter: (shipBody, finishLineBody, collisionData) -> {
				isLevelEnded = true;
				trace('finish line!!!!!!!!<<<<<<');
			},
		});
	}

	override function destroy() {
		super.destroy();
		controller.disable();
	}

	// var isLevelComplete:Bool = false;
	var isLevelEnded:Bool = false;

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		ship.update(elapsedSeconds);
		var speedMod = ship.getSpeedMod() * 1.5;

		for (a in level.actors) {
			a.setSpeedMod(speedMod);
			a.update(elapsedSeconds);
			level.finishLine.core.body.velocity.x = Configuration.baseVelocityX * speedMod;
		}

		if (level.levelStyle != Neutralize) {
			starField.update(elapsedSeconds);
		}

		if (ship.isDead) {
			isLevelEnded = true;
			trace('\n - \n ---- game over \n - \n ');
			app.changeScene(new TitleScene(app, Configuration.gameOverScene, scene -> {
				// do thing
			}));
		}
		if (isLevelEnded && !ship.isDead) {
			trace('level complete');
			// if was a bombing level and the targets are not destroyed, it's game over with super nova
			if (level.levelStyle == Neutralize) {
				var targetActors = level.actors.filter(obstacle -> obstacle.core.body.collider.type == TARGET);
				var targetActorsAlive = targetActors.filter(obstacle -> obstacle.isAlive);
				var levelIsComplete = targetActorsAlive.length == 0;
				if (!levelIsComplete) {
					trace('restarting neutralize effort');
					app.changeScene(new MovieScene(app, levelConfig.cutSceneConfig, scene -> app.changeScene(new PlayScene(app, levelIndex))));
					return;
				}
			}
			// else play scene
			switch levelConfig.nextLevel {
				// case Intro: setCutScene(Configuration.introCutScene);
				// case GameOver: setCutScene(Configuration.gameOverScene);
				// case GameWin: setCutScene(Configuration.gameWinScene);
				case NextLevel(nextLevelIndex):
					trace('\n - \n ---- change to next level \n - \n ');
					// app.changeScene(new PlayScene(Configuration.levels[nextLevelIndex], app));
					app.changeScene(new MovieScene(app, Configuration.levels[nextLevelIndex].cutSceneConfig,
						scene -> app.changeScene(new PlayScene(app, nextLevelIndex))));
				case _:
					trace('\n - \n ---- game WON \\o/ \\o/ \\o/ \n - \n ');
					app.changeScene(new MovieScene(app, Configuration.gameWinScene, scene -> return));
			}
		}
	}
}
