//	Level 4
//	Bunch of Reguluses + Hoplite
//	Regs and Naiads
//	Another Hoplite + Naiads

function drawShield(angle, percentage, color)
{
	local currentAngle = [angle[0], angle[1]];
	local maxHealth = 100;
	local health = percentage;
	local thickness = 20;
	local radius = 40;
	local currentAngleDegrees = 180 - getDegrees2(currentAngle);
	local thicknessMod = 2;
	local offsetAngle = ((maxHealth - (0.0+health)) / maxHealth) * 180;
	local drawAngle = offsetAngle + currentAngleDegrees;
	local stopAngle = 360 - offsetAngle + currentAngleDegrees;
	local currentVertex = [0,0];
	local vert1 = [0, (radius - thickness*thicknessMod)];
	local vert2 = [0, (radius + thickness*thicknessMod)];
	vert1 = rotateDegrees2(vert1, drawAngle);
	vert2 = rotateDegrees2(vert2, drawAngle);
	drawAngle += 10;
	local vert3;
	image(getArcadePrefix("FinityFlight")+"data/shield.png",1,1);

	modifyBrush();
	fillColor(color[0],color[1],color[2],color[3]);
	additiveBlending(true);
	beginTriangles();
	local keepLooping = true;
	for(;keepLooping; drawAngle += 10)
	{
		if(drawAngle >= stopAngle)
		{
			drawAngle = stopAngle;
			keepLooping = false;
		}
		vert3 = [0, (radius - thickness*thicknessMod)];
		vert3 = rotateDegrees2(vert3, drawAngle);
		textureCoord(0,0);
		vertex(vert1[0], vert1[1]);
		textureCoord(0,1);
		vertex(vert2[0], vert2[1]);
		textureCoord(0,0);
		vertex(vert3[0], vert3[1]);
		vert1 = vert3;
		vert3 = [0, (radius + thickness*thicknessMod)];
		vert3 = rotateDegrees2(vert3, drawAngle);
		textureCoord(0,0);
		vertex(vert1[0], vert1[1]);
		textureCoord(0,1);
		vertex(vert2[0], vert2[1]);
		textureCoord(0,1);
		vertex(vert3[0], vert3[1]);
		vert2 = copy2(vert3);
	}
	endTriangles();
	revertBrush();
}

function level4HelpFunction(t)
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
		local textInfo = cursorText("Boost :", 25, 10, 400, 0);
		
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf",150);
		fillColor(1.0, 1.0, 1.0, 0.2);
		text("1", 70, 40, 400);
		text("2", 40, 200, 400);
		text("3", 50, 375, 400);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		font(::getArcadePrefix("FinityFlight")+"data/DejaVuSans.ttf",16);
		text("Hold right click to activate Boost mode. \n\nBoost only lasts as long as you have boost energy, indicated at the bottom of the screen.", 130, 75, 500);

		text("In Boost mode, you can fire in any direction without changing course.\n\nIn addition, your shield is invulnerable and reflects enemy bullets!", 130, 225, 400);
		
		text("When exiting Boost mode, you recieve burst of speed.  You will not be able to activate Boost again for a few seconds.", 130, 400, 500);
		
		local imageInfo = null;
		modifyWindow(725, 125, 0, 0, 1, 0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/RightMouseButton.png",0, 0);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0], imageInfo[1]);
		revertWindow();
		
		local shipPos = [615, 340];
		modifyWindow(shipPos[0], shipPos[1], 0, 0, 1, 65.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Raptor.png",0, 0);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0]/2, imageInfo[1]/2);
		revertWindow();
		modifyWindow(shipPos[0] + 10, shipPos[1] - 38, 0, 0, 1, -25.0, false);
			local color = [0.0,1.0,0.0,1.0];
			drawShield([1,0], 100, color);
		revertWindow();
		
		local shipPos = [615, 340];
		
		local boxSize = [400, 320];
		modifyWindow(shipPos[0] + 10, shipPos[1] - 35, boxSize[0], boxSize[1], 1, 65.0, true);
			additiveBlending(true);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/track.png",0, 0);
			rect(boxSize[0]/2 - imageInfo[0]/4, -imageInfo[1]/2 +boxSize[1]/2, imageInfo[0]/2, imageInfo[1]/2);
			additiveBlending(false);
		revertWindow();
	
		shipPos = [745, 490];
		modifyWindow(shipPos[0], shipPos[1], 0, 0, 1, 0.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Raptor.png",0, 0);
			rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0]/2, imageInfo[1]/2);
		revertWindow();
		local boxSize = [200, 200];
		modifyWindow(shipPos[0]-55, shipPos[1], boxSize[0], boxSize[1], 1, 0.0, true);
			/*lineColor(1.0, 1.0, 1.0, 1.0, 1);
			line(1, 1, 200, 1);
			line(200, 1, 199, 199);
			line(200, 200, 0, 200);
			line(0, 200, 0, 0);
			lineColor(0.0,0.0, 0.0, 0.0, 1);	*/

			modifyWindow(250, 105, 0, 0, 1, 0.0, false);
				imageInfo = image(getArcadePrefix("FinityFlight")+"data/flare.png",0, 0);
				imageInfo = scale2(imageInfo, 2.0);
				rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0]/2, imageInfo[1]/2);
			revertWindow();
			modifyWindow(260, 105, 0, 0, 1, 0.0, false);
				rect(-imageInfo[0]/2, -imageInfo[1]/2, imageInfo[0]/2, imageInfo[1]/2);
			revertWindow();
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

function level4EndFunction()
{
	if (true)
	{
		guiMoveDown();
		guiNewStrip(330, 16, 0, 0, 0, 0);
		
		guiMoveRight();
		guiNewStrip(100, 140, 0, 0, 0, 0);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		local imageSize = image(getArcadePrefix("FinityFlight")+"data/Rockets.png", 0, 0);
		guiImage(getArcadePrefix("FinityFlight")+"data/Rockets.png",imageSize[0],imageSize[1],0);
		
		guiPreviousStrip();
		guiMoveDown();
		guiNewStrip(330, 50, 0, 0, 0, 0);
		
		font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
		guiText("ROCKET UNLOCKED", -1);
		
		if(::options.gunsUnlocked < 3)
		{
			::options.gunsUnlocked = 3;
			store("FinityFlight","gunsUnlocked", "3");
		}
	}
}


function level4()
{
	::options.gunsUnlocked = 2;
		
	local level = Level();
	level.scoreKeeper.parScore = 15000;
	local spawner = level.enemySpawner;
	
	level.helpFunction = level4HelpFunction;
	level.helpScreenOn = true;
	level.levelMessage = "Level 04/15"
	level.endFunction = level4EndFunction;
	

	
	spawner.addEnemyToWave(0, 3.0, 1, "Hoplite", 0);
	spawner.addEnemyToWave(0, 6.0, 5, "Regulus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 3.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(1, 3.0, 2, "Naiad", 1);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 3.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(2, 3.0, 2, "Regulus", 1);
	spawner.addEnemyToWave(2, 3.0, 2, "Regulus", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(3, 3.0, 3, "Regulus", 0);
	spawner.addEnemyToWave(3, 3.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(3, 8.0, 1, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(4, 2.0, 1, "Hoplite", 0);
	spawner.addEnemyToWave(4, 3.0, 3, "Regulus", 0);
	spawner.addEnemyToWave(4, 3.0, 3, "Regulus", 1);
	
	return level;
}
