package core;

import escape.SoundEffects;
import core.Collider;
import peote.view.PeoteView;
import tyke.Graphics;
import tyke.Loop;
import peote.view.Color;
import echo.data.Options;
import echo.Body;
import echo.World;

@:structInit
class ActorSystem {
	public var tiles:SpriteRenderer;
	public var shapes:ShapeRenderer;
	public var world:World;
	public var peoteView:PeoteView;
	public var soundEffects:SoundEffects;
}

@:structInit
class ActorCore {
	public var sprite:Sprite;
	public var shape:Shape;
	public var body:Body;
	public var bodyOptions:BodyOptions;
}

@:structInit
class ActorOptions {
	public var bodyOptions:BodyOptions;
	public var shape:Geometry = RECT;
	public var debugColor:Color = 0xff00ddff;
	public var spriteTileIdStart:Int;
	public var spriteTileIdEnd:Int = -1;
	public var spriteTileSize:Int;
	public var collisionType:CollisionType = CollisionType.UNDEFINED;
	public var makeCore:(options:ActorOptions, system:ActorSystem) -> ActorCore = actorFactory;
	public var bodyRegisterInWorldsIsAutomatic:Bool = true;
}

function actorFactory(options:ActorOptions, actorSystem:ActorSystem):ActorCore {
	var x_ = Std.int(options.bodyOptions.x);
	var y_ = Std.int(options.bodyOptions.y);
	return {
		sprite: actorSystem.tiles.makeSprite(
			x_, 
			y_, 
			options.spriteTileSize, 
			options.spriteTileIdStart
		),
		shape: actorSystem.shapes.makeShape(
			x_, 
			y_, 
			Std.int(options.bodyOptions.shape.width), 
			Std.int(options.bodyOptions.shape.height), 
			options.shape,
			options.debugColor
		),
		bodyOptions: options.bodyOptions,
		body: new Body(options.bodyOptions)
	}
}

class BaseActor {
	public var core(default, null):ActorCore;
	public var isDangerous(default, null):Bool = false;
	var options:ActorOptions;
	var behaviours:Array<CountDown>;
	
	var isDestructible(default, set):Bool = true;
    function set_isDestructible(value:Bool):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }
    

	public function new(options:ActorOptions, system:ActorSystem) {
		this.options = options;
		this.system = system;
		core = options.makeCore(options, system);
		behaviours = [];

		// move graphics with body
		core.body.on_move = onMove;

		// core.body.on_move = (x, y) -> {
		// 	core.sprite.x = x;
		// 	core.sprite.y = y;
		// 	core.shape.x = x;
		// 	core.shape.y = y;
		// }

		// rotate graphics with body
		core.body.on_rotate = r -> {
			core.sprite.rotation = r;
			core.shape.rotation = r;
		}

		// handle collisions with body
		core.body.collider = new Collider(options.collisionType, (body, emitter) -> collideWith(body, emitter));

		if(options.bodyRegisterInWorldsIsAutomatic){
			// register body in world
			system.world.add(core.body);
		}
		
		setAlive(true);
		
		#if !debug
		// only show the debug shape for debugging
		core.shape.visible = false;
		#end
	}


	public function setAlive(isAlive:Bool){
		this.isAlive = isAlive;
		if(core.body != null && core.body.data != null){

			core.body.data.isAlive = isAlive;
			core.body.active = isAlive;
		}
	}

	public function update(elapsedSeconds:Float) {
		//&& core.body.data.isAlive
		if(isAlive ){
			for (b in behaviours) {
				b.update(elapsedSeconds);
			}
		}
	}

	inline function stop() {
		core.body.velocity.x = 0;
		core.body.velocity.y = 0;
	}

	function collideWith(body:Body, emitter:Emitter) {
		// override me
	}

	public function kill(){
		core.shape.visible = false;
		setAlive(false);
		
		if(options.spriteTileIdEnd >= 0){
			core.sprite.tile = options.spriteTileIdEnd;
		}
		else{
			// stop physics
			// core.body.remove();
			// core.body.dispose();

			hide();
		}
	}

	public function hide(){
		// make sprite invisible (todo - properly remove from buffer?)
		// core.shape.color.a =0;
		core.sprite.alphaStart = 0;// = false;
		core.sprite.alphaEnd = 0;
		core.sprite.alpha = 0;
	}


	public function show(){
		// make sprite invisible (todo - properly remove from buffer?)
		// core.shape.color.a =0;
		core.sprite.alphaStart =1.0;// = false;
		core.sprite.alphaEnd = 1.0;
		core.sprite.alpha = 1.0;
	}

	public var isAlive:Bool = true;

	var system:ActorSystem;

	function onMove(x:Float, y:Float){
		core.sprite.x = x;
		core.sprite.y = y;
		core.shape.x = x;
		core.shape.y = y;
	}
}
