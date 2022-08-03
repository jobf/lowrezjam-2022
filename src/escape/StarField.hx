package escape;

import peote.view.Color;
import tyke.Glyph;
import tyke.Loop.CountDown;
import tyke.Graphics;

class StarField {
	var stars:Array<Star>;
	var starfieldSpeed:Float;
	var ship:Ship;
	var behaviours:Array<CountDown>;

	public function new(ship:Ship, width:Int, height:Int, starSprites:SpriteRenderer) {
		this.ship = ship;
		behaviours = [
			new CountDown(0.2, () -> {
				for (star in stars) {
					star.update(starfieldSpeed);
				}
			}, true),
		];

        // generate star range
		var numStars = 60;
		starfieldSpeed = 0;
        
		stars = [
			for (i in 0...numStars) {
				var x = randomInt(width);
				var y = randomInt(height);
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
				new Star(x, y, distanceFactor, starSprites.makeSprite(x, y, 64, 1));
			}

		];

	}

	public function update(elapsedSeconds:Float) {
		starfieldSpeed = ship.core.body.velocity.x;
		for (b in behaviours) {
			b.update(elapsedSeconds);
		}
	}
}

class Star {
    
    var sprite:Sprite;
    var x:Float;
	var y:Int;
	var xOffset:Int;
	var xTruncLast:Int = 0;
	var distanceFactor:Float;

	public function new(xOffset:Int, y:Int, distanceFactor:Float, sprite:Sprite) {
		this.xOffset = xOffset;
		this.x = xOffset;
		this.y = y;
		this.distanceFactor = distanceFactor;
		this.sprite = sprite;
		this.sprite.h = 1;
	}

	var speed:Float;
	var maximumTravel = 24;
	var maximumTrail = 24;

	public function update(starfieldSpeed:Float) {
		speed = starfieldSpeed * distanceFactor;
		// trace('star speed $speed');
		x -= (maximumTravel * speed);
		if (x < -maximumTravel) {
			x = 64 + maximumTravel;
		}
		sprite.x = Std.int(x);
		var trailSpeed = speed * 0.5;
		sprite.w = Std.int(maximumTrail * trailSpeed);
	}

}
