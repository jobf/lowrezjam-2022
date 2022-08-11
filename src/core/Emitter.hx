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

	var particles:Array<Particle> = [];

	public function emit(x:Float, y:Float, x_vel:Float, y_vel:Float, tileId:Int) {
		var maxParticles:Int = 20;
		if (particles.length < maxParticles) {
			var sprite = tiles.makeSprite(Std.int(x), Std.int(y), 16, tileId);
			var p:Particle = {
				sprite: sprite,
				body: new Body({
					shape: {
						solid: false,
						width: 1,
						height: 1,
					},
					kinematic: false,
					mass: 1,
					x: x,
					y: y,
					velocity_x: x_vel,
					velocity_y: y_vel,
					rotational_velocity: randomFloat(100, 300),
				})
			}
			p.body.data.sprite = sprite;
			p.body.on_move = (x, y) -> {
				//  sprite.setPosition(,y * 10);?
				sprite.x = Std.int(x); // * 10);
				sprite.y = Std.int(y); // * 10);
				if (x < -32 || x > 72) {
					p.isRecycle = true;
				}
				if (y < -32 || y > 72) {
					p.isRecycle = true;
				}

				//  trace('move $x $y ${sprite.x} ${sprite.y}');
			};
			p.body.on_rotate = r -> sprite.rotation = r;
			world.add(p.body);
			particles.push(p);
		} else {
			for(p in particles){
				if(p.isRecycle){
					p.isRecycle = false;
					p.body.x = x;
					p.body.y = y;
					p.body.velocity.x = x_vel;
					p.body.velocity.y = y_vel;
					p.body.rotational_velocity = randomFloat(100, 300);
					break;
				}
			}
			// var readyParticles = particles.filter(particle -> particle.isRecycle);
			// if (readyParticles.length >= 0) {
			// 	var p = readyParticles[0];
			// 	p.body.x = x;
			// 	p.body.y = y;
			// 	p.body.velocity.x = x_vel;
			// 	p.body.velocity.y = y_vel;
			// 	p.body.rotational_velocity = randomFloat(100, 300);
			// }
		}
	}

	var world:World;

	var tiles:SpriteRenderer;
}

@:structInit
class Particle {
	public var sprite:Sprite;
	public var body:Body;
	public var isRecycle:Bool = false;
}
