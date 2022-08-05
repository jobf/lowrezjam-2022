package escape.scenes;

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

		trace('\n \n \n \n ! cutscene new');
	}

	override function update(elapsedSeconds:Float) {
		super.update(elapsedSeconds);

		if (cutScene.isComplete) {
			trace('cutscene complete');
			onComplete(this);
		} else {
			cutScene.update(elapsedSeconds);
		}
	}
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

	var isWaitingForInput:Bool = false;

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