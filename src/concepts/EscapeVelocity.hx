package concepts;

import tyke.Loop;
import Main;
import tyke.Graphics;
import tyke.Glyph;
import peote.view.Color;

class EscapeVelocity extends FullScene {
	var starRenderer:ShapeRenderer;
	var stars:Array<Star>;

	override function create() {
		super.create();
		starRenderer = stage.createShapeRenderLayer("stars");

		// generate star range
		var numStars = 100;

		stars = [
			for (i in 0...numStars) {
				var x = randomInt(64);
				var y = randomInt(64);
				var color = Color.WHITE;
				var speedOption = randomInt(3);
				var speed = switch speedOption {
					case 1: -0.05;
					case 2: -0.7;
					case 3: -0.5;
					case _: -0.01;
				};
				var alpha = 200 * (1 - speed) + 100;
				color.alpha = Std.int(alpha);

				{
					x: x,
					speed: speed,
					shape: starRenderer.makeShape(x, y, 1, 1, RECT, color)
				}
			}
		];

		var speedUpPause = 2;
		behaviours = [
			new CountDown(speedUpPause, () -> {
				trace('speed up');
			}, true),
			new CountDown(0, () -> {
				for (star in stars) {
					star.update();
					if (star.x < 0) {
						star.setX(64);
					}
				}
			}, true),
		];
	}
}

@:structInit
class Star {
	public var shape:Shape;
	public var x:Float;

	var speed:Float;

	inline function shiftX(increment:Float) {
		x += increment;
		shape.x = Math.floor(x);
	}

	public function update() {
		shiftX(speed);
	}

	public function setX(nextX:Int) {
		x = nextX;
		shape.x = nextX;
	}
}
