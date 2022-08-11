package core;

import echo.Body;

class Collider {
	var onCollide:(collidingBody:Body, emitter:Emitter) -> Void;

	public var type:CollisionType;
	public var isActive:Bool = true;

	public function new(type:CollisionType, onCollide:(collidingBody:Body, emitter:Emitter) -> Void) {
		this.onCollide = onCollide;
		this.type = type;
	}

	public function collideWith(collidingBody:Body, emitter:Emitter) {
		if (isActive) {
			onCollide(collidingBody, emitter);
		}
	}
}

enum CollisionType {
	UNDEFINED;
	VEHICLE;
	ROCK;
	FLARE;
	SUN;
	PROJECTILE;
	TARGET;
	FINISH;
	STOPPER;
}
