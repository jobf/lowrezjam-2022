package concepts;

import tyke.Loop;
import Main;
import tyke.Graphics;
import tyke.Glyph;
import peote.view.Color;

class EscapeVelocity extends FullScene {
	var starRenderer:ShapeRenderer;
	var stars:Array<Star>;
	var speed:Float;

	override function create() {
		super.create();
		starRenderer = stage.createShapeRenderLayer("stars", false, true, this.width, this.height);
		var layer = stage.getLayer("stars");
		@:privateAccess
		layer.frameBuffer.display.xOffset = -64;
		// generate star range
		var numStars = 85;
		speed = 3;
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
					case 2: -0.9;
					case 3: -0.2;
					case _: -0.01;
				};
				var minAlpha = 90;
				var maxAlpha = (222 - minAlpha);
				var alpha = (maxAlpha * (-distanceFactor)) + minAlpha;
				color.alpha = Std.int(alpha);
				new Star(x, y, distanceFactor, starRenderer.makeShape(x, y, 1, 1, RECT, color));
			}

		];

		var speedUpPause = 0.4;
		behaviours = [
			new CountDown(speedUpPause, () -> {
				speed *= 1.29;
				if (speed > 40) {
					speed = 40;
				}
			}, true),
			new CountDown(0.2, () -> {
				for (star in stars) {
					star.update(speed);
				}
			}, true),
		];
	}
}

class Star {
	public var shape:Shape;
	public var x:Float;

	var y:Int;
	var xOffset:Int;
	var xTruncLast:Int = 0;
	var distanceFactor:Float;

	public function new(xOffset:Int, y:Int, distanceFactor:Float, shape:Shape) {
		this.xOffset = xOffset;
		this.x = xOffset;
		this.y = y;
		this.distanceFactor = distanceFactor;
		this.shape = shape;
	}

	inline function shiftX(increment:Float) {
		x += increment;
		var xTrunc = Math.floor(x);
		var distanceTravelled = xTrunc - xTruncLast;
		var trailLength = 1;
		var w = Std.int(distanceTravelled * distanceFactor);
		if (w > 1) {
			trailLength = w;
		}
		if (w > 40) {
			trailLength = 40;
		}
		shape.w = trailLength;
		shape.x = xTrunc - (trailLength);
		xTruncLast = xTrunc;
		if (x < 64) {
			// xTruncLast = 0;
			// w = 1;
			// x = 128;
			x = this.x = xOffset;
			trace('reset x $x');
		}
	}

	public function update(speed:Float) {
		shiftX(speed * distanceFactor);
	}

	public function setX(nextX:Int) {
		x = nextX;
		shape.x = nextX;
	}
}
