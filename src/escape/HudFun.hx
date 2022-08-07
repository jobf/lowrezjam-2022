package escape;

import peote.view.Color;
import echo.Body;
import tyke.Loop;
import core.Actor;
import escape.Ship;
import core.Collider;
import tyke.Graphics;

class Hud {
	var weapon:Weapon;
	var tiles:SpriteRenderer;
	var ledBodies:Array<Body> = [];
	var projectileLeds:Array<Led> = [];
	var shieldMeterSprite:Sprite;
	var ledSystem:ActorSystem;
	var behaviours:Array<CountDown> = [];
	var y:Int;
	var x:Int;

	final width = 14;
	final height = 14;

	function makeLed(x_:Int, c:Color=0xff0088a0){
		var l = new Led({
			spriteTileSize: width,
			spriteTileIdStart: 56,
			bodyOptions: {
				x: x_,
				y: y,
				shape: {
					width: width,
					height: height,
					solid: true
				},
				kinematic: true,
				// m
			},
			debugColor: c,
		}, this.ledSystem);
		ledBodies.push(l.core.body);

		return l;
	}

	function increaseShots(plusX:Int=0){
		// trace('increase shots');
		var l = makeLed(x + 64 + plusX + 7);
		projectileLeds.push(l);
		l.core.body.velocity.x = chamberSpeed;
	}

	var stopper:Led;
	public function new(ledSystem:ActorSystem, weapon:Weapon) {
		this.weapon = weapon;
		this.ledSystem = ledSystem;
		x = 64 + 14;
		y = 64 - 4;
		stopper = makeLed(x - 14 - 7, 0xffff88a0);
		stopper.core.body.collider.type = STOPPER;
		var tileIndex = 56;
		var isFull = weapon.totalShots == weapon.shotsAvailable;
		this.ledSystem.world.listen(ledBodies, {
			// separate: true,
			enter: (body1, body2, array) -> {
				body1.velocity.x = 0;
				body2.velocity.x = 0;
			},
		});
		for(i in 0...weapon.shotsAvailable){
			increaseShots(i * width);
		}
		weapon.onShoot = () -> useLed();
		weapon.onShotsIncreased = () -> {
			increaseShots();
		};
	}

	var firstLedX:Float;
	var chamberSpeed:Float = -500;
	function useLed() {
		if(projectileLeds.length > 0){
			var ledAtStart = projectileLeds[0];
			ledAtStart.core.body.velocity.y = 600;
			projectileLeds.remove(ledAtStart);
		}
		for (led in projectileLeds) {
			led.core.body.velocity.x = chamberSpeed;
		}
	}

	function roundToNearest(numToRound:Float, numToRoundTo:Float) {
		numToRoundTo = 1 / (numToRoundTo);
	
		return Math.round(numToRound * numToRoundTo) / numToRoundTo;
	}

	function round14(x:Float):Int
	{
		return (x % 14) >= 7 ? Std.int((x / 14) * 14 + 14) : Std.int((x / 14) * 14);
	}
	function reloadLeds() {
		var numDisplayed = projectileLeds.length;
		if (weapon.shotsAvailable > numDisplayed) {
			trace('reload');
			var finalLedPosition = x + ((numDisplayed-1) * width);
			// trace('inalLedPosition $finalLedPosition');
			var last = projectileLeds[projectileLeds.length - 1];
			finalLedPosition += width;
			var newLed = new Led({
				spriteTileSize: width,
				spriteTileIdStart: 56,
				bodyOptions: {
					x: finalLedPosition,
					y: y,
					shape: {
						width: 14,
						height: 14,
					},
					kinematic: true,
					velocity_x: last.core.body.velocity.x
				}
			}, this.ledSystem);
			projectileLeds.push(newLed);
		}
	}

	var meterTileRange = 6;

	public function update(elapsedSeconds:Float) {
		// for (b in behaviours) {
		// 	b.update(elapsedSeconds);
		// }
		// if (projectileLeds[0].core.body.x > firstLedX) {
		// 	// trace('move leds');
			for (i => l in projectileLeds) {
				if(l.core.body.velocity.x ==0){
					l.core.body.x = i * width + x;
				}
			}
		// } else {
		// 	// trace('stop leds');
		// 	for (l in projectileLeds) {
		// 		l.core.body.velocity.x = 0;
		// 	}
		// }
	}
}

class Led extends BaseActor {
	public function new(options:ActorOptions, system:ActorSystem) {
		super(options, system);
	}

	public var isLit(default, null):Bool = true;

	public function enable() {
		isLit = true;
		show();
	}

	public function disable() {
		isLit = false;
		hide();
	}

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		// core.body.velocity.y = 0;
	}
}
