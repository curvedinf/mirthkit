//  Level 6
//  Red Regs (Type 2 Reguluses)
//  Reds and Naiad
//  Different Kinds of Regs
//  Naiads

function level6()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 20000;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 06/15"
		
	spawner.addEnemyToWave(0, 3.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 6.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 9.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 12.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 15.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 18.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 21.0, 1, "Regulus", 2);

	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 3, "Regulus", 2);
	spawner.addEnemyToWave(1, 5.0, 1, "Naiad", 0);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(2, 3.0, 2, "Regulus", 1);
	spawner.addEnemyToWave(2, 9.0, 2, "Regulus", 2);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(3, 3.0, 2, "Regulus", 1);
	spawner.addEnemyToWave(3, 3.0, 2, "Regulus", 2);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 5.0, 2, "Naiad", 0);
	spawner.addEnemyToWave(4, 9.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(4, 13.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(4, 17.0, 1, "Naiad", 0);
	
	return level;
}
