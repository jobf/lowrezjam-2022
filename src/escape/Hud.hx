package escape;

import escape.Ship;
import tyke.Graphics;
import core.Actor;

class Hud {
	var weapon:Weapon;
	// var ledSystem:ActorSystem;
	var tiles:SpriteRenderer;
	var weaponMeterSprite:Sprite;
	var shieldMeterSprite:Sprite;

	public function new(tiles:SpriteRenderer, weapon:Weapon) {
		this.tiles = tiles;
		this.weapon = weapon;
		final width = 64;
		final height = 4;
		var x = 64 + 32;
		var y = 64 - 3;
		var tileIndex = 0;
		weaponMeterSprite = tiles.makeSprite(x, y, width, tileIndex, 0, true, height);

		var x = 64 + 32;
		var y = 3;
		var tileIndex = 6 + 7;
		shieldMeterSprite = tiles.makeSprite(x, y, width, tileIndex, 0, true, height);
		shieldMeterSprite.flipY(true);
	}

	var meterTileRange = 6;

	public function update(shieldPercent:Float) {
		var meterPercent = weapon.shotsAvailable / weapon.totalShots;
		var tile = Std.int(meterTileRange * meterPercent);
		weaponMeterSprite.tile = tile;

		var tile = Std.int(meterTileRange * shieldPercent);
		shieldMeterSprite.tile = tile + 7;
	}
}
