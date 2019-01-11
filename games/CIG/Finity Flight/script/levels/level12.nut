//Level 12
//  Regs
//  Reds
//  Mercury and Naiads
//  Naiads
//  Hoplite and Reds

function level12()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 25000;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 12/15"
		
	spawner.addEnemyToWave(0, 3.0, 5, "Regulus", 0);
	spawner.addEnemyToWave(0, 7.0, 5, "Regulus", 1);

	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 4, "Regulus", 2);
	spawner.addEnemyToWave(1, 7.0, 4, "Regulus", 2);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 4, "Naiad", 0);
	spawner.addEnemyToWave(2, 3.0, 1, "Mercury", 0);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(3, 6.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(3, 9.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(3, 12.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(3, 15.0, 1, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 2.0, 1, "Hoplite", 0);
	spawner.addEnemyToWave(4, 3.0, 6, "Regulus", 2);

	
	return level;
}
