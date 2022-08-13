package escape;

import tyke.Glyph.randomFloat;
import tyke.Glyph.randomInt;
import tyke.Loop;
import tyke.Graphics;
import core.Actor;
import core.Emitter;
import escape.Configuration;
import echo.Body;

class Obstacle extends BaseActor {
	var config:ObstacleConfiguration;
	var speedMod:Float;

	public function new(options:ActorOptions, system:ActorSystem, config:ObstacleConfiguration) {
		super(options, system);
		this.config = config;
		core.body.obstacleConfiguration = config;
		speedMod = 1.0;
	}

	override function collideWith(collidingBody:Body, emitter:Emitter) {
		super.collideWith(collidingBody, emitter);
		trace('obstacle hit by ${collidingBody.collider.type}');
		switch collidingBody.collider.type {
			case PROJECTILE:
				takeDamage(collidingBody, emitter);
			case VEHICLE:
				takeDamage(collidingBody, emitter);
			case SUN:
				takeDamage(collidingBody, emitter, true);
			case _:
				return;
		}
	}

	function takeDamage(collidingBody:Body, emitter:Emitter, isHittingSun:Bool=false) {
		final sparksTile = 51;
		final brokenAsteroidTileStart = 48;
		
		var shouldEmit = isHittingSun 
			|| (!core.body.obstacleConfiguration.letProjectileThrough && core.body.collider.type != TARGET);
		
		if (shouldEmit) {
			var isRockCracking = false;
			for(i in 0...core.body.obstacleConfiguration.numParticles){
				
				var particleTile = isHittingSun ? brokenAsteroidTileStart + randomInt(2)
					: core.body.obstacleConfiguration.isDestructible
						? brokenAsteroidTileStart + randomInt(2)
						: sparksTile;

				isRockCracking = particleTile != sparksTile;
				// trace('hit obstacle, tileid ${core.sprite.tile} emit $particleTile x ${core.body.obstacleConfiguration.numParticles}');
				
				emitter.emit(core.body.x, core.body.y, core.body.velocity.x * -1, randomFloat(0, 300) - 150, particleTile);
			}
			if(isRockCracking){
				system.soundEffects.playSound(CrackRock);
			}
		}
		
		if (config.isDestructible || isHittingSun) {
			if (collidingBody.collider.type == VEHICLE && core.body.collider.type == TARGET) {
				// do nothin
			} else {
				kill();
				trace('kill ${core.body.collider.type}');
			}
		}

		if (core.body.collider.type == TARGET) {
			// should still be alive so it can track movement - crap fix but whatever
			isAlive = true;
			var anim:AnimatedObstacle = cast this;
			anim.startAnimation();
			trace('play target anim ${anim}');
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

class AnimatedObstacle extends Obstacle {
	var refreshFrameCountdown:CountDown;
	var totalFrames:Int;
	var currentFrame:Int = 0;
	var frames:Array<Int>;

	public var isComplete(get, null):Bool;

	function get_isComplete():Bool {
		return currentFrame >= frames.length - 1;
	}

	public function new(options:ActorOptions, system:ActorSystem, config:ObstacleConfiguration, frames:Array<Int>, framesPerSecond:Int, autoPlayLoop:Bool=true) {
		super(options, system, config);
		this.frames = frames;
		totalFrames = frames.length;
		refreshFrameCountdown = new CountDown(1 / framesPerSecond, () -> advanceFrame(), autoPlayLoop);
		isLooped = autoPlayLoop;
		if(!autoPlayLoop){
			refreshFrameCountdown.stop();
		}
		currentFrame = frames.indexOf(core.sprite.tile); // randomInt(frames.length - 1);
		core.sprite.tile = frames[currentFrame];
		// trace('starting frame index $currentFrame starting tile id ${core.sprite.tile}');
		core.body.collider.isActive = false;
	}

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		refreshFrameCountdown.update(elapsedSeconds);
		if (isComplete && isLooped) {
			currentFrame = 0;
		}
		core.sprite.tile = frames[currentFrame];
		if(isLooped){ // actually isFlare
			core.body.collider.isActive = core.sprite.tile >= 64 && core.sprite.tile <= 74;
		}
	}

	function advanceFrame() {
		currentFrame++;
		// trace('new frame is ${config.frames[currentFrame]}');
	}


	public function startAnimation() {
		trace('startAnimation');
		refreshFrameCountdown.reset();
	}

	// override function collideWith(body:Body) {
	// 	// super.collideWith(body);
	// }

	var isLooped:Bool;
}

@:structInit
class ObstacleConfiguration {
	/**
		how wide the collision body should be (full width not radius)
	**/
	public var hitboxWidth:Int;

	/**
		how high the collision body should be (full width not radius)
	**/
	public var hitboxHeight:Int;

	/**
		the speed the body moves at, negative values means moving to the left
	**/
	public var velocityModX:Float = 1.0;

	/**
		if it's a CIRCLE or RECT (rectangle)
	**/
	public var shape:Geometry;

	/**
		if the obstacle can be destroyed set this to true
	**/
	public var isDestructible:Bool;

	/**
		how many particles to make if destroyef
	**/
	public var numParticles:Int = 1;

	/**
		if the obstacle should let projectiles pass through (otherwise projectil is destroyed)
	**/
	public var letProjectileThrough:Bool = false;

	/**
		how much damage the obstacle inflicts on a ship when colliding
	**/
	public var damagePoints:Int;

	/**
		sprite index to load after the obstacle has been destroyed 
		-1 means the sprite will no longer be visible
	**/
	public var spriteTileIdEnd:Int = -1;

}
