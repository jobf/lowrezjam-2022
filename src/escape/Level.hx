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
	public var actors(default, null):Array<Obstacle> = [];
	public var finishLine(default, null):BaseActor;

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

		var l_Style = spaceMaps.levels[levelId].f_LevelStyle;
		trace('level style $l_Style');

		var l_Tiles_16 = spaceMaps.levels[levelId].l_Tiles_16;
		var l_Tiles_16_RenderSize = 16;
		var l_Tiles_16_GridSize = 4;

		var obstacleSystem:ActorSystem = {
			world: world,
			tiles: levelTiles,
			shapes: debugRenderer,
			peoteView: peoteView
		}

		LevelLoader.renderLayer(l_Tiles_16, (stack, cx, cy) -> {
			for (tileData in stack) {
				var tileX = cx * l_Tiles_16_GridSize;
				var tileY = cy * l_Tiles_16_GridSize;
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

					var obstacle = new Obstacle(obstacleOptions, obstacleSystem, config);
					actors.push(obstacle);
					obstacles.push(obstacle.core.body);
					obstacle.core.body.velocity.x = config.velocityX;
					obstacle.core.body.velocity.y = 0;
				}
			}
		});

		var finishLines = spaceMaps.levels[levelId].l_Zones.all_FinishLine;
		for (f in finishLines) {
			var tileX = f.cx * l_Tiles_16_GridSize;
			
			finishLine = new BaseActor({
				spriteTileSize: 0,
				spriteTileId: 0,
				shape: RECT,
				makeCore: actorFactory,
				debugColor: 0x992060a0,
				collisionType: FINISH,
				bodyOptions: {
					shape: {
						type: RECT,
						solid: false,
						width: 32,
						height: 80,
					},
					mass: 1,
					x: tileX,
					y: 40,
					kinematic: true,
					velocity_x: Configuration.finishLineVelocity
				}
			}, obstacleSystem);

			trace('initiliazed finish line at $tileX');
		}
	}
}
