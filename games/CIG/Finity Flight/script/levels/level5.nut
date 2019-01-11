//  Level 5
//  Regs and Naiads
//	 Regs and Hoplite
//  Naiads
//  Naiads and Hoplite

function level5HelpFunction(t)
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
		local textInfo = cursorText("Tips :", 25, 10, 400, 0);
		
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf",150);
		fillColor(1.0, 1.0, 1.0, 0.2);
		text("1", 70, 40, 400);
		text("2", 40, 200, 400);
		text("3", 50, 375, 400);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		font(::getArcadePrefix("FinityFlight")+"data/DejaVuSans.ttf",16);
		text("Destroying Gnats releases energy sparks.  Energy sparks recharge your shield on contact.", 130, 75, 500);

		text("The percentage in the upper right corner of the screen indicates how well you are doing in a level, based on score.\n\nDo well enough, and it can rise above 100%!", 130, 225, 500);
		
		text("If you can score over 100%, some levels reward you with different ships to fly!", 130, 400, 500);
		
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf", 30);
		fillColor(1.0, 1.0, 1.0, 0.3);
		cursorText("107%", 650, 305 - 75, 500, 0);
		fillColor(1.0, 1.0, 1.0, 1.0);
		cursorText("106%", 650, 345- 75, 500, 0);
		fillColor(1.0, 1.0, 1.0, 0.3);
		cursorText("105%", 650, 385 - 75, 500, 0);
		font(::getArcadePrefix("FinityFlight")+"data/DejaVuSans.ttf",16);
		
		local imageInfo = null;
		fillColor(0.3, 0.3, 1.0, 1.0);
		additiveBlending(true);
		
		local rotation = 0.0;
		modifyWindow(680 , 125, 0, 0, 1, rotation, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/flare.png" 0, 0)
			rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			modifyWindow(0,0,0,0,1,rotation + 90,false);
				rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			revertWindow();
		revertWindow();
		
		rotation = 45.0;
		modifyWindow(700 , 160, 0, 0, 1, rotation, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/flare.png" 0, 0)
			rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			modifyWindow(0,0,0,0,1,rotation + 90,false);
				rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			revertWindow();
		revertWindow();
		
		rotation = 20.0;
		modifyWindow(720 , 125, 0, 0, 1, rotation, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/flare.png" 0, 0)
			rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			modifyWindow(0,0,0,0,1,rotation + 90,false);
				rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			revertWindow();
		revertWindow();
		
		rotation = 20.0;
		modifyWindow(710 , 90, 0, 0, 1, rotation, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/flare.png" 0, 0)
			rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			modifyWindow(0,0,0,0,1,rotation + 90,false);
				rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			revertWindow();
		revertWindow();
		
		additiveBlending(false);
		fillColor(1.0, 1.0, 1.0, 1.0);
		
		imageInfo = image(getArcadePrefix("FinityFlight")+"data/Falcon.png",0, 0);
		modifyWindow(740, 500, 0, 0, 1, 0, false);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0]/2, imageInfo[1]/2);
		revertWindow();
		
	revertBrush();
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

function level5EndFunction()
{
	if (::level.scoreKeeper.getParPercent() >= 100.0)
	{
		guiMoveDown();
		guiNewStrip(330, 50, 0, 0, 0, 0);
		
		guiMoveRight();
		guiNewStrip(100, 140, 0, 0, 0, 0);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		local imageSize = image(getArcadePrefix("FinityFlight")+"data/CottonMouth.png", 0, 0);
		guiImage(getArcadePrefix("FinityFlight")+"data/CottonMouth.png",imageSize[0]/2,imageSize[1]/2,0);
		
		guiPreviousStrip();
		guiMoveDown();
		guiNewStrip(330, 100, 0, 0, 0, 0);
		
		font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
		guiText("COTTONMOUTH UNLOCKED", -1);
		
		::options.unlockedCottonMouth = true;
		store("FinityFlight","unlockedCottonMouth", "true");
	}
}

function level5()
{
	::options.gunsUnlocked = 3;
	local level = Level();
	level.scoreKeeper.parScore = 12000;
	local spawner = level.enemySpawner;
	
	level.helpFunction = level5HelpFunction;
	level.helpScreenOn = true;
	level.levelMessage = "Level 05/15"
	level.endFunction = level5EndFunction;
	

	spawner.addEnemyToWave(0, 3.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(0, 3.0, 1, "Regulus", 1);
	spawner.addEnemyToWave(0, 4.0, 2, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 3, "Regulus", 0);
	spawner.addEnemyToWave(1, 3.0, 1, "Hoplite", 0);
	spawner.addEnemyToWave(1, 6.0, 2, "Regulus", 1);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(2, 7.0, 2, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 2.0, 2, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 3.0, 3, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(5, 3.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(5, 3.0, 1, "Hoplite", 0);
	spawner.addEnemyToWave(5, 7.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(5, 11.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(5, 15.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(5, 19.0, 1, "Naiad", 1);
	
	return level;
}
