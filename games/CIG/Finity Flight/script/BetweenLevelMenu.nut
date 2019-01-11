class BetweenLevelMenu
{
	menuSize = null;
	menuAlpha = 0.0;
	textAlpha = 0.0
	menuAlphaRate = 0.5;
	textAlphaRate = 1.0;
	fadeDelay = 0.50;
	
	timeUntilMenuAppears = 3.5;
	menuAppearanceTimer = 0;
	highScoreFlashTimer = 0.0;
	nextLevelFlashTimer = 0.0;
	
	levelEndFunction = null;
	
	constructor()
	{
		menuSize = [500, 300];
		menuAppearanceTimer = timeUntilMenuAppears;
	}
	
	function updateAndDraw(t)
	{
		menuAppearanceTimer -= t;
		highScoreFlashTimer += t;
		nextLevelFlashTimer += t;
		
		if(highScoreFlashTimer > 1)
			highScoreFlashTimer -=1;
		if(nextLevelFlashTimer > 1)
			nextLevelFlashTimer -=1;
		
		guiButtonUpBorder(0,0,0,0,0);
		guiButtonOverBorder(1,1,1,1,1);
		guiButtonDownBorder(1,1,1,0.3,1);
		guiStripFill(0,0,0,0);

		
		image("", 0, 0);
		if (menuAppearanceTimer <= 2.0)
		{
			menuAlpha += menuAlphaRate * t;
				if (menuAlpha > 0.5)
					menuAlpha = 0.5;
			fillColor(0.0,0.0,0.0,menuAlpha);
			rect(0, 0, ::screenSize[0], ::screenSize[1]);
		}
		
		local levelString = "";
		if(::level.levelNumber < 10)
			levelString += "0";
		levelString += ::level.levelNumber;
		
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf",35);
		fillColor(0.0, 0.0, 0.0, 0.0);	//Need to center text.
		local textInfo = cursorText("Level "+levelString+" Complete", 0, 0, 1000, 0, 0);
		local textYadditive = 0.0;
		if (menuAppearanceTimer < 2.0)
			textYadditive -= (menuAppearanceTimer - 2.0)  * 300;
		if (textYadditive > (::screenSize[1] / 2) - textInfo[2])
			textYadditive = (::screenSize[1] / 2) - textInfo[2];
		local textColor = [1.0, 1.0, 1.0, 1.0];
		local textColorNumber = menuAppearanceTimer - 2.6;
		if (textColorNumber < 0.4)
			textColorNumber = 0.4;
		if (menuAppearanceTimer < timeUntilMenuAppears - 0.05)
			textColor = [textColorNumber, textColorNumber, 1.0, textColorNumber + 0.5];
		fillColor(textColor[0], textColor[1], textColor[2], textColor[3]);	//For real this time.
		
		text("Level "+levelString+" Complete", ::screenSize[0]/2 - textInfo[0]/2, ::screenSize[1]/2 - textInfo[2] - textYadditive, 1000);
		rect(::screenSize[0]/2 - textInfo[0]/2 - 100, ::screenSize[1]/2 + textInfo[2] - 45  - textYadditive, textInfo[0] + 200, 5);
		
		if (menuAppearanceTimer <= 0.8)
		{
			cursor(1);
			::level.playing = false;
			
			fadeDelay -= t;
			if (fadeDelay < 0)
			{
				textAlpha += textAlphaRate * t;
				if (textAlpha > 1.0)
					textAlpha = 1.0;
					
				//guiStripFill(0.0,0.0,0.6,0.5);					//Uncomment these lines to see the menu "grid"
				//guiStripBorder(1,1,1,1,1);					//
				
			
				local startingLocation = (screenSize[0]/2 + screenSize[0]%2 ) - 250;
				guiNewStrip(startingLocation,0,0,0,0,0);
				guiMoveRight();
				guiNewStrip(0, 60,0,0,0,0);
				
				if (levelEndFunction != null)
				{
					levelEndFunction();
				}
				
				
				guiMoveDown();
				guiNewStrip(250, 200, 0, 0, 0, 0);
				
				fillColor(1.0, 1.0, 1.0, 1.0);
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
				guiText("Your Score",-1);
				font(getArcadePrefix("FinityFlight")+"data/DejaVuSans.ttf",16);
				guiText(floor(::level.scoreKeeper.getParPercent()) + "% - " + ::level.finalScore,-1);
				print(::level.scoreKeeper.parScore + ", " + ::level.scoreKeeper.score + "\n");
				
				guiMoveRight();
				
				guiNewStrip(300, 200, 0, 0, 0, 0);
				
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
				guiText("High Scores", -1);
				
				local currentHighScore = 1;
				while(currentHighScore <= 5  && ::level.levelNumber)
				{
					font(getArcadePrefix("FinityFlight")+"data/DejaVuSans.ttf",16);
					local highScoreColor = [1.0, 1.0, 1.0, 1.0];

					if(currentHighScore != ::level.scoreRank + 1)
						fillColor(1.0, 1.0, 1.0, textAlpha);
					else
						fillColor(1.0, 1.0, 1.0, textAlpha * (1.0 - ((cos(highScoreFlashTimer * 2 * PI) + 1) * 0.4)));
						
					//Highscore Button
					if(::highScoreBook.highScores[::level.levelNumber-1][currentHighScore-1] == -1)
						guiText("(empty)",-1);
					else
					{
						print(currentHighScore + ": " + ::highScoreBook.targetScores[::level.levelNumber-1] + ", " + ::highScoreBook.highScores[::level.levelNumber-1][currentHighScore-1] + "\n");
						local numberOf100s = floor(::highScoreBook.highScores[::level.levelNumber-1][currentHighScore-1] / ::highScoreBook.targetScores[::level.levelNumber-1]);
						local multiplier = 1.0 + (0.30 * numberOf100s);
						local finalPercent = numberOf100s * 100;
						local tempScore = ::highScoreBook.highScores[::level.levelNumber-1][currentHighScore-1] - (::highScoreBook.targetScores[::level.levelNumber-1] * numberOf100s);
						finalPercent += (tempScore / (::highScoreBook.targetScores[::level.levelNumber-1] * multiplier)) * 100.0;
						finalPercent = floor(finalPercent);
						guiText(finalPercent + "% - " + ::highScoreBook.highScores[::level.levelNumber-1][currentHighScore-1],-1);
					}
					currentHighScore++;
					font(getArcadePrefix("FinityFlight")+"data/venusris.ttf", 8);
					guiText("     ",-1);
				}
				
				guiPreviousStrip();
				
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",16);
				
				guiMoveDown()
				guiNewStrip(200, 60, 0, 0, 0, 0);
				
				fillColor(1.0, 1.0, 1.0, 1.0);
				//Replay Button
				guiBeginButton("ReplayButton",2);
				guiText("View Replay",-1);
				if(guiEndButton() == 4) 
				{ 	
					local weaponStartedWith = ::level.weaponStartedWith;
					::freakingReplay <- ::level.controls.saveReplay();
					::rawdelete("level");
					::currentLevel = ::currentLevel-1;
					::level <- getLevel(::currentLevel);				//THIS COULD BE BUGGY!
					srand(0);
					cursor(0);
					::gameplayMode = 1;
					::level.playing = true;
					::level.controls.clearReplay();
					::level.controls.loadReplay(::freakingReplay);
					::level.controls.startReplaying();
					music(getArcadePrefix("FinityFlight")+"data/one.ogg");
					::level.player.mods[0]["pilot"].setGun(weaponStartedWith);
				}
				
				guiNewStrip(180,60,0,0,0,0);
				
				//Main Menu Button
				guiBeginButton("QuitToMainButton",3);
				guiText("Main Menu",-1);
				if(guiEndButton() == 4) 
				{ 	
					::weaponFinishedWith = 0;
					cursor(1);
					::gameplayMode = 0;
					::level.playing = false;
					::gameInSession = false;
					
					::rawdelete("level");
					::level <- getLevel(::currentLevel);	;				//THIS COULD BE BUGGY!
					music(getArcadePrefix("FinityFlight")+"data/two.ogg");
					
					this.reset();
				}
				
				guiPreviousStrip();
				
				guiMoveRight();
				guiNewStrip(60,0,0,0,0,0);
				guiNewStrip(180,60,0,0,0,0);
				
				//Next Level Button
				local pulsePoint = textColorNumber + (1.0 - textColorNumber) * (1.0 - ((cos(nextLevelFlashTimer * 2 * PI) + 1) * 0.5));
				fillColor(pulsePoint, pulsePoint, 1.0, textAlpha);
				guiBeginButton("NextLevelButton",3);
				if (::currentLevel == 16)
					guiText("Game Over!",-1);
				else
					guiText("Next Level",-1);
				if(guiEndButton() == 4) 
				{ 	
					::rawdelete("level");
					::level <- getLevel(::currentLevel);				//THIS COULD BE BUGGY!
					cursor(0);
					::gameplayMode = 1;
					::level.playing = true;
					this.reset();
					::level.controls.startRecording();
					::level.weaponStartedWith = ::weaponFinishedWith;
				}
				fillColor(1.0, 1.0, 1.0, textAlpha);
				
				guiMoveDown();
				guiNewStrip(180,60,0,0,2,2);
				
				//Play Again Button
				guiBeginButton("PlayAgainButton",3);
				guiText("Play Again",-1);
				if(guiEndButton() == 4) 
				{ 	
					local weaponStartedWith = ::level.weaponStartedWith;
					::currentLevel = level.levelNumber;
					::rawdelete("level");
					::level <- getLevel(::currentLevel);				//THIS COULD BE BUGGY!
					cursor(0);
					::gameplayMode = 1;
					::level.playing = true;
					this.reset();
					::level.controls.startRecording();
					::level.weaponStartedWith = weaponStartedWith;
				}

			}
		
		}
		guiStripFill(0.0,0.0,0.0,0.2);	
		guiOriginStrip();
		
	}
	
	function reset()
	{
		menuAlpha = 0.0;
		textAlpha = 0.0;
	}
}
