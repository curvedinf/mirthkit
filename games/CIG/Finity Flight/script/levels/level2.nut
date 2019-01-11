//  Level 2
//	Reguluses in front and back
//	Naiad with Reguluses
//	Another Naiad + more Reguluses

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

function level2HelpFunction(t)
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
		local textInfo = cursorText("Shields :", 25, 10, 400, 0);
		
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf",150);
		fillColor(1.0, 1.0, 1.0, 0.2);
		text("1", 70, 40, 400);
		text("2", 40, 200, 400);
		text("3", 50, 375, 400);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		font(::getArcadePrefix("FinityFlight")+"data/DejaVuSans.ttf",16);
		text("Your shield protects you from enemy shots.", 130, 75, 500);

		text("As your shield is hit, it opens up.", 130, 225, 500);
		
		text("If a shot gets past your shield, you will be destroyed!", 130, 400, 500);
		
		fillColor(1.0, 1.0, 1.0, 1.0);
		
		local  imageInfo = null;
		local shipPos = [675, 90];
		modifyWindow(shipPos[0], shipPos[1], 0, 0, 1, 0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Raptor.png",0, 0);
			rect(0, 0, imageInfo[0]/2, imageInfo[1]/2);
		revertWindow();
		modifyWindow(shipPos[0]+30, shipPos[1] + 35, 0, 0, 1, 0, false);
			local color = [0.3,0.3,1.0,1.0];
			drawShield([1,0], 100, color);
		revertWindow();
		
		shipPos = [675, 250];
		modifyWindow(shipPos[0], shipPos[1], 0, 0, 1, 0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Raptor.png",0, 0);
			rect(0, 0, imageInfo[0]/2, imageInfo[1]/2);
		revertWindow();
		modifyWindow(shipPos[0]+30, shipPos[1] + 35, 0, 0, 1, -90.0, false);
			local color = [0.3,0.3,1.0,1.0];
			drawShield([1,0], 70, color);
		revertWindow();
		
		shipPos = [715, 430];
		modifyWindow(shipPos[0], shipPos[1], 0, 0, 1, 90.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Raptor.png",0, 0);
			rect(0, 0, imageInfo[0]/2, imageInfo[1]/2);
		revertWindow();
		modifyWindow(shipPos[0] - 35, shipPos[1] + 30, 0, 0, 1, 0, false);
			local color = [0.3,0.3,1.0,1.0];
			drawShield([1,0], 70, color);
		revertWindow();
		
		local color = [1.0, 0.0, 0.0];
		modifyWindow(shipPos[0] + 40, shipPos[1] + 30, 0, 0, 1, 90.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/BlasterShot2bottom.png", 1, 1);
			additiveBlending(false)
			fillColor(color[0],color[1],color[2],1.0);
			imageInfo = scale2(imageInfo, 0.75);
			rect(-imageInfo[0]/2,-imageInfo[1]/2,imageInfo[0],imageInfo[1]);
			
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/BlasterShot2top.png", 1, 1);
			additiveBlending(true)
			fillColor(color[0],color[1],color[2],1.0);
			imageInfo = scale2(imageInfo, 0.75);
			rect(-imageInfo[0]/2,-imageInfo[1]/2,imageInfo[0],imageInfo[1]);
		revertWindow();
		

			/*
		local xMod = -50;
		for (local i = 0; i < 3; i++)
		{
			local location = [650 + xMod,450];
			if (i == 1)
				location = [665 + xMod, 465];
			if (i == 2)
				location = [680 + xMod, 455];
			modifyWindow(location[0],location[1],0,0,1,level.helpScreenTime*20.0 + 90 + i * 90,false);
			modifyBrush();
				//additiveBlending(true);
				fillColor(0.3,0.3,1.0,1.0);
				imageInfo = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
				rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			revertWindow();
			modifyWindow(location[0],location[1],0,0,1,-level.helpScreenTime*20.0 + 90 + i * 90,false);
				rect(-imageInfo[0]/4,-imageInfo[1]/4,imageInfo[0]/2,imageInfo[1]/2);
			revertBrush();
			revertWindow();
		}
		
		modifyWindow(260, 449, 0, 0, 1, 90.0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Gnat.png" 0, 0)
			rect(0, 0, imageInfo[0], imageInfo[1]);
		revertWindow();
		
		modifyWindow(540, 515, 0, 0, 1, 0, false);
			imageInfo = image(getArcadePrefix("FinityFlight")+"data/Raptor.png",0, 0);
			rect(0, 0, imageInfo[0]/2, imageInfo[1]/2);
		revertWindow();
		
		modifyWindow(570, 545, 0, 0, 1, 0, false);
		color = [0.3,0.3,1.0,0.7];
		drawShield([1,0], 100, color);
		revertWindow();
		*/
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

function level2EndFunction()
{
	if (true)
	{
		guiMoveDown();
		guiNewStrip(330, 16, 0, 0, 0, 0);
		
		guiMoveRight();
		guiNewStrip(100, 140, 0, 0, 0, 0);
		
		fillColor(0.6, 0.0, 1.0, 1.0);
		local imageSize = image(getArcadePrefix("FinityFlight")+"data/LaserCannon.png", 0, 0);
		guiImage(getArcadePrefix("FinityFlight")+"data/LaserCannon.png",imageSize[0],imageSize[1],0);
		fillColor(1.0, 1.0, 1.0, 1.0);
		
		guiPreviousStrip();
		guiMoveDown();
		guiNewStrip(330, 50, 0, 0, 0, 0);
		
		font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
		guiText("LCANNON UNLOCKED", -1);
		
		if(::options.gunsUnlocked  < 2)
		{
			::options.gunsUnlocked = 2;
			store("FinityFlight","gunsUnlocked", "2");
		}
	}
}

function level2()
{
	::options.gunsUnlocked = 1;
	
	local level = Level();
	level.scoreKeeper.parScore = 8500;
	local spawner = level.enemySpawner;
	
	level.helpFunction = level2HelpFunction;
	level.helpScreenOn = true;
	level.levelMessage = "Level 02/15"
	level.endFunction = level2EndFunction;
	
	
	
	spawner.addEnemyToWave(0, 3.0, 2, "Regulus", 1);
	spawner.addEnemyToWave(0, 8.0, 2, "Regulus", 1);
	spawner.addEnemyToWave(0, 8.0, 1, "Regulus", 0);

	spawner.waves.append([]);
	spawner.addEnemyToWave(1, 0.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(1, 2.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(1, 6.0, 1, "Regulus", 0);
	spawner.addEnemyToWave(1, 10.0, 1, "Regulus", 0);
	spawner.addEnemyToWave(1, 13.0, 1, "Regulus", 0);
	spawner.addEnemyToWave(1, 16.0, 1, "Regulus", 0);
	spawner.addEnemyToWave(1, 19.0, 1, "Naiad", 0);
	
	spawner.waves.append([]);
	spawner.addEnemyToWave(2, 0.0, 1, "Naiad", 0);
	spawner.addEnemyToWave(2, 0.0, 2, "Regulus", 0);
	spawner.addEnemyToWave(2, 0.0, 2, "Regulus", 1);
	
	
	
	return level;
}
