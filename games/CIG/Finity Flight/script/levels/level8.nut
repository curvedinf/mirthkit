//  Level 8
//  Janus
//	2 Januses
//  Regs
//  Regs and Januses
//  2 Naiads and 2 Januses

function level8()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 14000;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 08/15"
		
	spawner.addEnemyToWave(0, 4.0, 1, "Janus", 0);

	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 2, "Janus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 2, "Regulus", 1);
	spawner.addEnemyToWave(2, 3.0, 2, "Regulus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 6, "Regulus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 3.0, 6, "Regulus", 1);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(5, 2.0, 3, "Regulus", 0);
	spawner.addEnemyToWave(5, 2.0, 3, "Regulus", 1);
	spawner.addEnemyToWave(5, 2.0, 1, "Janus", 0);
	
	return level;
}
