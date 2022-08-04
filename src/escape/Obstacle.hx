package escape;

import core.Actor;
import escape.Configuration;
import echo.Body;
import core.Actor.BaseActor;

class Obstacle extends BaseActor {
	var config:ObstacleConfiguration;
	var speedMod:Float;

	public function new(options:ActorOptions, system:ActorSystem, config:ObstacleConfiguration) {
		super(options, system);
		this.config = config;
		core.body.obstacleConfiguration = config;
		speedMod = 1.0;
	}

	override function collideWith(body:Body) {
		super.collideWith(body);
		switch body.collider.type {
			case PROJECTILE:
				takeDamage(body);
			case VEHICLE:
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

	override function update(elapsedSeconds:Float) {
		if (isAlive) {
			super.update(elapsedSeconds);
			core.body.velocity.x = config.velocityX * speedMod;
		}
	}

	public function setSpeedMod(speedMod:Float) {
		this.speedMod = speedMod;
	}
}
