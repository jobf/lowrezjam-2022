package escape.scenes;

import peote.view.Color;
import tyke.App;
import tyke.Loop.CountDown;
import tyke.Graphics;
import Main.FullScene;

class CutScene extends FullScene {
	var levelProgressIndex:Int;
	public function new(levelProgressIndex:Int, app:App, backgroundColor:Color = 0x000000ff, width:Int = 0, height:Int = 0) {
		super(app, backgroundColor, width, height);
		this.levelProgressIndex = levelProgressIndex;
	}

	override function create() {
		super.create();
		cutSceneFrames = stage.createSpriteRendererFor("assets/cutScenes/test.png", 64, 64, true);
		testFrame = cutSceneFrames.makeSprite(32, 32, 64, 0);
		final framesPerSecond = 12;

		refreshFrameCountdown = new CountDown(1 / framesPerSecond, () -> advanceFrame(), true);
		behaviours.push(refreshFrameCountdown);
	}

	var cutSceneFrames:SpriteRenderer;

	var testFrame:Sprite;

	var refreshFrameCountdown:CountDown;
	var totalFrames:Int = (8 * 4) - 1;
	var currentFrame:Int = 0;

	function advanceFrame() {
		if (currentFrame < totalFrames - 1) {
			currentFrame++;
			testFrame.tile = currentFrame;
		} else {
			app.changeScene(new PlayScene(levelProgressIndex, app, 0x00000000, 256, 256));
		}
	}
}
