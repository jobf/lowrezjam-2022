package concepts;

import Main;
import tyke.Loop.CountDown;
import lime.ui.KeyCode;
import echo.Body;
import tyke.Graphics;
import peote.text.FontProgram;
import peote.text.Font;
import tyke.Glyph;
import tyke.Loop.Glyphs;
import tyke.jam.Scene;
import tyke.jam.SoundManager;
import echo.World;
import echo.Echo;
import tyke.Stage;
import tyke.jam.Scene;
import peote.view.Color;
import tyke.App;

class TestScene extends FullScene {
	var font:Font<FontStyle>;
	var fontStyle:FontStyle;
	var fontProgram:FontProgram<FontStyle>;

	override function create() {
		super.create();
		var rectangles = stage.createRectangleRenderLayer("lines");
		var gap:Int = 8;
		var numLines = Std.int(64 / gap);
		for (i in 0...numLines) {
			rectangles.makeRectangle(0, Std.int(i * gap), 64.0, 1.0, 0.0, Color.CYAN);
			rectangles.makeRectangle(Std.int(i * gap), 0, 1.0, 64.0, 0.0, Color.CYAN);
		}

		audio.playMusic("assets/oplish.ogg");

		// var text = Glyphs.initText
		new Font<FontStyle>("assets/fonts/tiled/betterpixels.json").load((font) -> {
			this.font = font;
			this.fontStyle = font.createFontStyle();
			fontStyle.width = font.config.width;
			fontStyle.height = font.config.height;
			fontStyle.weight = 1.0;
			fontStyle.bgColor = 0x00000000;
			fontStyle.color = 0x000000FF;
			this.fontProgram = font.createFontProgram(this.fontStyle);
			this.app.core.display.addProgram(this.fontProgram);
			fontProgram.createLine("TEST");
		});
	}
}