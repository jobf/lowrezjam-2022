package escape;

import escape.Weapon;
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

		weapon = new Weapon(system, Configuration.projectiles[BOMB]);

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
		if (!isInvulnerable && !isDead) {
			trace('takeDamage');
			currentShield--;
			isInvulnerable = true;
			core.sprite.setFlashing(true);
			takeDamageCountdown.reset();
		}
	}

	function takeDamageFromObstacle(body:Body) {
		if (body.collider.isActive && body.obstacleConfiguration.damagePoints > 0) {
			takeDamage();
			if (currentShield <= 0) {
				trace('ship shield expleted');
				isDead = true;
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

	inline public function getSpeedMod():Float {
		return (core.body.x / 64) - 1;
	}
}
