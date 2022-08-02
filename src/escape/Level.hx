package escape;

import echo.data.Types.ShapeType;
import echo.Body;
import tyke.Ldtk;
import concepts.Core;
import echo.World;
import tyke.Graphics;
import ldtk.Space;

class Level {
	var spaceMaps:Space;
	var levelTiles:SpriteRenderer;
	var world:World;
	var levelId:Int;

	public function new(debugRenderer:ShapeRenderer, levelTiles:SpriteRenderer, world:World, levelId:Int) {
		#if editinglevels
		// load src version of tracks.ldtk (for hot reload)
		var json = sys.io.File.getContent("../../../assets/ldtk/space/space.ldtk");
		spaceMaps = new Space(json);
		#else
		// load packaged version of tracks.ldtk (for distribution)
		spaceMaps = new Space();
		#end

		this.levelTiles = levelTiles;
		this.world = world;
		this.levelId = levelId;

		var l_Tiles_16 = spaceMaps.levels[levelId].l_Tiles_16;
		var l_Tiles_16_RenderSize = 16;
		var obstacleDebugCore:DebugCore = {
			renderer: debugRenderer,
			color: 0x44008800
		}
		LevelLoader.renderLayer(l_Tiles_16, (stack, cx, cy) -> {
			for (tileData in stack) {
				var tileX = cx * l_Tiles_16_RenderSize;
				var tileY = cy * l_Tiles_16_RenderSize;
                var config = Configuration.obstacles[tileData.tileId];

				var sprite = this.levelTiles.makeSprite(tileX, tileY, l_Tiles_16_RenderSize, tileData.tileId);
				var hitBoxW = config.hitboxHeight;
				var hitBoxH = config.hitboxHeight;
				var body = new Body({
					shape: {
						solid: false,
						radius: hitBoxW * 0.5,
						width: hitBoxW,
						height: hitBoxH,
                        type: config.shape == CIRCLE ? ShapeType.CIRCLE : ShapeType.RECT
					},
					x: tileX,
					y: tileY,
					kinematic: true
				});
				var obstacle = new Obstacle(tileX, tileY, hitBoxW, hitBoxH, sprite, body, obstacleDebugCore);
				world.add(obstacle.body);
				obstacle.body.velocity.x = config.velocityX;
			}
		});
	}
}
