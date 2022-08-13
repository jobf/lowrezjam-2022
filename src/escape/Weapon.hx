package escape;

import tyke.Graphics;
import echo.data.Types;
import echo.Body;
import tyke.Loop;
import core.Actor;
import core.Emitter;

class Weapon {
	var projectileActorSystem:ActorSystem;
	var projectileConfig:ProjectileConfiguration;

	public function new(projectileActorSystem:ActorSystem, projectileConfig:ProjectileConfiguration) {
		this.projectileActorSystem = projectileActorSystem;
		this.projectileConfig = projectileConfig;
		this.totalShots = projectileConfig.totalShots;
		this.shotsAvailable = projectileConfig.totalShots;
		projectiles = [];
		refillWeaponCountdown = new CountDown(projectileConfig.refillSpeed, () -> increaseShotsAvailable(), true);
	}

	public var totalShots(default, null):Int;
	public var shotsAvailable(default, null):Int;
	public var projectiles(default, null):Array<Body>;
	public var onShoot:Void->Void;
	public var onShotsIncreased:Void->Void;

	public function shoot(from_x:Int, from_y:Int, velocity_x:Float, velocity_y:Float) {
		// trace('shoot $from_x $from_y $velocity_x $velocity_y');
		if (projectileActorSystem.world.members == null) {
			trace('how can this happen?');
		} else {
			if (shotsAvailable > 0) {
				var projectile = new Projectile(projectileActorSystem, from_x, from_y, projectileConfig);
				projectiles.push(projectile.core.body);
				shotsAvailable--;
				if (onShoot != null) {
					onShoot();
				}
			}
		}
	}

	public function update(elapsedSeconds:Float) {
		refillWeaponCountdown.update(elapsedSeconds);
	}

	var refillWeaponCountdown:CountDown;

	function increaseShotsAvailable() {
		if (shotsAvailable < totalShots) {
			shotsAvailable++;
			if (onShotsIncreased != null) {
				onShotsIncreased();
			}
		}
	}
}

@:enum abstract ProjectileType(Int) from Int to Int {
	var STANDARD;
	var BOMB;
}

@:structInit
class ProjectileConfiguration {
	/**
		how wide the collision body should be (full width not radius)
	**/
	public var hitboxWidth:Int = 4;

	/**
		how high the collision body should be (full width not radius)
	**/
	public var hitboxHeight:Int = 2;

	/**
		the speed the body moves at, negative values means moving to the left
	**/
	public var velocityXMod:Float = 1.0;

	/**
		if it's a CIRCLE or RECT (rectangle)
	**/
	public var shape:Geometry = RECT;

	/**
		if the projectile is destroyed on impact
	**/
	public var isDestructible:Bool = true;

	/**
		how long it takes between shots
	**/
	public var shotCooldown:Float;

	/**
		the tile index to use for the sprite
	**/
	public var spriteTileIdStart:Int;

	/**
		the tile size to use for the sprite
	**/
	public var spriteTileSize:Int = 14;

	/**
		the number of shots available before reload
	**/
	public var totalShots:Int = 6;

	/**
		how long it takes to refill a single shot
	**/
	public var refillSpeed(default, null):Float = 0.5;
}

class Projectile extends BaseActor {
	final isActiveWithinX:Int = 72;
	public function new(system:ActorSystem, x:Int, y:Int, config:ProjectileConfiguration) {
		super({
			spriteTileSize: config.spriteTileSize,
			spriteTileIdStart: config.spriteTileIdStart,
			shape: config.shape,
			makeCore: actorFactory,
			debugColor: 0xd6dd00a0,
			collisionType: PROJECTILE,
			bodyOptions: {
				shape: {
					type: config.shape == CIRCLE ? ShapeType.CIRCLE : ShapeType.RECT,
					solid: false,
					radius: Std.int(config.hitboxWidth / 2),
					width: config.hitboxWidth,
					height: config.hitboxHeight,
				},
				mass: 1,
				x: x,
				y: y,
				kinematic: true,
				velocity_x: Configuration.baseWeaponVelocityX * config.velocityXMod,
				velocity_y: 0,
			}
		}, system);
		isDangerous = true;
	}

	override function collideWith(collidingBody:Body, emitter:Emitter) {
		super.collideWith(collidingBody, emitter);
		switch collidingBody.collider.type {
			case ROCK:
				endUse(collidingBody);
			case TARGET:
				endUse(collidingBody);
			case _:
				return;
		}
	}

	override function onMove(x:Float, y:Float) {
		super.onMove(x, y);
		if(isAlive && x > this.isActiveWithinX){
			isAlive = false;
			core.body.data.isAlive = false;
			trace('projectil oob');
		}
	}
	function endUse(body:Body) {
		if(!body.obstacleConfiguration.letProjectileThrough){
			// todo - proper destroy function ?
				trace('projectil ended');
				kill();
		}
	}
}
