//  Level 11
//  Regs and Janus and Naiads
//  Reds and Janus
//  4 Janus
//  Red Regs and Hoplite

function level11()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 12500;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 11/15"
		
	spawner.addEnemyToWave(0, 3.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(0, 5.0, 1, "Regulus", 0);
	spawner.addEnemyToWave(0, 7.0, 1, "Regulus", 0);
	spawner.addEnemyToWave(0, 9.0, 1, "Regulus", 0);
	spawner.addEnemyToWave(0, 5.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(0, 10.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(0, 5.0, 1, "Janus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 4.0, 5, "Regulus", 2);
	spawner.addEnemyToWave(1, 4.0, 1, "Janus", 0);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 1, "Janus", 0);
	spawner.addEnemyToWave(2, 6.0, 1, "Janus", 0);
	spawner.addEnemyToWave(2, 9.0, 1, "Janus", 0);
	spawner.addEnemyToWave(2, 12.0, 1, "Janus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 5, "Regulus", 2);
	spawner.addEnemyToWave(3, 3.0, 1, "Hoplite", 0);

	
	return level;
}
