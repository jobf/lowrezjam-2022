package concepts;

import tyke.Loop;
import echo.Body;
import peote.view.Color;
import tyke.Graphics;

@:structInit
class DebugCore {
	public var renderer:ShapeRenderer;
	public var color:Color;
}

@:structInit
class Cursor {
	public var sprite:Sprite;
	public var shape:Shape;
	public var body:Body;
	public var gamePieceUnder:GamePiece = null;

	var onClick:GamePiece->Void;

	public function init() {
		body.on_move = (x, y) -> {
			sprite.setPosition(x, y);
			shape.setPosition(x, y);
		}
	}

	public function click() {
		if(gamePieceUnder != null){
			trace('click');
			onClick(gamePieceUnder);
		}
	}

}

class GamePiece {
	public var sprite(default, null):Sprite;
	public var body(default, null):Body;

	var shape:Shape;
	var behaviours:Array<CountDown>;
	var debug:DebugCore;

	static var debugShapes:ShapeRenderer;
	static var debugColor:Color;

	public function new(x:Int, y:Int, bodyW:Int, bodyH:Int, sprite:Sprite, body:Body, debug:DebugCore) {
		this.sprite = sprite;
		this.body = body;
		this.debug = debug;
		#if !debug
		this.debug.color.alpha = 0;
		#end

		shape = this.debug.renderer.makeShape(x, y, bodyW, bodyH, RECT, this.debug.color);

		this.body.on_move = on_move;
		this.body.on_rotate = on_rotate;
		this.body.gamepiece = this;

		behaviours = [];
	}

	inline function on_move(x:Float, y:Float) {
		var x_ = Std.int(x);
		var y_ = Std.int(y);
		sprite.setPosition(x_, y_);
		shape.setPosition(x_, y_);
		// sprite.z = Std.int(y_);
		// trace('on move $x $x_ $y $y_ ${body.x} ${body.y}');
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

	public function click(){}
}
