package escape;

import tyke.jam.SoundManager;

@:enum
abstract Sample(Int) from Int to Int {
	var RockA = 0;
	var RockB = 1;
	var RockC = 2;
	var Explosion = 3;
	var HitTarget = 4;
	var LaserShoot = 5;
	var NoAmmo = 6;
	var Shoot = 7;
	var TakeDamage = 8;
}

class SoundEffects {
	var audio:SoundManager;

	public function new(audio:SoundManager) {
		this.audio = audio;

		audio.loadSounds([
			Sample.RockA => "assets/audio/sounds/rockBreak0.ogg",
			Sample.RockB => "assets/audio/sounds/rockBreak1.ogg",
			Sample.RockC => "assets/audio/sounds/rockBreak2.ogg",
			Sample.Explosion => "assets/audio/sounds/explosion.ogg",
			Sample.TakeDamage => "assets/audio/sounds/hit.ogg",
			// Sample.LaserShoot => "assets/audio/sounds/laserShoot.ogg",
			Sample.NoAmmo => "assets/audio/sounds/noAmmo5.ogg",
			Sample.Shoot => "assets/audio/sounds/shoot1.ogg",
			Sample.HitTarget => "assets/audio/sounds/hitTarget.ogg"
		]);
	}

	public function playSound(index:Sample) {
		audio.playSound(index);
	}
}
