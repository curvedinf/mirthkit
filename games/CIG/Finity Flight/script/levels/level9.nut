//  Level 9
//  3 Naiads and Janus
//  Hoplite and Januses
//  Naiads and Hoplite
//  Regs
//  Regs and Naiads

function level9()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 10000;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 09/15"
		
	spawner.addEnemyToWave(0, 3.0, 3, "Naiad", 0);
	spawner.addEnemyToWave(0, 3.0, 1, "Janus", 0);

	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 1, "Hoplite", 0);
	spawner.addEnemyToWave(1, 5.0, 2, "Janus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 2, "Naiad", 0);
	spawner.addEnemyToWave(2, 4.0, 1, "Hoplite", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 5, "Regulus", 2);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 3.0, 4, "Regulus", 0);
	spawner.addEnemyToWave(4, 3.0, 2, "Regulus", 2);

	
	return level;
}
