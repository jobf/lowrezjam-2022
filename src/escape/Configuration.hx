package escape;

import tyke.Graphics;

class Configuration {
	public static var obstacles:Map<Int, ObstacleConfiguration> = [
        // example rectangle
        // 1000 => {
		// 	shape: RECT,
		// 	hitboxWidth: 4,
		// 	hitboxHeight: 4
        // velocityX: -30.0
		// },
		0 => {
			shape: CIRCLE,
			hitboxWidth: 2,
			hitboxHeight: 2,
            velocityX: -30.0
		},
        1 => {
			shape: CIRCLE,
			hitboxWidth: 5,
			hitboxHeight: 5,
            velocityX: -30
		},
        2 => {
			shape: CIRCLE,
			hitboxWidth: 6,
			hitboxHeight: 6,
            velocityX: -30.0
		},
        3 => {
			shape: CIRCLE,
			hitboxWidth: 8,
			hitboxHeight: 8,
            velocityX: -30.0
		},
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
}
