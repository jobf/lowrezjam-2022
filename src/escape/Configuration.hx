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
				frames: [for (i in 0...78) i],
				framesPerSecond: 6,
				framesAssetPath: "assets/cutScenes/level-1-preview.png",
				frameWidth: 200,
				frameHeight: 200,
				sceneWidth: 200,
				sceneHeight: 128,
				initial_x: 32,
				initial_y: 64,
				changes: [
				// {
				// 	change: SetPosition(32, 64),
				// 	animFrameIndex: 0
				// },
				{
					change: ChangeScroll(-0.2, 0.2),
					animFrameIndex: 55
				},
				{
					change: ChangeScroll(-0.1, 0.1),
					animFrameIndex: 66
				},
				{
					change: ChangeScroll(0, 0),
					animFrameIndex: 68
				}]
			}
		},
		{
			// 2 . level
			ldtk_level_id: 5,
			nextLevel: NextLevel(2),
			cutSceneConfig: {
				frames: [for (i in 0...67) i],
				framesPerSecond: 4,
				framesAssetPath: "assets/cutScenes/level-2-preview.png",
				frameWidth: 128,
				frameHeight: 128,
				sceneWidth: 128,
				sceneHeight: 128,
				initial_x: 64,
				initial_y: 63,
				changes: [
				// {
				// 	change: SetPosition(64, 63),
				// 	animFrameIndex: 0
				// },
				{
					change: ChangeScroll(-1.2, 0),
					animFrameIndex: 1
				},
				{
					change: ChangeScroll(0, 0),
					animFrameIndex: 4
				},
				{
					change: SetPosition(32, 64),
					animFrameIndex: 11
				
				},
				{
					change: ChangeScroll(0.25, 0),
					animFrameIndex: 24
				},
				{
					change: ChangeScroll(0, 0),
					animFrameIndex: 32
				}
				,
				{
					change: ChangeFrameRate(0.1),
					animFrameIndex: 33
				}
			]
			}
		},
		{
			// 3 . level
			ldtk_level_id: 6,
			nextLevel: GameWin,
			cutSceneConfig: {
				frames: [for (i in 0...12) i],
				framesPerSecond: 4,
				framesAssetPath: "assets/cutScenes/level-3-preview.png",
				frameWidth: 200,
				frameHeight: 200,
				sceneWidth: 200,
				sceneHeight: 200,
				initial_x: 32,
				initial_y: 64,
				// changes: [
				// 	{
				// 	change: SetPosition(32, 64),
				// 	animFrameIndex: 0
				// }]
			}
		}
	];

	public static var introCutScene:CutSceneConfiguration = {
		frames: [for (i in 0...5) 13],
		framesPerSecond: 1,
		framesAssetPath: "assets/cutScenes/test-frames-control-room.png",
		// framesAssetPath: "assets/cutScenes/control-room-cut-16-sheet.png",
		frameWidth: 64,
		frameHeight: 64,
		initial_x: 32,
		initial_y: 32,
		// changes: [
		// 	{
		// 		change: SetPosition(32,32),
		// 		animFrameIndex: 0
		// 	}
		// ]
	};


	public static var winTheGame:CutSceneConfiguration = {
		frames: [for (i in 0...46) i],
		framesPerSecond: 8,
		framesAssetPath: "assets/cutScenes/win-the-game-exit-sun2.png",
		frameWidth: 188,
		frameHeight: 188,
		sceneWidth: 188,
		sceneHeight: 188,
		initial_x: 32,
		initial_y: 80,
		changes: [
			{
				change: SetPosition(32, 85),
				animFrameIndex: 7
			},
			{
				change: ChangeScroll(-0.4, 0),
				animFrameIndex: 8
			},
			{
				change: ChangeScroll(0, 0),
				animFrameIndex: 16
			},
			{
				change: SetPosition(27, 76),
				animFrameIndex: 23
			}
			// ,
			// {
			// 	change: ChangeScroll(-1, 0),
			// 	animFrameIndex: 19
			// },
			// {
			// 	change: ChangeScroll(0, 0),
			// 	animFrameIndex: 32
			// },
			
		]
	};


	// end-of-the-earth-134x79
	public static var gameOverEarthExplodes:CutSceneConfiguration = {
		frames: [for (i in 0...36) i],
		framesPerSecond: 6,
		framesAssetPath: "assets/cutScenes/game-over-earth-explodes.png",
		bgMusicAssetPath: "assets/audio/bg-game-over-b.ogg",
		sceneWidth: 200,
		sceneHeight: 200,
		frameWidth: 134,
		frameHeight: 80,
		initial_x: 35,
		initial_y: 35,
		changes: [
			
			// {
			// 	change: SetPosition(35,35),
			// 	animFrameIndex: 0
			// },
			// {
			// 	framesPerSecond: 3,
			// 	atFrame: 22
			// }
		]
	};

	public static var gameOverTryAgain:CutSceneConfiguration = {
		frames: [for (i in 0...2) 0],
		framesPerSecond: 6,
		framesAssetPath: "assets/cutScenes/placeholders.png",
		bgMusicAssetPath: "assets/audio/bg-game-over-b.ogg",
		sceneWidth: 64,
		sceneHeight: 64,
		frameWidth: 64,
		frameHeight: 64,
		initial_x: 32,
		initial_y: 32,
		changes: [
			
			// {
			// 	change: SetPosition(32,84),
			// 	animFrameIndex: 0
			// },
			// {
			// 	framesPerSecond: 3,
			// 	atFrame: 22
			// }
		]
	};
		// end-of-the-earth-134x79
		public static var gameOverShipExplodes:CutSceneConfiguration = {
			frames: [for (i in 0...13) i],
			framesPerSecond: 6,
			framesAssetPath: "assets/cutScenes/game-over-ship-explodes.png",
			bgMusicAssetPath: "assets/audio/bg-game-over-b.ogg",
			sceneWidth: 200,
			sceneHeight: 200,
			frameWidth: 200,
			frameHeight: 200,
			initial_x: 32,
			initial_y: 84,
			changes: [
				
				// {
				// 	change: SetPosition(32,84),
				// 	animFrameIndex: 0
				// },
				// {
				// 	framesPerSecond: 3,
				// 	atFrame: 22
				// }
			]
		};


	public static var gameWinScene:CutSceneConfiguration = {
		frames: [2, 2, 2, 2, 2, 2, 2],
		framesPerSecond: 3,
		framesAssetPath: "assets/cutScenes/placeholders.png",
		initial_x: 32,
		initial_y: 32,
		changes: [
				
			// {
			// 	change: SetPosition(32,32),
			// 	animFrameIndex: 0
			// }
		
		]
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
			damagePoints: 1,
			numParticles: 2
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
			damagePoints: 1,
			numParticles: 3
		},
		6 => {
			shape: CIRCLE,
			hitboxWidth: 14,
			hitboxHeight: 14,
			velocityModX: 0.5,
			isDestructible: false,
			damagePoints: 2,
			numParticles: 4
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
			shotCooldown: 0.07,
			// isDestructible: isDestructible,
			// hitboxWidth: hitboxWidth,
			// hitboxHeight: hitboxHeight
		},
		BOMB => {
			velocityXMod: 0.2,
			totalShots: 3,
			spriteTileIdStart: 25,
			shotCooldown: 1.0,
			refillSpeed: 3.0, // so long it never refills
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
