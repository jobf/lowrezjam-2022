package escape;

import tyke.jam.SoundManager;


@:enum
abstract Sample(Int) from Int to Int
{
  var CrackRock = 0;
  var Explosion = 1;
  var Hit = 2;
  var LaserShoot = 3;
  var NoAmmo = 4;
  var Shoot = 5;
}

class SoundEffects{
	var audio:SoundManager;
	
	public function new(audio:SoundManager){
		this.audio = audio;

		audio.loadSounds([
			Sample.CrackRock => "assets/audio/sounds/crackingRock.ogg",
			Sample.Explosion => "assets/audio/sounds/explosion.ogg",
			Sample.Hit => "assets/audio/sounds/hit.ogg",
			Sample.LaserShoot => "assets/audio/sounds/laserShoot.ogg",
			Sample.NoAmmo => "assets/audio/sounds/noAmmo5.ogg",
			Sample.Shoot => "assets/audio/sounds/shoot1.ogg",
		]);
	}




	public function playSound(index:Sample) {
		audio.playSound(index);
	}
}