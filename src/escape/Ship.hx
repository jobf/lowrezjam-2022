package escape;

import echo.Body;
import tyke.Graphics;
import concepts.Core;


class Ship extends GamePiece {
	var speed:Float;
	var maxTravelDistance:Int;

	public function new(x:Int, y:Int, bodyW:Int, bodyH:Int, sprite:Sprite, body:Body, debug:DebugCore, speed:Float, maxTravelDistance:Int) {
		super(x, y, bodyW, bodyH, sprite, body, debug);
		this.speed = speed;
		this.maxTravelDistance = maxTravelDistance;
	}

	var isMovingVertical:Bool;
	var isMovingHorizontal:Bool;

	public function moveUp(isDown:Bool) {
		isMovingVertical = isDown;
		if (isMovingVertical) {
			body.velocity.y = -Std.int(maxTravelDistance * speed);
		} else {
			body.velocity.y = 0;
		}
	}

	public function moveRight(isDown:Bool) {
		isMovingHorizontal = isDown;
		if (isMovingHorizontal) {
			body.velocity.x = Std.int(maxTravelDistance * speed);
		} else {
			body.velocity.x = 0;
		}
	}

	public function moveLeft(isDown:Bool) {
		isMovingHorizontal = isDown;
		if (isMovingHorizontal) {
			body.velocity.x = -Std.int(maxTravelDistance * speed);
		} else {
			body.velocity.x = 0;
		}
	}

	public function moveDown(isDown:Bool) {
		isMovingVertical = isDown;
		if (isMovingVertical) {
			body.velocity.y = Std.int(maxTravelDistance * speed);
		} else {
			body.velocity.y = 0;
		}
	}

	public function action(isDown:Bool) {}
}


