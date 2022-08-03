package escape;

import core.Actor;
import echo.Echo;
import echo.Body;
import core.Controller;
import tyke.Loop;
import Main;
import tyke.Graphics;
import tyke.Glyph;
import peote.view.Color;

class EscapeVelocity extends FullScene {
	
	var starField:StarField;
	var level:Level;
	var ship:Ship;
	var controller:Controller;

	override function create() {
		super.create();
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
		ship = new Ship(shipOptions, shipActorSystem, shipSpeed, maxTravelDistance);
		
		starField = new StarField(ship, 256, 128, starSpriteRenderer);
		level = new Level(debugShapes, spaceLevelTiles, world, app.core.peoteView, 0);

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

		// register ship and sun collisions
		// world.listen(ship.core.body, sun.core.body, {
		// 	enter: (shipBody, sunBody, collisionData) -> {
		// 		sunBody.collider.collideWith(shipBody);
		// 		shipBody.collider.collideWith(sunBody);
		// 	},
		// });

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
		for (a in level.actors) {
			a.update(elapsedSeconds);
		}
		starField.update(elapsedSeconds);
	}

	var sun:Sun;
	function traceSun(){
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
}
