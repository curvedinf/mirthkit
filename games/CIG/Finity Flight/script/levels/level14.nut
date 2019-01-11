//  Level 14
//  Reds
//  Naiads
//  Reds and Januses
//  Mercury and Hoplite
//  2 Mercuries
//  Januses

function level14()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 35500;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 14/15"

		
	spawner.addEnemyToWave(0, 3.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 3.5, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 4.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 4.5, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 5.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 5.5, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 6.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 6.5, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 7.0, 1, "Regulus", 2);
	spawner.addEnemyToWave(0, 7.5, 1, "Regulus", 2);

	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 3, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 3, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 3, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 3.0, 6, "Regulus", 2);
	spawner.addEnemyToWave(4, 6.0, 6, "Regulus", 0);
	spawner.addEnemyToWave(4, 8.0, 6, "Janus", 0);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(5, 3.0, 1, "Hoplite", 0);
	spawner.addEnemyToWave(5, 4.0, 1, "Mercury", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(6, 3.0, 1, "Mercury", 0);
	spawner.addEnemyToWave(6, 4.0, 1, "Mercury", 0);
	spawner.addEnemyToWave(6, 5.0, 1, "Mercury", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(7, 4.0, 4, "Janus", 0);


	
	return level;
}