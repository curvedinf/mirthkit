//  Level 1
//	Reguluses in front, then in back, then both.
//	Then more Reguluses

function level1HelpFunction(t)
{
	cursor(1);
	
	image("", 0, 0);
	//fillColor(0.0, 0.0, 0.0, 0.5);
	//rect(0, 0, ::screenSize[0], ::screenSize[1]);
	
	modifyWindow((screenSize[0] + (screenSize[0]%2))/2, (screenSize[1] + (screenSize[1]%2))/2, 800, 600, 1, 0, false);	//Put us in an 800x600 box!
	modifyBrush();
	
		fillColor(0.0, 0.0, 0.0, 0.7);
		rect(0, 0, 800, 600);
			
		lineColor(1.0, 1.0, 1.0, 1.0, 1);
		line(25, 50, 775, 50);
		line(25, 200, 775, 200);
		line(25, 375, 775, 375);
		line(25, 550, 775, 550);
		lineColor(0.0,0.0, 0.0, 0.0, 1);	
			
		
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf",30);
		fillColor(1.0, 1.0, 1.0, 1.0);
		local textInfo = cursorText("Rules :", 25, 10, 400, 0);
		
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf",150);
		fillColor(1.0, 1.0, 1.0, 0.2);
		text("1", 70, 40, 400);
		text("2", 40, 200, 400);
		text("3", 50, 375, 400);

		fillColor(1.0, 1.0, 1.0, 1.0);
		font(::getArcadePrefix("FinityFlight")+"data/DejaVuSans.ttf",16);
		text("Use your ship to destroy all the enemies in each level.", 130, 75, 500);

		text("Left click or press SPACE to fire your weapon.", 130, 225, 500);
		
		text("Gnats do not have to be desroyed to finish a level.", 130, 400, 500);
		
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		
		local  imageInfo = image(getArcadePrefix("FinityFlight")+"data/Raptor.png",0, 0);
		modifyWindow(750, 150, 0, 0, 1, 0, false);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0]/2, imageInfo[1]/2);
		revertWindow();
		
		modifyWindow(725, 280, 0, 0, 1, 0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/LeftMouseButton.png",0, 0);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0], imageInfo[1]);
		revertWindow();
	
		modifyWindow(730 , 440, 0, 0, 1, 60.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Gnat.png" 0, 0)
			rect(-imageInfo[0]/2 * 2, -imageInfo[1]/2 * 2, imageInfo[0]/2 * 2, imageInfo[1]/2 * 2);
		revertWindow();
		modifyWindow(650 , 460, 0, 0, 1, 90.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Gnat.png" 0, 0)
			rect(-imageInfo[0]/2 * 2, -imageInfo[1]/2 * 2, imageInfo[0]/2 * 2, imageInfo[1]/2 * 2);
		revertWindow();
		modifyWindow(700 , 480, 0, 0, 1, 100.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Gnat.png" 0, 0)
			rect(-imageInfo[0]/2 * 2, -imageInfo[1]/2 * 2, imageInfo[0]/2 * 2, imageInfo[1]/2 * 2);
		revertWindow();
		modifyWindow(680 , 500, 0, 0, 1, 80.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Gnat.png" 0, 0)
			rect(-imageInfo[0]/2 * 2, -imageInfo[1]/2 * 2, imageInfo[0]/2 * 2, imageInfo[1]/2 * 2);
		revertWindow();
		

	revertWindow();
	
	//if (!::level.controls.isButtonDown(1))
	if (!mouseButton(1))
	{
		if (helpExitButtonDownLastFrame)
		{
			::level.helpScreenOn = false;
			lineColor(0.0, 0.0, 0.0, 0.0, 0);
			cursor(0);
		}
	}
	else if (::level.playing)
	{
		helpExitButtonDownLastFrame = true;
	}
}

function level1()
{
	::options.gunsUnlocked = 1;
	
	local level = Level();
	level.scoreKeeper.parScore = 10000;
	local spawner = level.enemySpawner;
	
	level.levelMessage = "Level 01/15"
	
	level.helpFunction = level1HelpFunction;
	level.helpScreenOn = true;
	
	
	
	
	//spawner.addEnemyToWave(0, 0.0, 1, "Janus", 0);
	//spawner.addEnemyToWave(0, 0.0, 1, "Janus", 0);
	
	spawner.addEnemyToWave(0, 5.0, 1, "Regulus", -1);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 0.0, 1, "Regulus", -1);
	spawner.addEnemyToWave(1, 3.0, 1, "Regulus", -1);
	spawner.addEnemyToWave(1, 6.0, 1, "Regulus", -1);
	spawner.addEnemyToWave(1, 9.0, 1, "Regulus", -1);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 0.0, 2, "Regulus", -1);
	spawner.addEnemyToWave(2, 6.0, 4, "Regulus", -1);
	
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 0.0, 2, "Regulus", -1);
	spawner.addEnemyToWave(3, 0.0, 2, "Regulus", -1);
	spawner.addEnemyToWave(3, 7.0, 1, "Regulus", -1);
	spawner.addEnemyToWave(3, 9.0, 1, "Regulus", -1);
	spawner.addEnemyToWave(3, 11.0, 1, "Regulus", -1);
	spawner.addEnemyToWave(3, 13.0, 1, "Regulus", -1);
	spawner.addEnemyToWave(3, 15.0, 1, "Regulus", -1);
	spawner.addEnemyToWave(3, 17.0, 1, "Regulus", -1);
	
	return level;
}
