package escape;

import escape.Ship;
import tyke.Graphics;

class Hud {
	var weapon:Weapon;
	var tiles:SpriteRenderer;
	var weaponMeterSprite:Sprite;
	var shieldMeterSprite:Sprite;

	public function new(tiles:SpriteRenderer, weapon:Weapon) {
		this.tiles = tiles;
		this.weapon = weapon;
		final width = 64;
		final height = 14;
		var x = 64 + 32;
		var y = 64 - 5;
        var tileIndex = 6;
		weaponMeterSprite = tiles.makeSprite(x, y, width, tileIndex, 0, true, height);

		var x = 64 + 32;
		var y = 5;
        var tileIndex = 6 + 8;
		shieldMeterSprite = tiles.makeSprite(x, y, width, tileIndex, 0, true, height);
		shieldMeterSprite.flipY(true);
	}

	var meterTileRange = 6;

	public function update(shieldPercent:Float) {
		var meterPercent = weapon.shotsAvailable / weapon.totalShots;
		var tile = Std.int(meterTileRange * meterPercent);
		weaponMeterSprite.tile = tile;

		var tile = Std.int(meterTileRange * shieldPercent);
		shieldMeterSprite.tile = tile + 8;

	}
}
