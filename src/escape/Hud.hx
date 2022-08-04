package escape;

import escape.Ship;
import tyke.Graphics;

class Hud {
	var weapon:Weapon;
	var tiles:SpriteRenderer;
	var weaponMeterSprite:Sprite;

	public function new(tiles:SpriteRenderer, weapon:Weapon) {
		this.tiles = tiles;
		this.weapon = weapon;
		final width = 64;
		final height = 14;
		var x = 64 + 32;
		var y = 64 - 6;
        var tileIndex = 6;
		weaponMeterSprite = tiles.makeSprite(x, y, width, tileIndex, 0, true, height);
	}

	var meterTileRange = 6;

	public function update() {
		var meterPercent = weapon.shotsAvailable / weapon.totalShots;
		var tile = Std.int(meterTileRange * meterPercent);
		weaponMeterSprite.tile = tile;
	}
}
