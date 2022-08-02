import escape.EscapeVelocity;
import tyke.Loop;
import tyke.Graphics;
import concepts.SunBurn;
import concepts.HotFarmer;
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
	public static var concepts:Array<App->Scene> = [
		app -> return new EscapeVelocity(app, 0x00000000, 256, 256),
		app -> return new SunBurn(app, 0xffbd4aFF),
		app -> return new HotFarmer(app, 0x521104FF),
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

			if(conceptId == -2){
				app.resetScene();
			}

			if (conceptId >= 0) {
				app.changeScene(concepts[conceptId](app));
			}
		});
		var lastIndex = concepts.length -1;
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
	
	var starRenderer:ShapeRenderer;
	var starSpriteRenderer:SpriteRenderer;
	var spaceLevelTiles:SpriteRenderer;
	var debugShapes:ShapeRenderer;
	// public function new(app:App, backgroundColor:Color = 0x000000ff, actionCallBawidth:Int = 0, height:Int = 0){

	// }

	override function create() {
		super.create();

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
		app.core.log('initialized audio');
		var tiles14pxTilesWide = 8;
		var tiles18pxTilesWide = 1;
		var isIndividualFrameBuffer = true;
		starRenderer = stage.createShapeRenderLayer("stars", false, true, this.width, this.height);
		starSpriteRenderer = stage.createSpriteRendererFor("assets/sprites/stars-64x1.png", 1, true);
		spaceLevelTiles = stage.createSpriteRendererFor("assets/sprites/16-px-tiles.png", 8, true);
		tiles14px = stage.createSpriteRendererFor("assets/sprites/14-px-tiles.png", tiles14pxTilesWide, isIndividualFrameBuffer);
		tiles18px = stage.createSpriteRendererFor("assets/sprites/18-px-tiles.png", tiles18pxTilesWide, isIndividualFrameBuffer, 640, 640);
		debugShapes = stage.createShapeRenderLayer("debugShapes");
		app.core.log('initialized renderers');
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



}
