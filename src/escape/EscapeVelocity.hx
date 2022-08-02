package escape;

import echo.Echo;
import tyke.Ldtk;
import echo.World;
import concepts.Core;
import echo.Body;
import concepts.Core.GamePiece;
import core.Controller;
import tyke.Loop;
import Main;
import tyke.Graphics;
import tyke.Glyph;
import peote.view.Color;

class EscapeVelocity extends FullScene {
	var stars:Array<Star>;
	var starfieldSpeed:Float;

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
		// generate star range
		var numStars = 60;
		starfieldSpeed = 0;
		stars = [
			for (i in 0...numStars) {
				var x = randomInt(this.width);
				var y = randomInt(64);
				var color = Color.WHITE;
				var distanceChance = randomInt(3);
				var distanceFactor = switch distanceChance {
					// case 1: -0.05;
					// case 2: -0.7;
					// case 3: -0.5;
					// case _: -0.01;
					// case 1: -0.05;
					case 2: 0.9;
					case 3: 0.2;
					case _: 0.01;
				};
				var minAlpha = 90;
				var maxAlpha = (222 - minAlpha);
				var alpha = (maxAlpha * distanceFactor) + minAlpha;
				color.alpha = Std.int(alpha);
				new Star(x, y, distanceFactor, starRenderer.makeShape(x, y, 1, 1, RECT, color), starSpriteRenderer.makeSprite(x, y, 64, 1));
			}

		];

		var shipX = 90;
		var shipY = 40;
		var shipW = 8;
		var shipH = 4;
		var shipTileId = 16;
		var shipSpeed = 1.0;
		var maxTravelDistance = 40;
		var shipTileSize = 14;

		ship = new Ship(shipX, shipY, shipW, shipH, tiles14px.makeSprite(shipX, shipY, shipTileSize, shipTileId), new Body({
			shape: {
				solid: false,
				// radius: radius,
				width: shipW,
				height: shipH,
			},
			mass: 1,
			x: shipX,
			y: shipY,
			kinematic: true
		}), {
			renderer: debugShapes,
			color: 0xff202080
		},
		shipSpeed,
		maxTravelDistance);

		world.add(ship.body);

		var speedUpPause = 0.4;
		behaviours = [
			new CountDown(speedUpPause, () -> {
				starfieldSpeed = (ship.body.x / 128);
				// trace('starfieldSpeed $starfieldSpeed');
			}, true),
			new CountDown(0.2, () -> {
				for (star in stars) {
					star.update(starfieldSpeed);
				}
			}, true),
		];

		level = new Level(debugShapes, spaceLevelTiles, world, 0);
		
		world.listen(ship.body, level.obstacles, {

			enter: (shipBody, obstacleBody, collisionData) -> {
				trace('collide ship id ${shipBody.id}  x ${shipBody.x} y ${shipBody.y} obstacle id ${obstacleBody.id} x ${obstacleBody.x} y ${obstacleBody.y} ');
				app.resetScene();
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

	var controller:Controller;

	var ship:Ship;
	// override function onMouseDown(x:Float, y:Float, button:MouseButton) {
	// 	super.onMouseDown(x, y, button);
	// 	@:privateAccess
	// 	ship.body.x = app.core.display.localX(x) - stage.globalFrameBuffer.display.xOffset;
	// 	@:privateAccess
	// 	ship.body.y = app.core.display.localX(y) - stage.globalFrameBuffer.display.yOffset;
	// 	trace('${ship.body.x}, ${ship.body.y}');
	// }

	var level:Level;
}

class Star {
	public var shape:Shape;
	public var x:Float;

	var y:Int;
	var xOffset:Int;
	var xTruncLast:Int = 0;
	var distanceFactor:Float;

	public function new(xOffset:Int, y:Int, distanceFactor:Float, shape:Shape, sprite:Sprite) {
		this.xOffset = xOffset;
		this.x = xOffset;
		this.y = y;
		this.distanceFactor = distanceFactor;
		this.shape = shape;
		this.sprite = sprite;
		this.sprite.h = 1;
		shape.color.alpha = 0;
	}
	var speed:Float;
	var maximumTravel = 24;
	var maximumTrail = 24;

	public function update(starfieldSpeed:Float) {
		speed = starfieldSpeed * distanceFactor;
		// trace('star speed $speed');
		shape.x -= (maximumTravel * speed);
		if (shape.x < -maximumTravel) {
			shape.x = 64 + maximumTravel;
		}
		sprite.x = shape.x;
		var trailSpeed = speed * 0.5;
		shape.w = Std.int(maximumTrail * trailSpeed);
		sprite.w = shape.w;
	}

	public function setX(nextX:Int) {
		x = nextX;
		shape.x = nextX;
	}

	var sprite:Sprite;
}
