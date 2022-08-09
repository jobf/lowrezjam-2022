package escape;

import peote.view.Color;
import tyke.Glyph;
import tyke.Loop.CountDown;
import tyke.Graphics;

class StarField extends ShipTrackingBackground {
	var stars:Array<Star>;

	public function new(ship:Ship, width:Int, height:Int, sprites:SpriteRenderer) {
		super(ship, width, height, sprites);
		behaviours.push(
			new CountDown(0.2, () -> {
				for (star in stars) {
					star.update(speedMod);
				}
			}, true)
		);

		// generate star range
		var numStars = 42;
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
				new Star(x, y, distanceModifier, sprites.makeSprite(x, y, 64, distance, 0, true, 1));
			}

		];
	}

}

class SunSurface extends ShipTrackingBackground{
	var sunSurface:Sprite;
	var sunSurfaceSpeed:Float = 30;
	public function new(ship:Ship, width:Int, height:Int, sprites:SpriteRenderer) {
		super(ship, width, height, sprites);

		sunSurface = sprites.makeSprite(0, 0, 640, 0);
		sunSurface.w = width;
		sunSurface.h = height;
		sunSurface.y += 50;//
		sunSurface.x = (sunSurface.w / 2);
		behaviours.push(new CountDown(0.3, () -> {
			// sunSurface.rotation += 0.3;
			sunSurface.x -= sunSurfaceSpeed * speedMod;
		}, true));
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




class ShipTrackingBackground {
	var ship:Ship;
	var behaviours:Array<CountDown>;
	var sprites:SpriteRenderer;
	var speedMod:Float;

	public function new(ship:Ship, width:Int, height:Int, sprites:SpriteRenderer) {
		this.ship = ship;
		this.sprites = sprites;
		speedMod = ship.getSpeedMod();
		behaviours = [];
	}

	public function update(elapsedSeconds:Float) {
		speedMod =  ship.getSpeedMod();
		for (b in behaviours) {
			b.update(elapsedSeconds);
		}
	}
}