package concepts;

import Main;
import tyke.Loop.CountDown;
import echo.Body;
import tyke.Graphics;
import tyke.Glyph;
import peote.view.Color;

class SunBurn extends FullScene {
	var tiles13px:SpriteRenderer;
	var debugShapes:ShapeRenderer;
	var people:Array<Person>;

	override function create() {
		super.create();
		var numTilesWide = 8;
		var isIndividualFrameBuffer = true;
		tiles13px = stage.createSpriteRendererFor("assets/sprites/13-px-tiles.png", numTilesWide, isIndividualFrameBuffer);
		debugShapes = stage.createShapeRenderLayer("debugShapes");

		// var numPeople = 10;
		var numPeople = 100;

		app.window.onKeyDown.add((code, modifier) -> switch code {
			case W: scrollUp();
			case A: scrollLeft();
			case S: scrollDown();
			case D: scrollRight();
			case _: return;
		});

		Person.initDebug(debugShapes);

		var worldWidth = 128;
		var worldHeight = 128;
		world.width = worldWidth;
		world.height = worldHeight;
		people = [
			for (i in 0...numPeople) {
				var x = randomInt(worldWidth);
				var y = randomInt(worldHeight);
				var speedOption = randomInt(3);
				var speed = switch speedOption {
					case 1: -0.02;
					case 2: -0.15;
					case 3: -0.50;
					case _: -0.25;
				};
				var width = 3;
				var height = 7;
				var tileSize = 14;
				var tileId = 3;
				new Person(x, y, width, height, tiles13px.makeSprite(x, y, tileSize, tileId), world.add(new Body({
					shape: {
						solid: false,
						// radius: radius,
						width: width,
						height: height,
					},
					x: x,
					y: y,
					kinematic: true
				})), speed);
			}
		];

		var travelPause = 0.7;

		var travelOnComplete = (person:Person) -> {
			var directionX = randomInt(3) - 2;
			var directionY = directionX == 0 ? randomInt(3) - 2 : 0.0;
			final travelSpeed = 20.0;
			person.body.velocity.x = (directionX * travelSpeed) * person.speed;
			person.body.velocity.y = (directionY * travelSpeed) * person.speed;
		}

		var stopTravelOnComplete = (person:Person) -> {
			person.body.velocity.x = 0.0;
			person.body.velocity.y = 0.0;
		}

		behaviours = [
			new CountDown(travelPause, () -> {
				for (person in people) {
					if (randomChance()) {
						travelOnComplete(person);
					} else {
						stopTravelOnComplete(person);
					}
					person.cook();
				}
			}, true)
		];
	}

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);

		for (p in people) {
			p.update(elapsedSeconds);
		}
	}

	var scrolled = {
		up: 0,
		left: 0,
		right: 0,
		down: 0
	};

	var scrollIncrement = 7;

	inline function scrollLeft() {
		@:privateAccess
		stage.globalFrameBuffer.display.xOffset += scrollIncrement;
	}

	inline function scrollRight() {
		@:privateAccess
		stage.globalFrameBuffer.display.xOffset -= scrollIncrement;
	}

	inline function scrollUp() {
		@:privateAccess
		stage.globalFrameBuffer.display.yOffset += scrollIncrement;
	}

	inline function scrollDown() {
		@:privateAccess
		stage.globalFrameBuffer.display.yOffset -= scrollIncrement;
	}
}

class Person {
	public var speed(default, null):Float;
	public var sprite(default, null):Sprite;
	public var body(default, null):Body;

	var shape:Shape;
	var behaviours:Array<CountDown> = [];

	static var debugShapes:ShapeRenderer;

	public static function initDebug(shapes:ShapeRenderer) {
		debugShapes = shapes;
	}

	public function new(x:Int, y:Int, w:Int, h:Int, sprite:Sprite, body:Body, speed:Float) {
		this.sprite = sprite;
		this.body = body;
		var color = Color.CYAN;
		// color.alpha = 200;
		color.alpha = 0;
		shape = debugShapes.makeShape(x, y, w, h, RECT, color);
		this.body.on_move = on_move;
		this.body.on_rotate = on_rotate;
		this.speed = speed;
	}

	inline function on_move(x:Float, y:Float) {
		var x_ = Std.int(x);
		var y_ = Std.int(y);
		sprite.setPosition(x_, y_);
		shape.setPosition(x_, y_);
		// sprite.z = Std.int(y_);
	}

	inline function on_rotate(r:Float) {
		sprite.rotation = r;
		shape.rotation = r;
	}

	public function update(elapsedSeconds:Float) {
		for (b in behaviours) {
			b.update(elapsedSeconds);
		}
	}

	var cookingIncrement = 1 / 6;
	var cookedAmount:Float = 0;

	public function cook() {
		cookedAmount += (cookingIncrement * (1 - speed));
		// trace('cookedAmount $cookedAmount');
		var cookedTileId = Math.floor(cookedAmount);
		if (cookedTileId > 7) {
			cookedTileId = 7;
		}
		if (cookedTileId > sprite.tile) {
			sprite.tile = cookedTileId;
		}
	}
}
