package escape;

import tyke.Loop;
import echo.Body;
import core.Actor;

class Ship extends BaseActor {
	var speed:Float;
	var maxTravelDistance:Int;

	public function new(options:ActorOptions, system:ActorSystem, speed:Float, maxTravelDistance:Int) {
		super(options, system);
		this.speed = speed;
		this.maxTravelDistance = maxTravelDistance;
		takeDamageCountdown = new CountDown(1.0, () -> resetTookDamage(), false);
		behaviours.push(takeDamageCountdown);
	}

	var isMovingVertical:Bool;
	var isMovingHorizontal:Bool;

	public function moveUp(isDown:Bool) {
		isMovingVertical = isDown;
		if (isMovingVertical) {
			core.body.velocity.y = -Std.int(maxTravelDistance * speed);
		} else {
			core.body.velocity.y = 0;
		}
	}

	public function moveRight(isDown:Bool) {
		isMovingHorizontal = isDown;
		if (isMovingHorizontal) {
			core.body.velocity.x = Std.int(maxTravelDistance * speed);
		} else {
			core.body.velocity.x = 0;
		}
	}

	public function moveLeft(isDown:Bool) {
		isMovingHorizontal = isDown;
		if (isMovingHorizontal) {
			core.body.velocity.x = -Std.int(maxTravelDistance * speed);
		} else {
			core.body.velocity.x = 0;
		}
	}

	public function moveDown(isDown:Bool) {
		isMovingVertical = isDown;
		if (isMovingVertical) {
			core.body.velocity.y = Std.int(maxTravelDistance * speed);
		} else {
			core.body.velocity.y = 0;
		}
	}

	public function action(isDown:Bool) {}

	override function collideWith(body:Body) {
		super.collideWith(body);
		switch body.collider.type {
			case ROCK:
				takeDamage();
			case SUN:
				trace('hit sun');
				takeDamage();
			case _:
				trace('unhandled collision');
				return;
		}
	}

	var takeDamageCountdown:CountDown;

	function takeDamage() {
		if (!isInvulnerable) {
			trace('takeDamage');
			isInvulnerable = true;
			core.sprite.setFlashing(true);
			takeDamageCountdown.reset();
		}
	}

	var isInvulnerable:Bool;

	inline function resetTookDamage() {
		if (isInvulnerable) {
			trace('resetTookDamage');
			isInvulnerable = false;
			core.sprite.setFlashing(false);
		}
	}
}
