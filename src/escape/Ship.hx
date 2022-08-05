package escape;

import tyke.Graphics.SpriteRenderer;
import echo.data.Types.ShapeType;
import tyke.Loop;
import echo.Body;
import core.Actor;

class Ship extends BaseActor {
	var speed:Float;
	var maxTravelDistance:Int;

	public var isDead(default, null):Bool = false;
	public var weapon(default, null):Weapon;

	public function new(options:ActorOptions, system:ActorSystem, speed:Float, maxTravelDistance:Int, hudTiles:SpriteRenderer) {
		super(options, system);
		this.speed = speed;
		this.maxTravelDistance = maxTravelDistance;

		maxShield = 6;
		currentShield = 6;

		weapon = new Weapon(system);
		hud = new Hud(hudTiles, weapon);

		takeDamageCountdown = new CountDown(1.0, () -> resetTookDamage(), false);
		behaviours.push(takeDamageCountdown);

		weaponUseCountdown = new CountDown(0.15, () -> resetCanUseWeapon(), false);
		behaviours.push(weaponUseCountdown);
	}

	var isMovingVertical:Bool;
	var isMovingHorizontal:Bool;

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		weapon.update(elapsedSeconds);
		hud.update(shieldPercent);
	}

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

	function resetCanUseWeapon() {
		canUseWeapon = true;
	}

	public function action(isDown:Bool) {
		if (!isDown)
			return;

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
		if (!isInvulnerable && currentShield > 1) {
			trace('takeDamage');
			currentShield--;
			isInvulnerable = true;
			core.sprite.setFlashing(true);
			takeDamageCountdown.reset();
		}
	}

	function takeDamageFromObstacle(body:Body) {
		if (body.obstacleConfiguration.damagePoints > 0) {
			takeDamage();
			if (currentShield <= 0) {
				// isDead = true;
			}
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

	public var shieldPercent(get, null):Float;

	var hud:Hud;

	var maxShield:Int;

	var currentShield:Int;

	function get_shieldPercent():Float {
		return currentShield / maxShield;
	}
}

class Weapon {
	var projectileActorSystem:ActorSystem;

	public function new(projectileActorSystem:ActorSystem) {
		this.projectileActorSystem = projectileActorSystem;
		refillWeaponCountdown = new CountDown(4.0, () -> increaseShotsAvailable(), true);
	}

	public var totalShots(default, null):Int = 6;
	public var shotsAvailable(default, null):Int = 6;
	public var projectiles(default, null):Array<Body> = [];

	public function shoot(from_x:Int, from_y:Int, velocity_x:Float, velocity_y:Float) {
		// trace('shoot $from_x $from_y $velocity_x $velocity_y');
		if (shotsAvailable > 0) {
			var projectile = new Projectile(projectileActorSystem, from_x, from_y, velocity_x, velocity_y);
			projectiles.push(projectile.core.body);
			shotsAvailable--;
		}
	}

	public function update(elapsedSeconds:Float) {
		refillWeaponCountdown.update(elapsedSeconds);
	}

	var refillWeaponCountdown:CountDown;

	function increaseShotsAvailable() {
		if (shotsAvailable < totalShots) {
			shotsAvailable++;
		}
	}
}

// @:structInit
// class WeaponConfiguration{
//     /**
//         how wide the collision body should be (full width not radius)
//     **/
// 	public var hitboxWidth:Int;
//     /**
//         how high the collision body should be (full width not radius)
//     **/
// 	public var hitboxHeight:Int;
//     /**
//         the speed the body moves at, negative values means moving to the left
//     **/
// 	public var velocityX:Float;
//     /**
//         if it's a CIRCLE or RECT (rectangle)
//     **/
// 	public var shape:Geometry;
// 	/**
// 		if the obstacle can be destroyed set this to true
// 	**/
// 	public var isDestructible:Bool;
// 	/**
// 		how much damage the obstacle inflicts on a ship when colliding
// 	**/
// 		public var damagePoints:Int;
// }

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
			case ROCK:
				endUse();
			case _:
				return;
		}
	}

	function endUse() {
		// todo - proper destroy function ?
		kill();
	}
}
