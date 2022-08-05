package escape;

import escape.scenes.CutScene;
import escape.scenes.CutScene.CutSceneConfiguration;
import tyke.Graphics;

class Configuration {
	public static var finishLineVelocity:Float = -50.0;

	public static var obstacles:Map<Int, ObstacleConfiguration> = [
		// example rectangle
		// 1000 => {
		// 	shape: RECT,
		// 	hitboxWidth: 4,
		// 	hitboxHeight: 4
		// velocityX: -30.0,
		// isDestructible: true,
		// damagePoints: 0
		// },
		0 => {
			shape: CIRCLE,
			hitboxWidth: 2,
			hitboxHeight: 2,
			velocityX: -50.0,
			isDestructible: true,
			damagePoints: 0
		},
		1 => {
			shape: CIRCLE,
			hitboxWidth: 5,
			hitboxHeight: 5,
			velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		2 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		3 => {
			shape: CIRCLE,
			hitboxWidth: 8,
			hitboxHeight: 8,
			velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		4 => {
			shape: RECT,
			hitboxWidth: 8,
			hitboxHeight: 8,
			velocityX: -50.0,
			isDestructible: false,
			damagePoints: 0
		},
		5 => {
			shape: CIRCLE,
			hitboxWidth: 10,
			hitboxHeight: 6,
			velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		6 => {
			shape: CIRCLE,
			hitboxWidth: 14,
			hitboxHeight: 14,
			velocityX: -50.0,
			isDestructible: false,
			damagePoints: 2
		},
		7 => {
			shape: CIRCLE,
			hitboxWidth: 14,
			hitboxHeight: 14,
			velocityX: -50.0,
			isDestructible: false,
			damagePoints: 0
		},
		8 => {
			shape: CIRCLE,
			hitboxWidth: 8,
			hitboxHeight: 8,
			velocityX: -50.0,
			isDestructible: false,
			damagePoints: 0
		},
		9 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			velocityX: -50.0,
			isDestructible: false,
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
				frames: [3, 4],
				framesPerSecond: 1,
				framesAssetPath: "assets/cutScenes/placeholders.png",
			}
		},
		{
			// 2 . level
			ldtk_level_id: 1,
			nextLevel: NextLevel(2),
			cutSceneConfig: {
				frames: [5, 6, 7],
				framesPerSecond: 1,
				framesAssetPath: "assets/cutScenes/placeholders.png",
			}
		},
		{
			// 3 . level
			ldtk_level_id: 2,
			nextLevel: GameWin,
			cutSceneConfig: {
				frames: [10, 10],
				framesPerSecond: 1,
				framesAssetPath: "assets/cutScenes/placeholders.png",
			}
		}
	];

	public static var introCutScene:CutSceneConfiguration = {
		
		frames: [0,1,2,3,4,5,6,7],
		framesAssetPath: "assets/cutScenes/test.png",
	};

	public static var gameOverScene:CutSceneConfiguration = {
		frames: [1, 1],
		framesPerSecond: 1,
		framesAssetPath: "assets/cutScenes/placeholders.png",
	};

	public static var gameWinScene:CutSceneConfiguration = {
		frames: [2, 2],
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
	public var velocityX:Float;

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
