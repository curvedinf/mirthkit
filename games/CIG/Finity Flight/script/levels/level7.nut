//  Level 7
// Hoplite and Reds
//  Naiads and Reds
//  2 Hoplites and Reds
//  Reds

function level7()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 17000;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 07/15"
		
	spawner.addEnemyToWave(0, 4.0, 1, "Hoplite", 0);
	spawner.addEnemyToWave(0, 4.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(0, 8.0, 2, "Regulus", 2);

	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 2.0, 2, "Naiad", 2);
	spawner.addEnemyToWave(1, 3.0, 3, "Regulus", 2);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 1, "Hoplite", 2);
	spawner.addEnemyToWave(2, 5.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(2, 8.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(2, 11.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(2, 14.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(2, 17.0, 1, "Regulus", 2);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(3, 6.0, 4, "Regulus", 2);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 3.0, 3, "Regulus", 2);
	spawner.addEnemyToWave(4, 10.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(4, 10.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(4, 10.0, 2, "Regulus", 1);
	
	return level;
}
