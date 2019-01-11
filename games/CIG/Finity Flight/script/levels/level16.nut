//  Level 16
//  Grats!  =D

function level16()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 10000;
	local spawner = level.enemySpawner;
	level.levelMessage = "Congratulations!!!";

	spawner.congrats = true;
	
	return level;
}