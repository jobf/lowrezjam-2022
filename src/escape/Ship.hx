package escape;

import escape.Weapon;
import tyke.Graphics.SpriteRenderer;
import echo.data.Types.ShapeType;
import tyke.Loop;
import echo.Body;
import core.Actor;
// import escape.HudFun.Hud;
import escape.Hud;

class Ship extends BaseActor {
	var speed:Float;
	var maxTravelDistance:Int;

	public var hasShields(default, null):Bool = false;
	public var weapon(default, null):Weapon;

	public function new(options:ActorOptions, system:ActorSystem, speed:Float, maxTravelDistance:Int, hudTiles:SpriteRenderer,
			projectileConfig:ProjectileConfiguration, projectileSprites:SpriteRenderer) {
		super(options, system);
		this.speed = speed;
		this.maxTravelDistance = maxTravelDistance;

		maxShield = 6;
		currentShield = 6;

		var protectilesSystem:ActorSystem = {
			world: system.world,
			tiles: projectileSprites,
			shapes: system.shapes,
			peoteView: system.peoteView
		};

		weapon = new Weapon(protectilesSystem, projectileConfig);

		hud = new Hud(hudTiles, weapon);

		takeDamageCountdown = new CountDown(0.75, () -> resetTookDamage(), false);
		behaviours.push(takeDamageCountdown);

		weaponUseCountdown = new CountDown(0.1, () -> resetCanUseWeapon(), false);
		behaviours.push(weaponUseCountdown);
		hasShields = true;
		// core.sprite.z = 0;

	}

	var isMovingVertical:Bool;
	var isMovingHorizontal:Bool;

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		weapon.update(elapsedSeconds);
		if (isShooting && canUseWeapon) {
			canUseWeapon = false;
			weapon.shoot(Std.int(this.core.body.x + 5), Std.int(this.core.body.y + 2), 60.0, 0.0);
			weaponUseCountdown.reset();
		}

		// keep within bounds
		final marginH = 8;
		if (isMovingHorizontal) {
			if (core.body.x < 1 + marginH) {
				core.body.x = 1 + marginH;
			}
			if (core.body.x > 64 - 8) {
				core.body.x = 64 - 8;
			}
		}

		final marginV = 4;
		if (isMovingVertical) {
			if (core.body.y < 0 + marginV) {
				core.body.y = 0 + marginV;
			}
			if (core.body.y > 64 - marginV) {
				core.body.y = 64 - marginV;
			}
		}

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

	var isShooting:Bool = false;
	var canUseWeapon:Bool = true;
	var weaponUseCountdown:CountDown;

	function resetCanUseWeapon() {
		canUseWeapon = true;
	}

	public function action(isDown:Bool) {
		// if (!isDown)
		// 	return;
		isShooting = isDown;
	}

	override function collideWith(body:Body) {
		super.collideWith(body);

		if (!hasShields)
			return;

		switch body.collider.type {
			case ROCK:
				takeDamageFromObstacle(body);
			case SUN:
				trace('hit sun');
				takeDamageFromObstacle(body, true);
			case _:
				trace('unhandled collision');
				return;
		}
		// if()
	}

	var takeDamageCountdown:CountDown;

	function takeDamage() {
		if (!isInvulnerable && currentShield > 0) {
			trace('takeDamage');
			currentShield--;
			isInvulnerable = true;
			core.sprite.setFlashing(true);
			takeDamageCountdown.reset();
			@:privateAccess
			hud.shieldMeterSprite.setFlashing(true);
		}
	}

	function takeDamageFromObstacle(body:Body, isInstaKill:Bool = false) {

		if(isInstaKill){
			currentShield = -1;
		}
		else if (body.obstacleConfiguration != null) {
			if(body.collider.isActive && body.obstacleConfiguration.damagePoints > 0){
				takeDamage();
			}
		}
		
		if(currentShield <= 0){
			trace('ship shield expleted');
			hasShields = false;
		}
	}

	var isInvulnerable:Bool;

	inline function resetTookDamage() {
		if (isInvulnerable) {
			trace('resetTookDamage');
			isInvulnerable = false;
			core.sprite.setFlashing(false);
			@:privateAccess
			hud.shieldMeterSprite.setFlashing(false);
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
		return (core.body.x / 64);
		// return (core.body.x / 64) - 1;
		// return 1.0;
	}
}
