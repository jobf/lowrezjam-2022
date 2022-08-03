package concepts;

import lime.ui.MouseButton;
import Main;
import concepts.Core;
import tyke.Loop;
import echo.Body;
import tyke.Graphics;
import tyke.Glyph;
import peote.view.Color;

class HotFarmer extends FullScene {

	var pieces:Array<Plant>;

	override function create() {
		super.create();
		var numTilesWide = 8;
		var isIndividualFrameBuffer = true;

		var debugColor = Color.MAGENTA;
		debugColor.alpha = 100;

		var worldWidth = 128;
		var worldHeight = 128;
		world.width = worldWidth;
		world.height = worldHeight;
		pieces = [];
		var tileSize = 14;
		var numRows = 16;
		var numColumns = 16;
		var gapY = 2;
		var gapX = 18;
		for (r in 0...numRows) {
			for (c in 0...numColumns) {
				var x = (tileSize + gapX) * r;
				var y = (tileSize + gapY) * c;
				var speedOption = randomInt(3);
				var speed = switch speedOption {
					case 1: 0.2;
					case 2: 0.4;
					case 3: 0.6;
					case _: 0.8;
				};
				var width = 3;
				var height = 7;
				var tileId = 11;

				pieces.push(new Plant(x, y, width, height, tiles14px.makeSprite(x, y, tileSize, tileId), world.add(new Body({
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
				}, speed));
			}
		}

		var witherPause = 0.7;

		behaviours = [
			new CountDown(witherPause, () -> {
				for (piece in pieces) {
					piece.cook();
				}
			}, true)
		];

		var cursorX = 0;
		var cursorY = 0;
		cursor = {
			sprite: tiles18px.makeSprite(cursorX, cursorY, 18, 0),
			shape: debugShapes.makeShape(cursorX, cursorY, 18, 18, CIRCLE, 0x00223320),
			body: new Body({
				shape: {
					solid: false,
					radius: 9,
					width: 10,
					height: 10,
				},
				x: cursorX,
				y: cursorY,
				kinematic: true
			}),
			onClick: gamePieceUnder -> {
				if (gamePieceUnder != null) {
					gamePieceUnder.click();
				}
				else{
					trace('bodyUnder.gamepiece is null!');
				}
			}
		}
		cursor.init();

		plantBodies = pieces.map(plant -> plant.body);
		world.listen(cursor.body, plantBodies, {
			// separate: separate,
			enter: (cursorBody, plantBody, array) -> {
				cursor.gamePieceUnder = plantBody.gamepiece;
				trace('plant over ${cursor.gamePieceUnder}');
			},
			// stay: stay,
			exit: (cursorBody, plantBody) -> {
				cursor.gamePieceUnder = null;
				trace('plant out ${cursor.gamePieceUnder}');
			},
			// condition: condition,
			// percent_correction: percent_correction,
			// correction_threshold: correction_threshold
		});
	}

	var cursor:Cursor;

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);

		for (p in pieces) {
			p.update(elapsedSeconds);
		}
	}

	override function onMouseMove(x:Float, y:Float) {
		super.onMouseMove(x, y);
		// cursor.body.set_position(x, y);
		// var i = app.core.display.localX(x);
		// var i = app.core.display.localX(y);

		@:privateAccess
		cursor.body.x = app.core.display.localX(x) - stage.globalFrameBuffer.display.xOffset;
		@:privateAccess
		cursor.body.y = app.core.display.localX(y) - stage.globalFrameBuffer.display.yOffset;
		// trace('cursor.body.x ${cursor.body.x}');
		// @:privateAccess
		// cursor.body.x = stage.globalFrameBuffer.display.localX(x) ;// - app.core.display.xOffset;
		// @:privateAccess
		// cursor.body.y = stage.globalFrameBuffer.display.localX(y);
	}

	override function onMouseDown(x:Float, y:Float, button:MouseButton) {
		super.onMouseDown(x, y, button);
		cursor.click();
	}

	var scrolled = {
		up: 0,
		left: 0,
		right: 0,
		down: 0
	};

	var plantBodies:Array<Body>;
}

class Plant extends GamePiece {
	public function new(x:Int, y:Int, bodyW:Int, bodyH:Int, sprite:Sprite, body:Body, debug:DebugCore, speed:Float) {
		super(x, y, bodyW, bodyH, sprite, body, debug);
		this.speed = speed;
		this.body.gamepiece = this;
	}

	public var speed(default, null):Float;

	var cookingIncrement = 7;
	var water:Float = 100;
	var wateredAmount:Int = 4;
	var numTiles:Int = 4;

	public function cook() {
		water -= cookingIncrement * speed;
		// trace('cookedAmount $cookedAmount');
		wateredAmount = Math.floor((water / 100) * numTiles);
		if (wateredAmount > 4) {
			wateredAmount = 4;
		}
		if (wateredAmount < 0) {
			wateredAmount = 0;
		}

		final minTile = 8;
		var tile = Std.int(minTile + wateredAmount);
		// trace('tile $tile water $water wateredAmount $wateredAmount');
		sprite.tile = tile;
	}

	override function click(){
		super.click();
		trace('water');
		water = 100;
		cook();
	}
}
