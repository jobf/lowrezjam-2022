package core;

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
	public var shape:Geometry;
	public var debugColor:Color;
	public var spriteTileId:Int;
	public var spriteTileSize:Int;
	public var collisionType:CollisionType;
	public var makeCore:(options:ActorOptions, system:ActorSystem) -> ActorCore;
}

function actorFactory(options:ActorOptions, actorSystem:ActorSystem):ActorCore {
	var x_ = Std.int(options.bodyOptions.x);
	var y_ = Std.int(options.bodyOptions.y);
	return {
		sprite: actorSystem.tiles.makeSprite(
			x_, 
			y_, 
			options.spriteTileSize, 
			options.spriteTileId
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

	var options:ActorOptions;
	var behaviours:Array<CountDown>;

	public function new(options:ActorOptions, system:ActorSystem) {
		this.options = options;
		core = options.makeCore(options, system);
		behaviours = [];

		// move graphics with body
		core.body.on_move = (x, y) -> {
			core.sprite.x = x;
			core.sprite.y = y;
			core.shape.x = x;
			core.shape.y = y;
		}

		// rotate graphics with body
		core.body.on_rotate = r -> {
			core.sprite.rotation = r;
			core.shape.rotation = r;
		}

		// handle collisions with body
		core.body.collider = new Collider(options.collisionType, body -> collideWith(body));

		// register body in world
		system.world.add(core.body);

		#if !debug
		// only show the debug shape for debugging
		core.shape.visible = false;
		#end
	}

	public function update(elapsedSeconds:Float) {
		for (b in behaviours) {
			b.update(elapsedSeconds);
		}
	}

	inline function stop() {
		core.body.velocity.x = 0;
		core.body.velocity.y = 0;
	}

	function collideWith(body:Body) {
		// override me
	}
}
