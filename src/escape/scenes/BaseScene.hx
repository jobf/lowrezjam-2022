package escape.scenes;

import tyke.Graphics;
import core.Controller;
import lime.ui.KeyCode;
import tyke.Graphics.SpriteRenderer;
import tyke.App;
import escape.scenes.CutScene;
import Main.FullScene;

class MovieScene extends FullScene {
	var cutScene:CutScene;
	var config:CutSceneConfiguration;
	var cutSceneRenderer:SpriteRenderer;
	var onComplete:(scene:FullScene) -> Void;
	var nextScene:FullScene;

	public function new(app:App, config:CutSceneConfiguration, nextScene:FullScene) {
		super(app, config.backgroundColor, config.sceneWidth, config.sceneHeight);
		this.config = config;
		// this.onComplete = onComplete;
		this.nextScene = nextScene;
	}
	
	// override c
	override function create() {
		super.create();
		
		
		cutSceneRenderer = stage.createSpriteRendererFor(config.framesAssetPath, config.frameWidth, config.frameHeight, true, config.sceneWidth,
			config.sceneHeight);
			
		cutScene = new CutScene(config, cutSceneRenderer);

		var buttonTiles = stage.createSpriteRendererFor("assets/sprites/14-px-tiles.png", 14, 14, true);
		continueButton = buttonTiles.makeSprite(32, 53, 14, 32, 0, false);

		if(!Configuration.preserveMusic){
			audio.playMusic(config.bgMusicAssetPath);
		}

		controller = new Controller(app.window, {
			onControlUp: isDown -> return,
			onControlRight: isDown -> return,
			onControlLeft: isDown -> return,
			onControlDown: isDown -> return,
			onControlAction: isDown -> isSkipScene = true
		});
		controller.enable();

		trace('\n \n \n \n ! cutscene new');
	}

	var isSceneOver:Bool = false;
	var isFading:Bool = false;

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		
		if (isSkipScene && !isFading) {
			trace('fade and start new scence');
			isFading = true;
			if(nextScene != null){
				audio.stopMusic(() -> app.changeScene(nextScene));
			}
		}

		if(isSceneOver){
			return;
		}

		if(!cutScene.isComplete){
			cutScene.update(elapsedSeconds);
		}else{
			isSceneOver = true;
			trace('cutscene complete');
			continueButton.makeVisible(true);
			continueButton.setFlashing(true);
		}

		
	}

	override function destroy() {
		super.destroy();
		controller.disable();
	}


	override function scrollDown() {
		cutScene.scrollDown(scrollIncrement);
	}

	override function scrollUp() {
		cutScene.scrollUp(scrollIncrement);
	}

	override function scrollLeft() {
		cutScene.scrollLeft(scrollIncrement);
	}

	override function scrollRight() {
		cutScene.scrollRight(scrollIncrement);
	}

	var controller:Controller;

	var isSkipScene(default, null):Bool = false;


	var continueButton:Sprite;
}

class TitleScene extends FullScene {
	var cutScene:CutScene;
	var config:CutSceneConfiguration;
	var cutSceneRenderer:SpriteRenderer;
	var onComplete:(scene:FullScene) -> Void;

	public function new(app:App, config:CutSceneConfiguration, onComplete:(scene:FullScene) -> Void) {
		super(app, config.backgroundColor, config.sceneWidth, config.sceneHeight);
		this.config = config;
		this.onComplete = onComplete;
	}

	// override c
	override function create() {
		super.create();
		cutSceneRenderer = stage.createSpriteRendererFor(config.framesAssetPath, config.frameWidth, config.frameHeight, true, config.sceneWidth,
			config.sceneHeight);

		cutScene = new CutScene(config, cutSceneRenderer);
		app.window.onKeyDown.add((code, modifier) -> handleInput(code));


		#if debug
		drawGrid();
		#end
		trace('\n \n \n \n ! cutscene new');
	}

	var isWaitingForInput:Bool = true;

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		if (!isWaitingForInput) {
			cutScene.update(elapsedSeconds);
		} else {
			if (cutScene.isComplete) {
				trace('cutscene complete');
				isWaitingForInput = true;
			}
		}
	}

	function handleInput(code:KeyCode) {
		if (code == RETURN) {
			onComplete(this);
		}
	}

}
