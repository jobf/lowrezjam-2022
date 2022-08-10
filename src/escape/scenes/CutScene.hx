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
	public var changes:Array<AnimationChange> = [];
}

@:structInit 
class AnimationChange{
	public var atFrame:Int;
	public var framesPerSecond:Int;
}


class CutScene {
    var frame:Sprite;
	var refreshFrameCountdown:CountDown;
	var totalFrames:Int;
	var currentFrame:Int = 0;
	var currentChange:Int = 0;
	var config:CutSceneConfiguration;
    public var isComplete(get, null):Bool;

	public function new(config:CutSceneConfiguration, renderer:SpriteRenderer) {
		this.config = config;
		isComplete = false;
        var x = Std.int(config.frameWidth * 0.5) - 24;
		var y = Std.int(config.frameHeight * 0.5) - 14;
		totalFrames = config.frames.length;
		frame = renderer.makeSprite(x, y, config.frameHeight, config.frames[currentFrame], 0, true);
		refreshFrameCountdown = new CountDown(1 / config.framesPerSecond, () -> advanceFrame(), true);

	}

	function advanceFrame() {
		if(config.changes.length > 0 && currentChange <= config.changes.length-1){
			// trace('try change frame rate $currentChange');
			if(config.frames[currentFrame] == config.changes[currentChange].atFrame){
				trace('change frame rate');
				refreshFrameCountdown.reset(config.changes[currentChange].framesPerSecond);
				currentChange++;
			}
		}
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
