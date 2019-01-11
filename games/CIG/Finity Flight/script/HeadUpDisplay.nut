class HeadUpDisplay
{
	//These variables represent what PERCENTAGE across the screen
	// that each location is.  The top left corner of the screen
	// is [0, 0].  The bottom right is [100, 100].
	
	odometerStart = null;
	odometerDisplay = 0;
	odometerTarget = 0;
	
	totalScoreOutPos = null;			//Unlike the others, these are right justified positions.
	totalScoreInPos = null;			//
	totalScoreDisplayPos = null;	//
	totalScoreTargetPos = null;		//
	
	totalScoreDisplay = 0;
	totalScoreTarget = 0;
	totalScoreString = "";
	totalScoreLifetime = 1.5;
	totalScoreTimer = 10.0;
	
	streakWindowStart = null;
	streakWindowEnd = null;
	streakProgressStart = null;
	streakProgressEnd = null;
	
	escapeWindowStart = null;
	escapeWindowEnd = null;
	
	weaponStart = null;
	weaponSinSeed = 0;
	
	boostMeterWidth = 70.0;
	boostMeterY = 80.0;
	boostMeterAnimation = 0.0;
	
	boostRedAnimation = 0;
	
	constructor()
	{
		odometerStart = [90.0, 5.0];
		
		totalScoreOutPos = [80.0, 5.0];
		totalScoreInPos = [100.0, 5.0];
		totalScoreTargetPos = [100.0, 5.0];
		totalScoreDisplayPos = [100.0, 5.0];
		
		streakWindowStart = [90.0, 90.0];
		streakWindowEnd = [99.0, 99.0];
		
		streakProgressStart = [90.0, 85.0]
		streakProgressEnd = [99.0, 89.5];
		
		escapeWindowStart = [60.0, 95.0];
		escapeWindowEnd = [40.0, 99.0];
		
		weaponStart = [1.0, 1.0];
	}
	
	function update(t)
	{
		return true;
	
	}
	
	function draw(t)
	{
		modifyBrush();
		local scoreKeep = ::level.scoreKeeper;
		
		// Weapon selected
		
		local currentWeapon = ::level.player.mods[0]["pilot"].currentWeaponActive;
		local secondaryWeaponTimer = ::level.player.mods[0]["pilot"].secondaryWeaponRecharge;
		local sinPercent = (sin(weaponSinSeed) + 1.0) / 2.0;
		local weaponSize = [0,0];
		local weaponImage = null;
		local weaponImageColor = null;
		
		if(currentWeapon==0) 
		{
			weaponImage = getArcadePrefix("FinityFlight")+"data/Vulcan.png";
			weaponImageColor = [1.0, 0.0, 0.0, 1.0];
		} 
		else if(currentWeapon==1)  
		{	
			weaponImage = getArcadePrefix("FinityFlight")+"data/LaserCannon.png";
			weaponImageColor = [0.6, 0.0, 1.0, 1.0];
		} 
		else if(currentWeapon==2) 
		{
			weaponImage = getArcadePrefix("FinityFlight")+"data/Rockets.png";
			weaponImageColor = [1.0, 1.0, 1.0, 1.0];
		}
		local wstart = screenPercentToPixel(weaponStart);
		weaponSize = image(weaponImage,1,1);
		image("",0,0);
		if (secondaryWeaponTimer <= 0.0 && !::level.helpScreenOn)
		{
			weaponSinSeed += t * 8;
			fillColor(1, 1, 1, sinPercent * 0.3);
		}
		else
		{
			weaponSinSeed = 0;
			fillColor(weaponImageColor[0], weaponImageColor[1], weaponImageColor[2], 0.0);
		}
		additiveBlending(true);
		rect(wstart[0],wstart[1],weaponSize[0],weaponSize[1]);
		
		weaponSize = image(weaponImage,1,1);
		fillColor(weaponImageColor[0], weaponImageColor[1], weaponImageColor[2], weaponImageColor[3]);
		rect(wstart[0],wstart[1],weaponSize[0],weaponSize[1]);
		additiveBlending(false);
		
		image("", false, false);
		
		//Odometer
		local odometerLoc = screenPercentToPixel(odometerStart);
		odometerTarget = scoreKeep.getParPercent();
		odometerDisplay = ((odometerTarget - odometerDisplay) * 3.0 * t) + odometerDisplay;
		
		local curPercent = floor(odometerDisplay + 0.0);
		local extraPadding = ((odometerDisplay - floor(odometerDisplay)) * 40.0);
		
		local tempLoc = odometerLoc[1] - 60.0;
		for (local i = -1; i < 3; i++, tempLoc += 40)
		{
			local thisNumber = curPercent - i;
			
			local tempAlpha = 1.0;
			local distanceToTarget = abs(odometerLoc[1] - (tempLoc + extraPadding));
			//Make numbers further from the "center" more alphaed.
			if (  distanceToTarget > 0)
				 tempAlpha = 15.0 / distanceToTarget;
			
			fillColor(1, 1, 1.0, tempAlpha);
			font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf", 30);
			if(thisNumber >= 0 && ::level.levelNumber != ::totalLevels)
				cursorText(thisNumber.tostring() + "%", odometerLoc[0],tempLoc + extraPadding,10,0,0);
		}
		
		//Total Score Display Window
		if (floor(totalScoreDisplay) == floor(totalScoreTarget))  
			totalScoreTimer -= t;
		if (totalScoreTimer <= 0)
		{
			totalScoreTimer = 0;
			totalScoreTargetPos = totalScoreInPos;
			totalScoreString = "";
		}
		
		
		totalScoreDisplay = ((totalScoreTarget - totalScoreDisplay) * 4.0 * t) + totalScoreDisplay;
		if ((totalScoreTarget - totalScoreDisplay) < 0.9999)
			totalScoreDisplay = totalScoreTarget;
		
		totalScoreDisplayPos[0] = ((totalScoreTargetPos[0] - totalScoreDisplayPos[0]) * 5.5 * t) + totalScoreDisplayPos[0];
		
		local totalScoreLoc = screenPercentToPixel(totalScoreDisplayPos);
		
		//Get information to right align text
		fillColor(0, 0, 0, 0);	
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf", 20);
		local scoreTextInfo = cursorText(floor(totalScoreDisplay) + "", 0, 0, 200, 0, 0);
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf", 15);
		local stringTextInfo = cursorText(totalScoreString, 0, 0, 400, 0, 0);
		
		//Alpha the total score based on how close it is to end position.
		local textAlpha = 1.0;
		local distanceToTarget = abs(totalScoreOutPos[0] - totalScoreDisplayPos[0]);
		if (distanceToTarget > 0)
			textAlpha = (3.0 / distanceToTarget) ;
		if (textAlpha < 0.2)
			textAlpha = 0;
		
		fillColor(1, 1, 1, textAlpha);	
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf", 20);
		cursorText(floor(totalScoreDisplay) + "", totalScoreLoc[0] - scoreTextInfo[0], totalScoreLoc[1], 300, 0, 0);
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf", 15);
		cursorText(totalScoreString, totalScoreLoc[0] - stringTextInfo[0], totalScoreLoc[1] + 30, 400, 0, 0);
		
			
		/*
		 //Streak Multiplier Window
		local streakWindowStartLoc = screenPercentToPixel(streakWindowStart);
		local streakWindowEndLoc = screenPercentToPixel(streakWindowEnd);
		local streakWindowWidthHeight = [streakWindowEndLoc[0] - streakWindowStartLoc[0], streakWindowEndLoc[1] - streakWindowStartLoc[1]]
		fillColor(0.0, 0.0, 0.0, 0.5);
		rect(streakWindowStartLoc[0], streakWindowStartLoc[1], streakWindowWidthHeight[0], streakWindowWidthHeight[1]);
		
		//StreakMultiplier
		fillColor(1.0, 1.0, 1.0, 0.0);		//Draw a full-alpha'd version first to determine string width.
		local textStats = cursorText("x" + scoreKeep.streakMultiplier, 0, 0, 3, 0, 0);
		local textStartX = streakWindowStartLoc[0] + (streakWindowWidthHeight[0] / 2.0) - textStats[0] / 2.0;
		local textStartY = streakWindowStartLoc[1] + (streakWindowWidthHeight[1] / 2.0) - textStats[2] / 2.0;
		fillColor(1.0, 1.0, 1.0, 1.0);		//Draw the real version.
		cursorText("x" + scoreKeep.streakMultiplier, textStartX, textStartY, 3, 0, 0);
		
		
		//Streak Progress Window
		local streakProgressStartLoc = screenPercentToPixel(streakProgressStart);
		local streakProgressEndLoc = screenPercentToPixel(streakProgressEnd);
		local streakProgressWidthHeight = [streakProgressEndLoc[0] - streakProgressStartLoc[0], streakProgressEndLoc[1] - streakProgressStartLoc[1]]
		fillColor(0.0, 0.0, 0.0, 0.5);
		rect(streakProgressStartLoc[0], streakProgressStartLoc[1], streakProgressWidthHeight[0], streakProgressWidthHeight[1]);
		
		//The progress bar.
		local streakBarStart = [streakProgressStartLoc[0] + 3.0, streakProgressStartLoc[1] + 3.0];
		local streakBarWidthHeight = [streakProgressWidthHeight[0] - 6.0, streakProgressWidthHeight[1] - 6.0];
		
		local streakBarPercentage = 1.0;
		if (scoreKeep.streakMultiplier < scoreKeep.nextStreakKillRequirement.len() + 1)
			streakBarPercentage = (scoreKeep.currentStreakKills * 1.0 / scoreKeep.nextStreakKillRequirement[scoreKeep.streakMultiplier - 1]);
		
		streakBarWidthHeight[0] *= streakBarPercentage;
		
		additiveBlending(true);
		fillColor(0.1, 0.1, 0.8, 1.0);
		rect(streakBarStart[0], streakBarStart[1], streakBarWidthHeight[0], streakBarWidthHeight[1]);
		*/
		
		revertBrush();
		
	
		// Boost-meter
		
		local boosting = ::level.player.mods[0]["pilot"].boosting;
		if(boosting)
		{
			boostMeterAnimation += t*2;
			
			fillColor(1,1,1,1);
			
			local percentFilled = ::level.player.mods[0]["pilot"].boostEnergy/100.0;
			local percentStarted = ::level.player.mods[0]["pilot"].boostStartEnergy/100.0;
			local percentDropped = percentStarted - percentFilled;
			
			local boostStart = screenPercentToPixel([(100-boostMeterWidth)/2,boostMeterY]);
			local boostEnd = [boostStart[0]+(::screenSize[0]*(boostMeterWidth/100.0))*percentFilled,boostStart[1]+32];
			
			image(getArcadePrefix("FinityFlight")+"data/loadybarBase.png",1,1);
			rect(boostStart[0],boostStart[1],::screenSize[0]*(boostMeterWidth/100.0),32)
			
			image(getArcadePrefix("FinityFlight")+"data/loadybar.png",1,1);
			beginTriangles();
			textureCoord(boostMeterAnimation,0);
			vertex(boostStart[0],boostStart[1]);
			textureCoord(boostMeterAnimation+(0.3*percentFilled),0);
			vertex(boostEnd[0],boostStart[1]);
			textureCoord(boostMeterAnimation,1);
			vertex(boostStart[0],boostEnd[1]);
			
			textureCoord(boostMeterAnimation+(0.3*percentFilled),0);
			vertex(boostEnd[0],boostStart[1]);
			textureCoord(boostMeterAnimation,1);
			vertex(boostStart[0],boostEnd[1]);
			textureCoord(boostMeterAnimation+(0.3*percentFilled),1);
			vertex(boostEnd[0],boostEnd[1]);
			endTriangles();
			
			modifyBrush();
			local boostStartStart = [boostEnd[0],boostStart[1]];
			local boostStartEnd = [boostStart[0]+(::screenSize[0]*(boostMeterWidth/100.0))*
									(percentFilled+percentDropped-boostRedAnimation),boostStart[1]+32];
			fillColor(1,0.3,0.3,1);
			beginTriangles();
			textureCoord(boostMeterAnimation,0);
			vertex(boostStartStart[0],boostStartStart[1]);
			textureCoord(boostMeterAnimation+(0.3*percentFilled),0);
			vertex(boostStartEnd[0],boostStartStart[1]);
			textureCoord(boostMeterAnimation,1);
			vertex(boostStartStart[0],boostStartEnd[1]);
			
			textureCoord(boostMeterAnimation+(0.3*percentFilled),0);
			vertex(boostStartEnd[0],boostStartStart[1]);
			textureCoord(boostMeterAnimation,1);
			vertex(boostStartStart[0],boostStartEnd[1]);
			textureCoord(boostMeterAnimation+(0.3*percentFilled),1);
			vertex(boostStartEnd[0],boostStartEnd[1]);
			endTriangles();
			revertBrush();
			
			if(t!=0)
				boostRedAnimation += (percentDropped-boostRedAnimation)/20.0;
			
			local size = image(getArcadePrefix("FinityFlight")+"data/loadybarCap.png",1,1);
			rect(boostStart[0]-size[0],boostStart[1],size[0],size[1]);
			rect(::screenSize[0]*(boostMeterWidth/100.0)+boostStart[0],boostEnd[1]-size[1],size[0],size[1]);
		} else {
			boostRedAnimation = 0;
		}
		
		if(::level.levelNumber == ::totalLevels)
		{
			font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf", 15);
			 //Press Escape to Exit Window
			local escapeWindowStartLoc = screenPercentToPixel(escapeWindowStart);
			local escapeWindowEndLoc = screenPercentToPixel(escapeWindowEnd);
			local escapeWindowWidthHeight = [escapeWindowEndLoc[0] - escapeWindowStartLoc[0], escapeWindowEndLoc[1] - escapeWindowStartLoc[1]]
			fillColor(0.0, 0.0, 0.0, 0.5);
			rect(escapeWindowStartLoc[0], escapeWindowStartLoc[1], escapeWindowWidthHeight[0], escapeWindowWidthHeight[1]);
		
			//Escape Text
			fillColor(1.0, 1.0, 1.0, 0.0);		//Draw a full-alpha'd version first to determine string width.
			local textStats = cursorText("Hit Esc to Exit", 0, 0, 500, 0, 0);
			local textStartX = escapeWindowStartLoc[0] + (escapeWindowWidthHeight[0] / 2.0) - textStats[0] / 2.0;
			local textStartY = escapeWindowStartLoc[1] + (escapeWindowWidthHeight[1] / 2.0) - textStats[2] / 2.0;
			fillColor(1.0, 1.0, 1.0, 1.0);		//Draw the real version.
			cursorText("Hit Esc to Exit", textStartX, textStartY, 500, 0, 0);	
		}
	}
	
	function screenPercentToPixel(screenPercent)
	{
		return [::screenSize[0] * (screenPercent[0] / 100.0), ::screenSize[1] * (screenPercent[1] / 100.0)]; 
	}
	
	function addHUDScore(value, typeID)
	{
		totalScoreDisplay = totalScoreTarget;
		totalScoreTarget = ::level.scoreKeeper.score;
		local totalMultiplier = ::level.scoreKeeper.streakMultiplier + ::level.scoreKeeper.comboMultiplier - 1;
		
		local multiplierString = ""
		if (totalMultiplier > 1)
		{
			multiplierString = " (x" + totalMultiplier + ")"
		}
		
		totalScoreString = typeID +  multiplierString + " - " + value;
		
		totalScoreTargetPos = totalScoreOutPos;
		totalScoreTimer = totalScoreLifetime;
		
	}
}
