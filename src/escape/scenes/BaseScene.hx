package escape.scenes;

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
		
		audio.playMusic(config.bgMusicAssetPath);

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
	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);
		
		if(isSceneOver){
			return;
		}

		if (cutScene.isComplete || isSkipScene) {
			trace('cutscene complete');
			isSceneOver = true;
			audio.stopMusic(() -> onComplete(this));
		} else {
			cutScene.update(elapsedSeconds);
		}
	}

	override function destroy() {
		super.destroy();
		controller.disable();
	}

	var controller:Controller;

	var isSkipScene(default, null):Bool = false;
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
