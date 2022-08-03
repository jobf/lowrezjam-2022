package escape;

import echo.Body;
import core.Actor.BaseActor;

class Obstacle extends BaseActor {
	override function collideWith(body:Body) {
		super.collideWith(body);
		switch body.collider.type {
			case PROJECTILE:
				takeDamage(body);
			case _:
				return;
		}
	}

	function takeDamage(body:Body) {
		if (isDestructible) {
			kill();
		}
	}
}
