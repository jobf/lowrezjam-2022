package escape;

import escape.Weapon;
import escape.scenes.CutScene;
import escape.Obstacle;

class Configuration {
	public static var baseVelocityX:Float = -100.0;
	public static var baseWeaponVelocityX:Float = 100.0;
	public static var isMuted:Bool = false;

	/**
		title screen intro
		game over
		end of game win
		start of level 1
		start of level 2
		start of level 3
	**/
	public static var levels:Array<LevelConfig> = [
		{
			// 1 . level
			ldtk_level_id: 4,
			nextLevel: NextLevel(1),
			cutSceneConfig: {
				frames: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 10, 10, 10],
				framesPerSecond: 6,
				framesAssetPath: "assets/cutScenes/test-frames-leave-earth.png",
			}
		},
		{
			// 2 . level
			ldtk_level_id: 5,
			nextLevel: NextLevel(2),
			cutSceneConfig: {
				frames: [
					2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37
				],
				framesPerSecond: 6,
				framesAssetPath: "assets/cutScenes/test-frames-leave-asteroid.png",
			}
		},
		{
			// 3 . level
			ldtk_level_id: 6,
			nextLevel: GameWin,
			cutSceneConfig: {
				frames: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
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

	public static var introCutSceneA:CutSceneConfiguration = {
		frames: [for (i in 0...142) i],
		framesPerSecond: 8,
		framesAssetPath: "assets/cutScenes/control-room-cut-16-sheet.png",
		frameWidth: 145,
		frameHeight: 145,
	};

	public static var winTheGame:CutSceneConfiguration = {
		frames: [for (i in 0...117) i],
		framesPerSecond: 8,
		framesAssetPath: "assets/cutScenes/win-the-game-exit-sun.png",
		frameWidth: 188,
		frameHeight: 188,
		sceneWidth: 188,
		sceneHeight: 188,
		changes: [
			{
				change: SetPosition(70, 94),
				animFrameIndex: 0
			},
			{
				change: ChangeScroll(-0.2, 0),
				animFrameIndex: 1
			},
			{
				change: ChangeScroll(0, 0),
				animFrameIndex: 11
			},
			{
				change: ChangeScroll(-1, 0),
				animFrameIndex: 19
			},
			{
				change: ChangeScroll(0, 0),
				animFrameIndex: 32
			},
			{
				change: SetPosition(0, 94),
				animFrameIndex: 33
			}
		]
	};

	public static var gameOverScene:CutSceneConfiguration = {
		frames: [1, 1],
		framesPerSecond: 1,
		framesAssetPath: "assets/cutScenes/placeholders.png",
		bgMusicAssetPath: "assets/audio/bg-game-over-b.ogg"
	};

	// end-of-the-earth-134x79
	public static var gameOverEarthEndingA:CutSceneConfiguration = {
		frames: [for (i in 0...37) i],
		// frames: [for(i in 21...51) i],
		framesPerSecond: 6,
		framesAssetPath: "assets/cutScenes/8-color/end-of-the-earth-128x128.png",
		bgMusicAssetPath: "assets/audio/bg-game-over-b.ogg",
		sceneWidth: 256,
		sceneHeight: 256,
		frameWidth: 128,
		frameHeight: 128,
		// autoPlayNextScene: true
		changes: [
			// {
			// 	framesPerSecond: 3,
			// 	atFrame: 22
			// }
		]
	};

	// public static var gameOverEarthEndingB:CutSceneConfiguration = {
	// 	frames: [for(i in 44...58) i],
	// 	framesPerSecond: 2,
	// 	framesAssetPath: "assets/cutScenes/8-color/end-of-the-earth-134x79.png",
	// 	bgMusicAssetPath: "assets/audio/bg-game-over-b.ogg",
	// 	sceneWidth: 256,
	// 	sceneHeight: 256,
	// 	frameWidth: 134,
	// 	frameHeight: 79
	// };
	// public static var gameOverEarthEndingA:CutSceneConfiguration = {
	// 	frames: [for(i in 0...43) i],
	// 	framesPerSecond: 6,
	// 	framesAssetPath: "assets/cutScenes/8-color/end-of-the-earth-128.png",
	// 	bgMusicAssetPath: "assets/audio/bg-game-over-b.ogg",
	// 	sceneWidth: 215,
	// 	sceneHeight: 128,
	// 	frameWidth: 215,
	// 	frameHeight: 128,
	// 	autoPlayNextScene: true
	// };
	// public static var gameOverEarthEndingB:CutSceneConfiguration = {
	// 	frames: [for(i in 44...58) i],
	// 	framesPerSecond: 2,
	// 	framesAssetPath: "assets/cutScenes/8-color/end-of-the-earth-128.png",
	// 	bgMusicAssetPath: "assets/audio/bg-game-over-b.ogg",
	// 	sceneWidth: 215,
	// 	sceneHeight: 128,
	// 	frameWidth: 215,
	// 	frameHeight: 128
	// };
	public static var gameWinScene:CutSceneConfiguration = {
		frames: [2, 2, 2, 2, 2, 2, 2],
		framesPerSecond: 1,
		framesAssetPath: "assets/cutScenes/placeholders.png",
	};

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
			velocityModX: 1.5,
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
			hitboxWidth: 0,
			hitboxHeight: 0,
			velocityModX: 1.5,
			isDestructible: false,
			letProjectileThrough: true,
			damagePoints: 0
		},
		5 => {
			shape: CIRCLE,
			hitboxWidth: 10,
			hitboxHeight: 6,
			velocityModX: 0.5,
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
			hitboxWidth: 2,
			hitboxHeight: 2,
			isDestructible: false,
			letProjectileThrough: true,
			damagePoints: 0
		},
		8 => {
			// sun target
			shape: CIRCLE,
			hitboxWidth: 8,
			hitboxHeight: 8,
			isDestructible: true,
			damagePoints: 0,
			spriteTileIdEnd: 13
		},
		9 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: false,
			letProjectileThrough: true,
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
			// target filled
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
			isDestructible: false,
			damagePoints: 0
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
			// velocityModX: -100.0,
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
			hitboxWidth: 14,
			hitboxHeight: 14,
			velocityModX: 0.5,
			isDestructible: false,
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

	public static var projectiles:Map<ProjectileType, ProjectileConfiguration> = [
		STANDARD => {
			velocityXMod: 2.0,
			// totalShots: totalShots,
			// spriteTileSize: spriteTileSize,
			spriteTileIdStart: 24,
			// shape: shape,
			refillSpeed: 0.3,
			// refillSpeed: refillSpeed,
			shotCooldown: 0.3,
			// isDestructible: isDestructible,
			// hitboxWidth: hitboxWidth,
			// hitboxHeight: hitboxHeight
		},
		BOMB => {
			velocityXMod: 0.2,
			totalShots: 3,
			spriteTileIdStart: 25,
			shotCooldown: 4.0,
			refillSpeed: 1000.0, // so long it never refills
			// isDestructible: isDestructible,
			// hitboxWidth: hitboxWidth,
			// hitboxHeight: hitboxHeight
		}
	];
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
