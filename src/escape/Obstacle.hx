package escape;

import core.Actor;
import escape.Configuration;
import echo.Body;
import core.Actor.BaseActor;

class Obstacle extends BaseActor {
	var config:ObstacleConfiguration;

	public function new(options:ActorOptions, system:ActorSystem, config:ObstacleConfiguration) {
		super(options, system);
		this.config = config;
		core.body.obstacleConfiguration = config;
	}

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
		if (config.isDestructible) {
			kill();
		}
	}
}
