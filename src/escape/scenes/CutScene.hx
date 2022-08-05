package escape.scenes;

import tyke.Stage.IsComplete;
import peote.view.Color;
import tyke.App;
import tyke.Loop.CountDown;
import tyke.Graphics;
import Main.FullScene;

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
	public var sceneHeight:Int = 256;
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
        var x = Std.int(config.frameWidth * 0.5);
		var y = Std.int(config.frameHeight * 0.5);
		totalFrames = config.frames.length;
		frame = renderer.makeSprite(x, y, config.frameHeight, config.frames[currentFrame], 0, true);
		refreshFrameCountdown = new CountDown(1 / config.framesPerSecond, () -> advanceFrame(), true);

	}

	function advanceFrame() {
        if(isComplete){
            return;
        }

        currentFrame++;
        frame.tile = config.frames[currentFrame];
	}

    public function update(elapsedSeconds:Float){
        refreshFrameCountdown.update(elapsedSeconds);
    }


	function get_isComplete():Bool {
		return currentFrame >= totalFrames;
	}
}
