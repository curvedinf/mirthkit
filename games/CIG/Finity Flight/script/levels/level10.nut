//  Level 10
//  Mercury
//  Regs and Mercury
//  Reds
//  Reds and Januses
//  Mercury and Naiads

function level10EndFunction()
{
	if (::level.scoreKeeper.getParPercent() >= 100.0)
	{
		guiMoveDown();
		guiNewStrip(270, 26, 0, 0, 0, 0);
		
		guiMoveRight();
		guiNewStrip(100, 70, 0, 0, 0, 0);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		local imageSize = image(getArcadePrefix("FinityFlight")+"data/Falcon.png", 0, 0);
		guiImage(getArcadePrefix("FinityFlight")+"data/Falcon.png",imageSize[0]/2,imageSize[1]/2,0);
		
		guiPreviousStrip();
		guiMoveDown();
		guiNewStrip(270, 100, 0, 0, 0, 0);
		
		font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
		guiText("FALCON UNLOCKED", -1);
		
		::options.unlockedFalcon = true;
		store("FinityFlight","unlockedFalcon", "true");
	}
}

function level10()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 18500;
	local spawner = level.enemySpawner;
	level.levelMessage = "Level 10/15"
	level.endFunction = level10EndFunction;
		
	spawner.addEnemyToWave(0, 3.0, 1, "Mercury", 0);

	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 5, "Regulus", 0);
	spawner.addEnemyToWave(1, 3.0, 1, "Mercury", 0);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 6, "Regulus", 2);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(3, 9.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(3, 12.0, 1, "Janus", 0);
	spawner.addEnemyToWave(3, 15.0, 2, "Regulus", 2);
	spawner.addEnemyToWave(3, 19.0, 1, "Janus", 1);
	spawner.addEnemyToWave(3, 21.0, 2, "Regulus", 2);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 3.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(4, 5.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(4, 7.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(4, 4.0, 1, "Mercury", 0);

	
	return level;
}
