package concepts;

import concepts.Core;
import concepts.Core.GamePiece;
import Main;
import tyke.Loop.CountDown;
import echo.Body;
import tyke.Graphics;
import tyke.Glyph;
import peote.view.Color;

class SunBurn extends FullScene {
	var people:Array<Person>;

	override function create() {
		super.create();
		var numTilesWide = 8;
		var isIndividualFrameBuffer = true;
		tiles14px = stage.createSpriteRendererFor("assets/sprites/13-px-tiles.png", numTilesWide, isIndividualFrameBuffer);
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

		var debugColor = Color.CYAN;
		debugColor.alpha = 0;
		
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
				new Person(x, y, width, height, tiles14px.makeSprite(x, y, tileSize, tileId), world.add(new Body({
					shape: {
						solid: false,
						// radius: radius,
						width: width,
						height: height,
					},
					x: x,
					y: y,
					kinematic: true
				})), {
					renderer: debugShapes,
					color: debugColor
				}, speed);
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

class Person extends GamePiece{
	public function new(x:Int, y:Int, bodyW:Int, bodyH:Int, sprite:Sprite, body:Body, debug:DebugCore, speed:Float){
		super(x, y, bodyW, bodyH, sprite, body, debug);
		this.speed = speed;
	}

	public var speed(default, null):Float;

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
