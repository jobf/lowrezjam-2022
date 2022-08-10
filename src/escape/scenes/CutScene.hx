package escape.scenes;

import peote.view.Color;
import tyke.Loop.CountDown;
import tyke.Graphics;

@:structInit
class CutSceneConfiguration {
	public var framesAssetPath:String;
	public var frameWidth:Int = 64;
	public var frameHeight:Int = 64;
	// public var startTile:Int;
	// public var endTile:Int;
    public var frames:Array<Int>;
	public var framesPerSecond:Int = 12;
	public var backgroundColor:Color = 0x000000ff;
	public var sceneWidth:Int = 256;
	public var bgMusicAssetPath = "assets/audio/bg-intro-d.ogg";
	public var sceneHeight:Int = 256;
	public var autoPlayNextScene:Bool = false;
}


class CutScene {
    var frame:Sprite;
	var refreshFrameCountdown:CountDown;
	var totalFrames:Int;
	var currentFrame:Int = 0;
	var config:CutSceneConfiguration;
    public var isComplete(get, null):Bool;

	public function new(config:CutSceneConfiguration, renderer:SpriteRenderer) {
		this.config = config;
		isComplete = false;
        var x = 0;//Std.int(config.frameWidth * 0.5);
		var y = 0;//Std.int(config.frameHeight * 0.5);
		totalFrames = config.frames.length;
		frame = renderer.makeSprite(x, y, config.frameHeight, config.frames[currentFrame], 0, true);
		refreshFrameCountdown = new CountDown(1 / config.framesPerSecond, () -> advanceFrame(), true);

	}

	function advanceFrame() {
        currentFrame++;
		// trace('new frame is ${config.frames[currentFrame]}');
	}
	
    public function update(elapsedSeconds:Float){
		if(!isComplete){
			refreshFrameCountdown.update(elapsedSeconds);
			frame.tile = config.frames[currentFrame];
		}
    }


	function get_isComplete():Bool {
		return currentFrame >= config.frames.length - 1;
	}
}
