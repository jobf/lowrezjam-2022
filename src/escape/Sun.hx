package escape;

import echo.Body;
import tyke.Graphics.Geometry;
import echo.data.Types.ShapeType;
import core.Actor;

class Sun extends BaseActor{
    public function new(system:ActorSystem){
        final sunDiameter = 512;
        super({
            spriteTileSize: 0,  // not using sprite for the sun
            spriteTileId: 0,    // not using sprite for the sun
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
                x: -184,
                y: 32,
                kinematic: true,
                velocity_x: 1
            }
        },
        system);
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