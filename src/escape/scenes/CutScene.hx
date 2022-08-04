package escape.scenes;

import tyke.Loop.CountDown;
import tyke.Graphics;
import Main.FullScene;

class CutScene extends FullScene {
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
        if(currentFrame < totalFrames-1){
            currentFrame++;
            testFrame.tile = currentFrame;
        }
        else{
            app.changeScene(new EscapeVelocity(app, 0x00000000, 256, 256));
        }
    }
}