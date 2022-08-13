import escape.SoundEffects;
import escape.Sun.addLavaFragment;
import peote.view.Color;
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
	// next line is which of the levels to start on 0 = Level 1, 1 = Level 2, 2 = Level 3
	static var startLevelIndex:Int = 0;

	public static var concepts:Array<App->Scene> = [
		// uncomment next line to get straight into the action
		// app -> return new PlayScene(app, startLevelIndex),
		app -> return new MovieScene(app, Configuration.levels[startLevelIndex].cutSceneConfig, new PlayScene(app, startLevelIndex)),
		app -> return new MovieScene(app, Configuration.gameOverShipExplodes, new PlayScene(app, startLevelIndex)),
		app -> return new TestSounds(app),
		app -> return new MovieScene(app, Configuration.gameOverShipExplodes, new PlayScene(app, startLevelIndex)),
		app -> return new MovieScene(app, Configuration.introCutSceneA, new MovieScene(app, Configuration.levels[startLevelIndex].cutSceneConfig, new PlayScene(app, startLevelIndex))),
		// app -> return new TestScene(app),
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
		// audio.setGain(0.001);
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
		lavaRenderer = stage.createShapeRenderLayer("lava");
		addLavaFragment(lavaRenderer);
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

	function drawGrid(){
		var color = Color.LIME;
		color.a = 100;
		var gridRenderer = stage.createRectangleRenderLayer("grid", false, false, this.width, this.height);
		var gap = 8;
		var w = width == 0 ? stage.width : width;
		var h = height == 0 ? stage.height : height;
		var numRows = Std.int(h / gap);
		var numCols = Std.int(w / gap);
		trace('grid dimension: $w x $h num rows/columns $numRows $numCols');
		for(y in 0...numRows){
			gridRenderer.makeRectangle(0, y * gap, w, 1, 0.0, color);
		}

		for(x in 0...numCols){
			gridRenderer.makeRectangle(x * gap, 0, 1, h, 0.0, color);
		}
	}


	var lavaRenderer:ShapeRenderer;
}
class TestSounds extends FullScene{
	override function create() {
		super.create();
		var soundEffects = new SoundEffects(audio);
		
		app.window.onKeyDown.add((code, modifier) -> 
			switch code{
				case NUMBER_1: soundEffects.playSound(Sample.CrackRock);
				case NUMBER_2: soundEffects.playSound(Sample.Explosion);
				case NUMBER_3: soundEffects.playSound(Sample.Hit);
				case NUMBER_4: soundEffects.playSound(Sample.LaserShoot);
				case NUMBER_5: soundEffects.playSound(Sample.Shoot);
				case _: audio.playSound(Sample.NoAmmo);
			}
		);
	}
}

class TestScene extends FullScene{
	override function create(){
		super.create();
		var shapeRenderer = stage.createShapeRenderLayer("sun", false, true);
		var circle = shapeRenderer.makeShape(320, 320, 500, 500, CIRCLE);
		
		shapeRenderer.injectIntoProgram("
		// random2 function by Patricio Gonzalez
		vec2 random2(vec2 st){
			st = vec2( dot(st,vec2(127.1,311.7)),
						dot(st,vec2(269.5,183.3)) );
			return -1.0 + 2.0*fract(sin(st)*43758.5453123);
		}
		
		// Value Noise by Inigo Quilez - iq/2013
		// https://www.shadertoy.com/view/lsf3WH
		float noise(vec2 st) {
			vec2 i = floor(st);
			vec2 f = fract(st);
		
			vec2 u = f*f*(3.0-2.0*f);
		
			return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ), 
								dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
						mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ), 
								dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
		}

		vec4 sun(vec4 c)
		{
			// c.r = 0.2;
			// return vec4(c.rgb, c.a);

			vec3 orange = vec3(1., .45, 0.);
			vec3 yellow = vec3(1., 0.15, 0.);
			
			// vec2 uv = (2. * fragCoord - iResolution.xy) / iResolution.y;
			vec2 uv = vTexCoord;
			uv.y += cos(uTime / 100.) * .1 + uTime / 10.;
			uv.x *= sin(uTime * 1. + uv.y * 4.) * .1 + .8;
			uv += noise(uv * 2.25 + uTime / 50.);

			float col = smoothstep(.01,.2, noise(uv * 3.))
				+ smoothstep(.01,.2, noise(uv * 3. + .5))
				+ smoothstep(.01,.3, noise(uv * 2. + .2));

			orange.rg += .3 * sin(uv.y * 4. + uTime / 1.) * sin(uv.x * 5. + uTime / 1.);

			c.rgb = mix(yellow, orange, vec3(smoothstep(0., 1., col)));
			return c;
		}
		");

		shapeRenderer.setColorFormula("
		sun(compose(color, shape, sides))
		");
	}
}
