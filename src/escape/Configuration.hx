package escape;

import escape.scenes.CutScene;
import escape.scenes.CutScene.CutSceneConfiguration;
import tyke.Graphics;

class Configuration {
	public static var baseVelocityX: Float = -100.0;

	public static var obstacles:Map<Int, ObstacleConfiguration> = [
		// example rectangle
		// 1000 => {
		// 	shape: RECT,
		// 	hitboxWidth: 4,
		// 	hitboxHeight: 4
		// velocityModX: -30.0,
		// isDestructible: true,
		// damagePoints: 0
		// },
		0 => {
			shape: CIRCLE,
			hitboxWidth: 2,
			hitboxHeight: 2,
			velocityModX: 2.0,
			isDestructible: true,
			damagePoints: 0
		},
		1 => {
			shape: CIRCLE,
			hitboxWidth: 5,
			hitboxHeight: 5,
			isDestructible: true,
			damagePoints: 1
		},
		2 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		3 => {
			shape: CIRCLE,
			hitboxWidth: 8,
			hitboxHeight: 8,
			isDestructible: true,
			damagePoints: 1
		},
		4 => {
			shape: RECT,
			hitboxWidth: 8,
			hitboxHeight: 8,
			isDestructible: false,
			damagePoints: 0
		},
		5 => {
			shape: CIRCLE,
			hitboxWidth: 10,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		6 => {
			shape: CIRCLE,
			hitboxWidth: 14,
			hitboxHeight: 14,
			velocityModX: 0.5,
			isDestructible: false,
			damagePoints: 2
		},
		7 => {
			shape: CIRCLE,
			hitboxWidth: 14,
			hitboxHeight: 14,
			isDestructible: false,
			damagePoints: 0
		},
		8 => {
			shape: CIRCLE,
			hitboxWidth: 8,
			hitboxHeight: 8,
			isDestructible: false,
			damagePoints: 0
		},
		9 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: false,
			damagePoints: 1
		},
		10 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: false,
			damagePoints: 1
		},
		11 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: false,
			damagePoints: 1
		},
		12 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		13 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		14 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		15 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		16 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		17 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		18 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		19 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		20 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		21 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		22 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityModX: -100.0,
			isDestructible: true,
			damagePoints: 1
		},
		23 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		24 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		25 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		26 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		27 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		28 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		29 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		30 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		31 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		32 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		33 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		34 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		35 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		36 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		37 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		38 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		39 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		40 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		41 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		42 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		43 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
		44 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: true,
			damagePoints: 1
		},
	];

	/**
		0 title screen intro
		1 game over
		2 end of game win
		11 start of level 1
		12 start of level 2
		13 start of level 3

	**/
	public static var levels:Array<LevelConfig> = [
		{
			// 1 . level
			ldtk_level_id: 0,
			nextLevel: NextLevel(1),
			cutSceneConfig: {
				frames: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 10, 10, 10],
				framesPerSecond: 6,
				framesAssetPath: "assets/cutScenes/test-frames-leave-earth.png",
			}
		},
		{
			// 2 . level
			ldtk_level_id: 1,
			nextLevel: NextLevel(2),
			cutSceneConfig: {
				frames: [2, 3, 4, 5, 6, 7, 8, 9, 10,11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 39, 39, 39, 39, 39],
				framesPerSecond: 6,
				framesAssetPath: "assets/cutScenes/test-frames-leave-asteroid.png",
			}
		},
		{
			// 3 . level
			ldtk_level_id: 2,
			nextLevel: GameWin,
			cutSceneConfig: {
				frames: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 16, 16, 16, 16, 16],
				framesPerSecond: 4,
				framesAssetPath: "assets/cutScenes/test-frames-leave-sun.png",
			}
		}
	];

	public static var introCutScene:CutSceneConfiguration = {
		frames: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 13],
		framesPerSecond: 3,
		framesAssetPath: "assets/cutScenes/test-frames-control-room.png",
	};

	public static var gameOverScene:CutSceneConfiguration = {
		frames: [1, 1],
		framesPerSecond: 1,
		framesAssetPath: "assets/cutScenes/placeholders.png",
	};

	public static var gameWinScene:CutSceneConfiguration = {
		frames: [2, 2, 2, 2, 2, 2, 2],
		framesPerSecond: 1,
		framesAssetPath: "assets/cutScenes/placeholders.png",
	};
}

@:structInit
class ObstacleConfiguration {
	/**
		how wide the collision body should be (full width not radius)
	**/
	public var hitboxWidth:Int;

	/**
		how high the collision body should be (full width not radius)
	**/
	public var hitboxHeight:Int;

	/**
		the speed the body moves at, negative values means moving to the left
	**/
	public var velocityModX:Float = 1.0;

	/**
		if it's a CIRCLE or RECT (rectangle)
	**/
	public var shape:Geometry;

	/**
		if the obstacle can be destroyed set this to true
	**/
	public var isDestructible:Bool;

	/**
		how much damage the obstacle inflicts on a ship when colliding
	**/
	public var damagePoints:Int;
}

@:structInit
class LevelConfig {
	public var cutSceneConfig:CutSceneConfiguration;
	public var ldtk_level_id:Int;
	public var nextLevel:SceneChange;
}

enum SceneChange {
	Intro;
	GameOver;
	GameWin;
	NextLevel(levelIndex:Int);
}
