//  Level 13
//  2 Mercury
//  Naiads
//  Regs and Januses
//  Reds
//  Mercury and Januses

function level13()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 14000;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 13/15"
		
	spawner.addEnemyToWave(0, 1.5, 2, "Mercury", 0);

	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 0.0, 5, "Naiad", 0);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 1.0, 3, "Regulus", 1);
	spawner.addEnemyToWave(2, 3.0, 1, "Janus", 0);
	spawner.addEnemyToWave(2, 6.0, 3, "Regulus", 1);
	spawner.addEnemyToWave(2, 9.0, 1, "Janus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 2.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(3, 6.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(3, 10.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(3, 14.0, 4, "Regulus", 2);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 3.0, 2, "Janus", 0);
	spawner.addEnemyToWave(4, 5.0, 1, "Mercury", 1);

	
	return level;
}
