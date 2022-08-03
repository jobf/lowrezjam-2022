package escape;

import echo.data.Types.ShapeType;
import tyke.Loop;
import echo.Body;
import core.Actor;

class Ship extends BaseActor {
	var speed:Float;
	var maxTravelDistance:Int;
	public var weapon(default, null):Weapon;

	public function new(options:ActorOptions, system:ActorSystem, speed:Float, maxTravelDistance:Int) {
		super(options, system);
		this.speed = speed;
		this.maxTravelDistance = maxTravelDistance;
		takeDamageCountdown = new CountDown(1.0, () -> resetTookDamage(), false);
		this.weapon = new Weapon(system);
		behaviours.push(takeDamageCountdown);

		weaponUseCountdown = new CountDown(0.1, () -> resetCanUseWeapon(), false);
		behaviours.push(weaponUseCountdown);
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

	var canUseWeapon:Bool = true;
	var weaponUseCountdown:CountDown;
	function resetCanUseWeapon(){
		canUseWeapon = true;
	}

	public function action(isDown:Bool) {
		if(!isDown) return;

		if (canUseWeapon) {
			canUseWeapon = false;
			weapon.shoot(Std.int(this.core.body.x + 5), Std.int(this.core.body.y + 2), 60.0, 0.0);
			weaponUseCountdown.reset();
		}
	}

	override function collideWith(body:Body) {
		super.collideWith(body);
		switch body.collider.type {
			case ROCK:
				takeDamageFromObstacle(body);
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

	function takeDamageFromObstacle(body:Body) {
		if(body.obstacleConfiguration.damagePoints > 0)		{
			takeDamage();
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

class Weapon {
	var projectileActorSystem:ActorSystem;

	public function new(projectileActorSystem:ActorSystem) {
		this.projectileActorSystem = projectileActorSystem;
	}

	public var projectiles(default, null):Array<Body> = [];
	public function shoot(from_x:Int, from_y:Int, velocity_x:Float, velocity_y:Float) {
		// trace('shoot $from_x $from_y $velocity_x $velocity_y');
		var projectile = new Projectile(projectileActorSystem, from_x, from_y, velocity_x, velocity_y);
		projectiles.push(projectile.core.body);
	}
}

class Projectile extends BaseActor {
	public function new(system:ActorSystem, x:Int, y:Int, velocity_x:Float, velocity_y:Float) {
		super({
			spriteTileSize: 14,
			spriteTileId: 24,
			shape: CIRCLE,
			makeCore: actorFactory,
			debugColor: 0xd6dd00a0,
			collisionType: PROJECTILE,
			bodyOptions: {
				shape: {
					type: ShapeType.CIRCLE,
					solid: false,
					radius: 2,
					width: 4,
					height: 4,
				},
				mass: 1,
				x: x,
				y: y,
				kinematic: true,
				velocity_x: velocity_x,
				velocity_y: velocity_y,
			}
		}, system);
	}

	override function collideWith(body:Body) {
		super.collideWith(body);
		switch body.collider.type {
			case ROCK: endUse();
			case _: return;
		}
	}

	function endUse() {
		// todo - proper destroy function ?
		kill();
	}
}
