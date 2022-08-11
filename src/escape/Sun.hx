package escape;

import tyke.Graphics.ShapeRenderer;
import echo.Body;
import tyke.Graphics.Geometry;
import echo.data.Types.ShapeType;
import core.Actor;

class Sun extends BaseActor{
    public function new(system:ActorSystem){
        final sunDiameter = 512;
        var sizeOffset = -(512/2);
        final startPosition = 2;
        super({
            spriteTileSize: 0,  // not using sprite for the sun
            spriteTileIdStart: 0,    // not using sprite for the sun
            shape: CIRCLE,
            makeCore: actorFactory,
            debugColor: 0xff8033ff,
            collisionType: SUN,
            bodyOptions: {
                shape: {
                    type: ShapeType.CIRCLE,
                    solid: false,
                    radius: Std.int(sunDiameter * 0.5),
                    width: sunDiameter,
                    height: sunDiameter,
                },
                mass: 1,
                x: sizeOffset + startPosition,
                y: 32,
                kinematic: true,
                velocity_x: 1.8
            }
        },
        system);

        core.shape.visible = true;
    }

	// function makeCore(options:ActorOptions, system:ActorSystem):ActorCore{
    //     return {
    //         sprite: system.tiles.makeSprite(0,0,1,0,0,false),
    //         shape: Geometry.CIRCLE,
    //         bodyOptions: options.bodyOptions,
    //         body: new Body()
    //     }
    // }
}

function addLavaFragment(shapeRenderer:ShapeRenderer){
	shapeRenderer.injectIntoProgram("
		// random2 function by Patricio Gonzalez
		vec2 random2(vec2 st){
			st = vec2( dot(st,vec2(127.1,311.7)),
						dot(st,vec2(269.5,183.3)) );
			return -1.0 + 2.0*fract(sin(st)*43758.5453123);
		}
		
		// Value Noise by Inigo Quilez - iq/2013
		// https://www.shadertoy.com/view/lsf3WH
		float noise(vec2 st) {
			vec2 i = floor(st);
			vec2 f = fract(st);
		
			vec2 u = f*f*(3.0-2.0*f);
		
			return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ), 
								dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
						mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ), 
								dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
		}

		vec4 sun(vec4 c)
		{
			// c.r = 0.2;
			// return vec4(c.rgb, c.a);

			vec3 orange = vec3(1., .45, 0.);
			vec3 yellow = vec3(1., 0.15, 0.);
			
			// vec2 uv = (2. * fragCoord - iResolution.xy) / iResolution.y;
			vec2 uv = vTexCoord;
			uv.y += cos(uTime / 100.) * .1 + uTime / 10.;
			uv.x *= sin(uTime * 1. + uv.y * 4.) * .1 + .8;
			uv += noise(uv * 2.25 + uTime / 50.);


			float col = smoothstep(.01,.2, noise(uv * 3.))
				+ smoothstep(.01,.2, noise(uv * 3. + .5))
				+ smoothstep(.01,.3, noise(uv * 2. + .2));

			orange.rg += .3 * sin(uv.y * 4. + uTime / 1.) * sin(uv.x * 5. + uTime / 1.);

			c.rgb = mix(yellow, orange, vec3(smoothstep(0., 1., col)));
			return c;
		}
		");

		shapeRenderer.setColorFormula("
		sun(compose(color, shape, sides))
		");
}