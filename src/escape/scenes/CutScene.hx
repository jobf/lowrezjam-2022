package escape.scenes;

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
	public var startTile:Int;
	public var endTile:Int;
	public var framesPerSecond:Int = 12;
	public var backgroundColor:Color = 0x000000ff;
	public var sceneWidth:Int = 256;
	public var sceneHeight:Int = 256;
}

class CutScene extends FullScene {
	var levelProgressIndex:Int;
	var cutSceneFrames:SpriteRenderer;
	var testFrame:Sprite;
	var refreshFrameCountdown:CountDown;
	var totalFrames:Int;
	var currentFrame:Int = 0;
	var config:CutSceneConfiguration;

	public function new(levelProgressIndex:Int, app:App, config:CutSceneConfiguration) {
		super(app, config.backgroundColor, config.sceneWidth, config.sceneHeight);
		this.levelProgressIndex = levelProgressIndex;
		this.config = config;
	}

	override function create() {
		super.create();
		cutSceneFrames = stage.createSpriteRendererFor(config.framesAssetPath, config.frameWidth, config.frameHeight, true, config.sceneWidth, config.sceneHeight);
		var x = Std.int(config.frameWidth * 0.5);
		var y = Std.int(config.frameHeight * 0.5);
		totalFrames = config.endTile - config.startTile;
		testFrame = cutSceneFrames.makeSprite(x, y, config.frameHeight, config.startTile, 0, true);
		refreshFrameCountdown = new CountDown(1 / config.framesPerSecond, () -> advanceFrame(), true);
		behaviours.push(refreshFrameCountdown);
	}

	function advanceFrame() {
		if (currentFrame < totalFrames - 1) {
			currentFrame++;
			testFrame.tile = currentFrame;
		} else {
			app.changeScene(new PlayScene(levelProgressIndex, app, 0x00000000, 256, 256));
		}
	}
}
