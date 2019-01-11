//  Level 3
//	Two Naiads and Reguluses
//	Variations on that.

function level3HelpFunction(t)
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
		local textInfo = cursorText("Weapons :", 25, 10, 400, 0);
		
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf",150);
		fillColor(1.0, 1.0, 1.0, 0.2);
		text("1", 70, 40, 400);
		text("2", 40, 200, 400);
		text("3", 50, 375, 400);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		font(::getArcadePrefix("FinityFlight")+"data/DejaVuSans.ttf",16);
		text("Middle click or press TAB to switch weapons.", 130, 75, 500);

		text("Double click the left mouse button to activate secondary fire. Each weapon has a different secondary fire.", 130, 225, 500);
		
		text("Secondary Fire needs time to recharge.\nThe weapon icon will flash when secondary fire is available.", 130, 400, 500);
		
		local imageInfo = null;
		modifyWindow(725, 125, 0, 0, 1, 0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/MiddleMouseButton.png",0, 0);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0], imageInfo[1]);
		revertWindow();
		
		modifyWindow(725, 280, 0, 0, 1, 0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/LeftDoubleClick.png",0, 0);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0], imageInfo[1]);
		revertWindow();
		
		modifyWindow(725, 450, 0, 0, 1, 0, false);
			additiveBlending(true);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Vulcan.png",0, 0);
			fillColor(1.0, 0.0,0.0, 1.0);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0], imageInfo[1]);
			image("", 0, 0);
			fillColor(1.0, 1.0,1.0, 0.0);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0], imageInfo[1]);
			fillColor(1.0, 1.0,1.0, 1.0);
			additiveBlending(false);
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
	
function level3()
{
	::options.gunsUnlocked = 2;
	
	local level = Level();
	level.scoreKeeper.parScore = 8000;
	local spawner = level.enemySpawner;
	
	level.helpFunction = level3HelpFunction;
	level.helpScreenOn = true;
	level.levelMessage = "Level 03/15"
	
	
	
	spawner.addEnemyToWave(0, 3.0, 2, "Naiad", 0);
	spawner.addEnemyToWave(0, 3.0, 1, "Regulus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(1, 9.0, 2, "Regulus", 1);
	spawner.addEnemyToWave(1, 16.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(1, 16.0, 2, "Regulus", 1);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(2, 3.0, 2, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 2, "Naiad", 0);
	
	return level;
}
