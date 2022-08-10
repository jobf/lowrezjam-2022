import escape.scenes.BaseScene;
import escape.Configuration;
import escape.scenes.PlayScene;
import escape.scenes.CutScene;
import tyke.Loop;
import tyke.Graphics;
import tyke.jam.SoundManager;
import echo.World;
import echo.Echo;
import tyke.Stage;
import tyke.jam.Scene;
import tyke.App;

class Main extends App {
	public function new() {
		super({
			screenWidth: 64,
			screenHeight: 64,
			initScene: app -> new Concepts(this),
			backgroundColor: 0x12345678,
			updatesPerSecond: 30,
			framesPerSecond: 60,
			screenIsScaled: true
		});
	}
}

class Concepts extends FullScene {
	static var startLevelIndex:Int = 0;
	public static var concepts:Array<App->Scene> = [
		app -> return new MovieScene(app, Configuration.introCutScene, new MovieScene(app, Configuration.levels[startLevelIndex].cutSceneConfig, new PlayScene(app, startLevelIndex))),
		app -> return new MovieScene(app, Configuration.levels[startLevelIndex].cutSceneConfig, new PlayScene(app, startLevelIndex)),
		app -> return new PlayScene(app, startLevelIndex),
		// app -> return new TitleScene(app, Configuration.introCutScene, scene -> app.changeScene()_,
	];

	override function create() {
		super.create();
		app.window.onKeyDown.add((code, modifier) -> {
			var conceptId = switch code {
				case R: -2;
				case NUMBER_1: 0;
				case NUMBER_2: 1;
				case NUMBER_3: 2;
				case _: -1;
			}

			if (conceptId == -2) {
				app.resetScene();
			}

			if (conceptId >= 0) {
				// app.changeScene(concepts[conceptId](app));
			}
		});
		var lastIndex = concepts.length - 1;
		// app.changeScene(concepts[lastIndex](app));
		app.changeScene(concepts[0](app));
	}
}

class FullScene extends Scene {
	var stage:Stage;
	var world:World;
	var audio:SoundManager;
	var behaviours:Array<CountDown> = [];

	var tiles14px:SpriteRenderer;
	var tiles18px:SpriteRenderer;
	var tiles640px:SpriteRenderer;

	var starRenderer:ShapeRenderer;
	var starSpriteRenderer:SpriteRenderer;
	var spaceLevelTilesFar:SpriteRenderer;
	var spaceLevelTiles:SpriteRenderer;
	var spaceLevelTilesNear:SpriteRenderer;
	var projectileSprites:SpriteRenderer;
	var hudFrame:SpriteRenderer;
	var debugShapes:ShapeRenderer;
	
	override function create() {
		super.create();
		#if !debug
		// disable manual scroll unless in debug mode
		scrollIncrement = 0;
		#end
		// todo - pass stage dimensions into Scene constructor as nullable ints?
		var stageWidth = app.core.config.screenWidth;
		var stageHeight = app.core.config.screenHeight;
		stage = new Stage(app.core, stageWidth, stageHeight);
		app.core.log('initialized stage $stageWidth $stageHeight');

		world = Echo.start({
			width: stageWidth,
			height: stageHeight,
			gravity_y: 100,
			iterations: 2
		});
		app.core.log('initialized echo $stageWidth $stageHeight');

		audio = new SoundManager();
		if(Configuration.isMuted){
			audio.mute();
		}
		app.core.log('initialized audio');

		var tiles14pxTilesWide = 8;
		var tiles18pxTilesWide = 1;
		var isIndividualFrameBuffer = false;
		starRenderer = stage.createShapeRenderLayer("stars", false, true, this.width, this.height);
		starSpriteRenderer = stage.createSpriteRendererFor("assets/sprites/stars-64x1.png", 64, 1, true);
		tiles640px = stage.createSpriteRendererFor("assets/sprites/640x640-sun-surface.png", 640, 640, true, 640, 640);
		
		spaceLevelTilesFar = stage.createSpriteRendererFor("assets/sprites/16-px-tiles.png", 16, 16, true, "far");
		spaceLevelTiles = stage.createSpriteRendererFor("assets/sprites/16-px-tiles.png", 16, 16, true, "mid");
		projectileSprites = stage.createSpriteRendererFor("assets/sprites/14-px-tiles.png", 14, 14, isIndividualFrameBuffer, "projectiles");
		tiles14px = stage.createSpriteRendererFor("assets/sprites/14-px-tiles.png", 14, 14, isIndividualFrameBuffer);
		spaceLevelTilesNear = stage.createSpriteRendererFor("assets/sprites/16-px-tiles.png", 16, 16, true, "near");

		tiles18px = stage.createSpriteRendererFor("assets/sprites/18-px-tiles.png", 18, 18, isIndividualFrameBuffer, 640, 640);
		hudFrame = stage.createSpriteRendererFor("assets/sprites/hud-frame.png", 64, 64, isIndividualFrameBuffer, 640, 640);
		
		debugShapes = stage.createShapeRenderLayer("debugShapes");
		app.core.log('initialized renderers');

		app.window.onKeyDown.add((code, modifier) -> switch code {
			case W: scrollUp();
			case A: scrollLeft();
			case S: scrollDown();
			case D: scrollRight();
			case P: {
				Configuration.isMuted = true;
				audio.mute();
			};
			case _: return;
		});
	}

	override function destroy() {
		super.destroy();
		world.dispose();
		audio.dispose();
	}

	override function update(elapsedSeconds:Float) {
		// super.update(elapsedSeconds);
		world.step(elapsedSeconds);
		audio.update(elapsedSeconds);
		for (b in behaviours) {
			b.update(elapsedSeconds);
		}
	}

	override function draw(deltaTime:Int) {
		// super.draw(deltaTime);
		stage.updateGraphicsBuffers();
	}

	override function onPauseStart() {
		// super.onPauseStart();
		audio.pause(true);
	}

	override function onPauseEnd() {
		// super.onPauseEnd();
		audio.pause(false);
	}

	var scrollIncrement = 8;

	function scrollLeft() {
		@:privateAccess
		stage.globalFrameBuffer.display.xOffset += scrollIncrement;
	}

	function scrollRight() {
		@:privateAccess
		stage.globalFrameBuffer.display.xOffset -= scrollIncrement;
	}

	function scrollUp() {
		@:privateAccess
		stage.globalFrameBuffer.display.yOffset += scrollIncrement;
	}

	function scrollDown() {
		@:privateAccess
		stage.globalFrameBuffer.display.yOffset -= scrollIncrement;
	}

	var tiles64px:SpriteRenderer;
}
