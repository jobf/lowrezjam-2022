package escape;

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
		10 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: false,
			damagePoints: 1
		},
		11 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: false,
			damagePoints: 1
		},
		12 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		13 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		14 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		15 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		16 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		17 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		18 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		19 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		20 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		21 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		22 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		23 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		24 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		25 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		26 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		27 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		28 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		29 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		30 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		31 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		32 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		33 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		34 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		35 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		36 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		37 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		38 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		39 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		40 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		41 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		42 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		43 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
		44 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -50.0,
			isDestructible: true,
			damagePoints: 1
		},
	];

	public static var cutScenes:Map<Int, CutSceneConfiguration> = [
		0 => {
			startTile: 0,
			endTile: (8 * 4) - 1,
			// sceneWidth: sceneWidth,
			// sceneHeight: sceneHeight,
			// framesPerSecond: framesPerSecond,
			framesAssetPath: "assets/cutScenes/test.png",
			// backgroundColor: backgroundColor
		}
	];
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
