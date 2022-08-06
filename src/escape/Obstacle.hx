package escape;

import tyke.Glyph.randomInt;
import tyke.Loop;
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
			core.body.velocity.x = (Configuration.baseVelocityX * speedMod) * config.velocityModX;
		}
	}

	public function setSpeedMod(speedMod:Float) {
		this.speedMod = speedMod;
	}
}


class Flare extends Obstacle{	
	var refreshFrameCountdown:CountDown;
	var totalFrames:Int;
	var currentFrame:Int = 0;
	var frames:Array<Int>;
    public var isComplete(get, null):Bool;
	

	function get_isComplete():Bool {
		return currentFrame >= frames.length - 1;
	}

	public function new(options:ActorOptions, system:ActorSystem, config:ObstacleConfiguration, frames:Array<Int>, framesPerSecond:Int) {
		super(options, system, config);
		this.frames = frames;
		totalFrames = frames.length;
		refreshFrameCountdown = new CountDown(1 / framesPerSecond, () -> advanceFrame(), true);
		currentFrame = frames.indexOf(core.sprite.tile);//randomInt(frames.length - 1);
		core.sprite.tile = frames[currentFrame];
		trace('starting frame index $currentFrame starting tile id ${core.sprite.tile}');
		core.body.collider.isActive = false;
	}

    override function update(elapsedSeconds:Float){
		super.update(elapsedSeconds);
		refreshFrameCountdown.update(elapsedSeconds);
		if(isComplete){
			currentFrame = 0;
		}
		core.sprite.tile = frames[currentFrame];
		core.body.collider.isActive = currentFrame >= 5;
    }


	function advanceFrame() {
        currentFrame++;
		// trace('new frame is ${config.frames[currentFrame]}');
	}


	// override function collideWith(body:Body) {
	// 	// super.collideWith(body);

	// }

}