package escape;

import peote.view.Color;
import tyke.Glyph;
import tyke.Loop.CountDown;
import tyke.Graphics;

class StarField {
	var stars:Array<Star>;
	public var starfieldSpeed(default, null):Float;
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
		var numStars = 42;
		starfieldSpeed = 0;

		stars = [
			for (i in 0...numStars) {
				var x = 64 + randomInt(64);
				var y = randomInt(height);
				var distanceLevels = 6;
				var slowDown = 0.5;
				var distanceModifier = 1 / distanceLevels * slowDown;
				var distance = randomInt(distanceLevels);
				distance = Std.int(6 * distanceModifier);
				if(distance == 0){
					distance = 1;
				}
				var star = starSprites.makeSprite(x, y, 64, distance, 0, true, 1);
				// star.z = -100;
				new Star(x, y, distanceModifier, star);
			}

		];
	}

	public function update(elapsedSeconds:Float) {
		starfieldSpeed =  ship.getSpeedMod();
		for (b in behaviours) {
			b.update(elapsedSeconds);
		}
	}
}

class Star {
	var sprite:Sprite;
	var x:Float;
	var y:Int;
	var distanceFactor:Float;

	public function new(x:Int, y:Int, distanceFactor:Float, sprite:Sprite) {
		this.x = x;
		this.y = y;
		this.distanceFactor = distanceFactor;
		this.sprite = sprite;
		this.sprite.w = 2;
		this.sprite.h = 1;
	}

	var speed:Float;
	var maximumTravel = 64;
	var velocity:Float;
	public function update(starfieldSpeed:Float) {
		speed = starfieldSpeed * distanceFactor;
		velocity = maximumTravel * speed;
		x -= velocity;
		if(x < -maximumTravel){
			// x = maximumTravel * 2;
			x = 64 + randomInt(64);
		}
		sprite.x = Std.int(x + maximumTravel);

		// trace('star speed $speed velocity $velocity x $x ${sprite.x}');
		var maxTrail = 60;
		var minTrail = 1;
		var trail = Std.int((speed * 10) * maxTrail);
		if(trail <= minTrail){
			trail = minTrail;
		}
		sprite.w = trail;
	}
}
