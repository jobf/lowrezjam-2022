package escape;

import tyke.Stage;
import escape.Obstacle;
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
	var obstacleSystems:Array<ActorSystem> = [];
	final solarFlareTileId:Int = 9;
	final solarFlareFramesPerSecond:Int = 12;
	var solarFlareFrames:Array<Int> =[for(i in 56...79) i];

	public var obstacles(default, null):Array<Body>;
	public var actors(default, null):Array<Obstacle> = [];
	public var finishLine(default, null):BaseActor;
	public var levelStyle(default, null):Enum_LevelStyle;

	public function new(levelId:Int) {
		#if editinglevels
		// load src version of tracks.ldtk (for hot reload)
		var json = sys.io.File.getContent("../../../assets/ldtk/space/space.ldtk");
		spaceMaps = new Space(json);
		#elseif speedrun
		// load src version of tracks.ldtk (for hot reload)
		var json = sys.io.File.getContent("../../../assets/ldtk/space/space-mini-levels.ldtk");
		spaceMaps = new Space(json);
		#else
		// load packaged version of tracks.ldtk (for distribution)
		spaceMaps = new Space();
		#end
		obstacles = [];
		this.levelId = levelId;

		levelStyle = spaceMaps.levels[levelId].f_LevelStyle;
		trace('level style $levelStyle');
	}

	public function initLevel(debugRenderer:ShapeRenderer, levelTiles:SpriteRenderer, world:World, peoteView:PeoteView, tileRenderers:Array<SpriteRenderer>, soundEffects:SoundEffects) {
		this.levelTiles = levelTiles;
		this.world = world;
		var l_Tiles_16 = spaceMaps.levels[levelId].l_Tiles_16;
		var l_Tiles_16_RenderSize = 16;
		var l_Tiles_16_GridSize = 4;

		obstacleSystems = [
			{
				world: world,
				tiles: tileRenderers[0],
				shapes: debugRenderer,
				peoteView: peoteView,
				soundEffects: soundEffects
			},
			{
				world: world,
				tiles: tileRenderers[1],
				shapes: debugRenderer,
				peoteView: peoteView,
				soundEffects: soundEffects
			},
			{
				world: world,
				tiles: tileRenderers[2],
				shapes: debugRenderer,
				peoteView: peoteView,
				soundEffects: soundEffects
			},

		];

		solarFlareFramesPadded = [79,79,79,79].concat(solarFlareFrames);

		// set up Obstacles ( rocks, targets, flares etc . . . )
		LevelLoader.renderLayer(spaceMaps.levels[levelId].l_Tiles_16, (stack, cx, cy) -> {
			for (tileData in stack) {
				initObstacle(tileData, cx, cy, l_Tiles_16_GridSize, l_Tiles_16_RenderSize, obstacleSystems[1]);
			}
		});

		LevelLoader.renderLayer(spaceMaps.levels[levelId].l_Tiles_16_Slow, (stack, cx, cy) -> {
			for (tileData in stack) {
				initObstacle(tileData, cx, cy, l_Tiles_16_GridSize, l_Tiles_16_RenderSize, obstacleSystems[0]);
			}
		});

		LevelLoader.renderLayer(spaceMaps.levels[levelId].l_Tiles_16_Fast, (stack, cx, cy) -> {
			for (tileData in stack) {
				initObstacle(tileData, cx, cy, l_Tiles_16_GridSize, l_Tiles_16_RenderSize, obstacleSystems[2]);
			}
		});

		var finishLines = spaceMaps.levels[levelId].l_Zones.all_FinishLine;
		for (f in finishLines) {
			var tileX = f.cx * l_Tiles_16_GridSize;

			finishLine = new BaseActor({
				spriteTileSize: 0,
				spriteTileIdStart: 0,
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
					velocity_x: Configuration.baseVelocityX
				}
			}, obstacleSystems[0]);

			trace('initiliazed finish line at $tileX');
		}
	}

	public function countSolarTargets():Int {
		var targets = obstacles.filter(body -> body.collider.type == TARGET);
		return targets.length;
	}

	function initObstacle(tileData:{tileId:Int, flipBits:Int}, cx:Int, cy:Int, l_Tiles_16_GridSize:Int, l_Tiles_16_RenderSize:Int, obstacleSystem:ActorSystem) {
				
		var tileId = tileData.tileId >= solarFlareFrames[0] 
			? solarFlareTileId 
			: tileData.tileId;

		var config = Configuration.obstacles[tileId];
		if (config == null) {
			trace('!!! no config for tile Id ${tileData.tileId}');
		} else {
			if (tileData.tileId >= solarFlareTileId) {
				var tileX = cx * l_Tiles_16_GridSize;
				var tileY = cy * l_Tiles_16_GridSize;
				// var config = Configuration.obstacles[solarFlareTileId];
				// var tileId:Int = Std.int(entity.f_StartTile_infos.x / 16) + 56;
				// trace('entity.f_StartTile_infos ${entity.f_StartTile_infos} tileId $tileId');
				var obstacleOptions:ActorOptions = {
					spriteTileSize: l_Tiles_16_RenderSize,
					spriteTileIdStart: tileData.tileId,
					shape: config.shape,
					makeCore: actorFactory,
					debugColor: 0x44008880,
					collisionType: FLARE,
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

				var obstacle = new Flare(obstacleOptions, obstacleSystems[1], config, solarFlareFramesPadded, solarFlareFramesPerSecond);

				actors.push(obstacle);
				obstacles.push(obstacle.core.body);
				obstacle.core.body.velocity.x = Configuration.baseVelocityX * config.velocityModX;
				obstacle.core.body.velocity.y = 0;
			} else {
				var tileX = cx * l_Tiles_16_GridSize;
				var tileY = cy * l_Tiles_16_GridSize;
				var obstacleOptions:ActorOptions = {
					spriteTileSize: l_Tiles_16_RenderSize,
					spriteTileIdStart: tileData.tileId,
					spriteTileIdEnd: config.spriteTileIdEnd,
					shape: config.shape,
					makeCore: actorFactory,
					debugColor: 0x44008880,
					collisionType: tileData.tileId == 8 ? TARGET : ROCK,
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
				obstacle.core.body.velocity.x = Configuration.baseVelocityX * config.velocityModX;
				obstacle.core.body.velocity.y = 0;

				switch tileData.flipBits {
					case 1:
						obstacle.core.sprite.flipX(true);
					case 2:
						obstacle.core.sprite.flipY(true);
					case 3:
						obstacle.core.sprite.flipX(true);
						obstacle.core.sprite.flipY(true);
					case _:
						return;
				}
			}
		}
	}

	var solarFlareFramesPadded:Array<Int>;
}
