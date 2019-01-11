//  Level 15
//  2  Hoplites and 2 Mercuries
//  Reds and Naiads
//  Naiads and Januses
//  Hoplite and Reds and Naiads and Mercury

function level15EndFunction()
{
	if (::level.scoreKeeper.getParPercent() >= 100.0)
	{
		guiMoveDown();
		guiNewStrip(280, 6, 0, 0, 0, 0);
		
		guiMoveRight();
		guiNewStrip(100, 70, 0, 0, 0, 0);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		local imageSize = image(getArcadePrefix("FinityFlight")+"data/YellowJacket.png", 0, 0);
		guiImage(getArcadePrefix("FinityFlight")+"data/YellowJacket.png",imageSize[0]/2,imageSize[1]/2,0);
		
		guiPreviousStrip();
		guiMoveDown();
		guiNewStrip(280, 50, 0, 0, 0, 0);
		
		font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
		guiText("YELLOWJACKET UNLOCKED", -1);
		
		::options.unlockedYellowJacket = true;
		store("FinityFlight","unlockedYellowJacket", "true");
	}
}

function level15()
{
	local level = Level();
	level.scoreKeeper.parScore = 22500;
	local spawner = level.enemySpawner;
	level.levelMessage = "Final Level"
	level.endFunction = level15EndFunction;
		
	spawner.addEnemyToWave(0, 5.0, 2, "Hoplite", 0);
	spawner.addEnemyToWave(0, 6.0, 2, "Mercury", 0);

	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 2.0, 8, "Regulus", 2);
	spawner.addEnemyToWave(1, 5.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(1, 7.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(1, 9.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(1, 11.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(1, 13.0, 1, "Naiad", 0);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 4, "Naiad", 0);
	spawner.addEnemyToWave(2, 5.0, 2, "Janus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 6.0, 2, "Hoplite", 0);
	spawner.addEnemyToWave(3, 6.0, 5, "Regulus", 2);
	spawner.addEnemyToWave(3, 8.0, 3, "Naiad", 0);
	spawner.addEnemyToWave(3, 8.0, 2, "Mercury", 0);
	spawner.addEnemyToWave(3, 9.0, 2, "Janus", 0);

	
	return level;
}
