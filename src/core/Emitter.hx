package core;

import tyke.Glyph.randomFloat;
import echo.Body;
import tyke.Graphics;
import echo.World;

class Emitter {
	public function new(tiles:SpriteRenderer) {
		this.tiles = tiles;
		world = new World({
			width: 70,
			height: 70,
			// x: x,
			// y: y,
			// gravity_x: gravity_x,
			// gravity_y: gravity_y,
			// members: members,
			// listeners: listeners,
			gravity_y: 0,
			iterations: 2
		});
	}

	public function update(elapsedSeconds:Float) {
		world.step(elapsedSeconds);
	}

	var sprites:Array<Sprite> = [];

	public function emit(x:Float, y:Float, x_vel:Float, y_vel:Float, tileId:Int) {
		var sprite = tiles.makeSprite(Std.int(x), Std.int(y), 16, tileId);
		var body = new Body({
			shape: {
				// type: type,
				solid: false,
				// radius: radius,
				width: 1,
				height: 1,
				// sides: sides,
				// vertices: vertices,
				// rotation: rotation,
				// scale_x: scale_x,
				// scale_y: scale_y,
				// offset_x: offset_x,
				// offset_y: offset_y
			},
			// shapes: shapes,
			// shape_instance: shape_instance,
			// shape_instances: shape_instances,
			// material: material,
			kinematic: false,
			mass: 1,
			x: x,
			y: y,
			// rotation: rotation,
			// scale_x: scale_x,
			// scale_y: scale_y,
			// elasticity: elasticity,
			velocity_x: x_vel,
			velocity_y: y_vel,
			rotational_velocity: randomFloat(100,300),
			// max_velocity_x: max_velocity_x,
			// max_velocity_y: max_velocity_y,
			// max_velocity_length: max_velocity_length,
			// max_rotational_velocity: max_rotational_velocity,
			// drag_x: drag_x,
			// drag_y: drag_y,
			// drag_length: drag_length,
			// rotational_drag: rotational_drag,
			// gravity_scale: gravity_scale
		});
		sprites.push(sprite);
		body.data.sprite = sprite;
		body.on_move = (x, y) -> {
			//  sprite.setPosition(,y * 10);?
			sprite.x = Std.int(x); // * 10);
			sprite.y = Std.int(y); // * 10);
			//  trace('move $x $y ${sprite.x} ${sprite.y}');
		};

		body.on_rotate = r -> sprite.rotation = r;
		world.add(body);
	}

	var world:World;

	var tiles:SpriteRenderer;
}
