package escape.scenes;

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
	var levelProgressIndex:Int;

	public function new(levelProgressIndex:Int, app:App, backgroundColor:Color = 0x000000ff, width:Int = 0, height:Int = 0) {
		super(app, backgroundColor, width, height);
		// this is the current level being played, e.g. 0 will use the first id from levelIds
		this.levelProgressIndex = levelProgressIndex;
	}

	override function create() {
		super.create();

		hudTiles = stage.createSpriteRendererFor("assets/sprites/64x14-tiles.png", 64, 14, true);
		// world.width = 256;
		// world.height = 256;
		world.dispose();
		world = Echo.start({
			width: 1024,
			height: 1024,
			gravity_y: 100,
			iterations: 2
		});
		var layer = stage.getLayer("stars");
		@:privateAccess
		layer.frameBuffer.display.xOffset = -64;

		var shipOptions:ActorOptions = {
			spriteTileSize: 14,
			spriteTileId: 16,
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

		var shipActorSystem:ActorSystem = {
			world: world,
			tiles: tiles14px,
			shapes: debugShapes,
			peoteView: app.core.peoteView
		};

		var shipSpeed = 1.0;
		var maxTravelDistance = 40;
		ship = new Ship(shipOptions, shipActorSystem, shipSpeed, maxTravelDistance, hudTiles);

		starField = new StarField(ship, 256, 128, starSpriteRenderer);

		// these are the id's of the levels used from ldtk
		final levelIds = [0, 0, 0];
		level = new Level(debugShapes, spaceLevelTiles, world, app.core.peoteView, levelIds[levelProgressIndex]);

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

		var sunActorSystem:ActorSystem = {
			world: world,
			tiles: tiles14px,
			shapes: debugShapes,
			peoteView: app.core.peoteView
		};

		// sun = new Sun(sunActorSystem);

		// // register ship and sun collisions
		// world.listen(ship.core.body, sun.core.body, {
		// 	enter: (shipBody, sunBody, collisionData) -> {
		// 		sunBody.collider.collideWith(shipBody);
		// 		shipBody.collider.collideWith(sunBody);
		// 	},
		// });

		// register ship and finish line collisions
		world.listen(ship.core.body, level.finishLine.core.body, {
			enter: (shipBody, finishLineBody, collisionData) -> {
				endLevel();
			},
		});

		controller = new Controller(app.window, {
			onControlUp: isDown -> ship.moveUp(isDown),
			onControlRight: isDown -> ship.moveRight(isDown),
			onControlLeft: isDown -> ship.moveLeft(isDown),
			onControlDown: isDown -> ship.moveDown(isDown),
			onControlAction: isDown -> ship.action(isDown)
		});
		controller.enable();
	}

	override function destroy() {
		super.destroy();
		controller.disable();
	}

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		ship.update(elapsedSeconds);
		starField.update(elapsedSeconds);
		var speedMod = starField.starfieldSpeed * 1.5;

		for (a in level.actors) {
			a.setSpeedMod(speedMod);
			a.update(elapsedSeconds);
		}
		level.finishLine.core.body.velocity.x = Configuration.finishLineVelocity * speedMod;
	}

	var sun:Sun;

	function traceSun() {
		trace('sun ${sun.core.body.x} ${sun.core.body.y}');
	}

	// override function scrollDown() {
	// 	// super.scrollDown();
	// 	sun.core.body.y -= scrollIncrement;
	// 	traceSun();
	// }
	// override function scrollUp() {
	// 	// super.scrollUp();
	// 	sun.core.body.y += scrollIncrement;
	// 	traceSun();
	// }
	// override function scrollLeft() {
	// 	// super.scrollLeft();
	// 	sun.core.body.x -= scrollIncrement;
	// 	traceSun();
	// }
	// override function scrollRight() {
	// 	// super.scrollRight();
	// 	sun.core.body.x += scrollIncrement;
	// 	traceSun();
	// }

	function endLevel() {
		var nextLevelIndex = levelProgressIndex + 1;
		trace('end level, starting $nextLevelIndex');
		app.changeScene(new CutScene(nextLevelIndex, app, Configuration.cutScenes[0]));
	}
}
