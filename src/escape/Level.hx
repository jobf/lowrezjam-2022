package escape;

import echo.data.Types.ShapeType;
import peote.view.PeoteView;
import core.Actor;
import echo.Body;
import tyke.Ldtk;
import echo.World;
import tyke.Graphics;
import ldtk.Space;

class Level {
	var spaceMaps:Space;
	var levelTiles:SpriteRenderer;
	var world:World;
	var levelId:Int;

	public var obstacles(default, null):Array<Body>;
	public var actors(default, null):Array<BaseActor> = [];

	public function new(debugRenderer:ShapeRenderer, levelTiles:SpriteRenderer, world:World, peoteView:PeoteView, levelId:Int) {
		#if editinglevels
		// load src version of tracks.ldtk (for hot reload)
		var json = sys.io.File.getContent("../../../assets/ldtk/space/space.ldtk");
		spaceMaps = new Space(json);
		#else
		// load packaged version of tracks.ldtk (for distribution)
		spaceMaps = new Space();
		#end
		obstacles = [];
		this.levelTiles = levelTiles;
		this.world = world;
		this.levelId = levelId;

		var l_Tiles_16 = spaceMaps.levels[levelId].l_Tiles_16;
		var l_Tiles_16_RenderSize = 16;
		
		var obstacleSystem:ActorSystem = {
			world: world,
			tiles: levelTiles,
			shapes: debugRenderer,
			peoteView: peoteView
		}

		LevelLoader.renderLayer(l_Tiles_16, (stack, cx, cy) -> {
			for (tileData in stack) {
				var tileX = cx * l_Tiles_16_RenderSize;
				var tileY = cy * l_Tiles_16_RenderSize;
				var config = Configuration.obstacles[tileData.tileId];
				if (config == null) {
					trace('!!! no config for tile Id ${tileData.tileId}');
				} else {
					var obstacleOptions:ActorOptions = {
						spriteTileSize: l_Tiles_16_RenderSize,
						spriteTileId: tileData.tileId,
						shape: config.shape,
						makeCore: actorFactory,
						debugColor: 0x44008880,
						collisionType: ROCK,
						bodyOptions: {
							shape: {
								type: config.shape == CIRCLE ? ShapeType.CIRCLE : ShapeType.RECT,
								solid: false,
								radius: Std.int(config.hitboxWidth * 0.5),
								width: config.hitboxWidth,
								height: config.hitboxHeight,
							},
							mass: 1,
							x: tileX,
							y: tileY,
							kinematic: true
						}
					};

					var obstacle = new Obstacle(obstacleOptions, obstacleSystem);
                    actors.push(obstacle);
					obstacles.push(obstacle.core.body);
					obstacle.core.body.velocity.x = config.velocityX;
					obstacle.core.body.velocity.y = 0;
				}
			}
		});
	}
}
