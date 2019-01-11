class MainMenu
{
	menuSize = null;
	
	background = null;
	
	inHelp = false;
	inOptions = false;
	levelSelectMode = 0;
	levelSelected = 0;
	optionMode = 0;
	inUnlockables = false;
	settingControl = 0;
	mouseDown = false;
	
	constructor()
	{
		menuSize = [235,200];
		background = MenuBackground();
	}
	
	function updateAndDraw(t)
	{
		fillColor(1,1,1,1);
		if(!inHelp)
		{
			background.updateAndDraw(t);
		
			guiButtonUpBorder(1,1,1,0,0);
			guiButtonOverBorder(1,1,1,1,1);
			guiButtonDownBorder(1,1,1,0.3,1);
		
			local margin = 5;
		
			guiStripFill(0.0,0.0,0.0,0.0);
			guiStripBorder(1,1,1,0,0);
			guiNewStrip(0,::screenSize[1]/2-margin-menuSize[1]/2,0,0,0,0);
			guiNewStrip(::screenSize[0]/2-margin-menuSize[0]/2,0,0,0,0,0);
			guiMoveRight();
			guiStripFill(0.0,0.0,0.0,0.2);
			guiStripBorder(1,1,1,0,0);
			guiNewStrip(menuSize[0],menuSize[1],5,5,7,7);
		}
		if(!inOptions && !levelSelectMode && !inHelp)
		{
			// Title
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
			guiText("Finity Flight",10);
			
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
			if (::gameInSession == false)
			{
				//Brand New Game Button
				guiBeginButton("BrandNewGameButton",3);
				guiText("Start Game",-1);
				if(guiEndButton() == 4) 
				{ 	
					inUnlockables = false;
					::currentLevel = 1;
					//inHelp = true;
					::rawdelete("level");
					::level <- getLevel(::currentLevel);				//THIS COULD BE BUGGY!
					srand(0);
					cursor(0);
					::gameplayMode = 1;
					::level.playing = true;
					::level.controls.clearReplay();
					::level.controls.startRecording();
					music(getArcadePrefix("FinityFlight")+"data/one.ogg");
					::mainMenuFadeInTimer = 0;
				}
			}
			
			else if (::gameInSession == true)
			{
				//Resume Game Button
				guiBeginButton("ResumeGameButton",3);
				guiText("Resume Game",-1);
				if(guiEndButton() == 4) 
				{ 	
					inUnlockables = false;
					cursor(0);
					::gameplayMode = 1;
					::level.playing = true;
					music(getArcadePrefix("FinityFlight")+"data/one.ogg");
				}
				
				//New Game Button
				guiBeginButton("NewGameButton",3);
				guiText("New Game",-1);
				if(guiEndButton() == 4) 
				{ 	
					inUnlockables = false;
					::weaponFinishedWith = 0;
					::rawdelete("level");
					::currentLevel = 1;
					::level <- getLevel(::currentLevel);				//THIS COULD BE BUGGY!
					srand(0);
					cursor(0);
					::currentLevel = 0;
					::gameplayMode = 1;
					::level.playing = true;
					::level.controls.clearReplay();
					::level.controls.startRecording();
					music(getArcadePrefix("FinityFlight")+"data/one.ogg");
					::mainMenuFadeInTimer = 0;
				}
			}
				
			//Level Select Button
			guiBeginButton("LevelSelectButton",3);
			guiText("Level Select",-1);
			if(guiEndButton() == 4) 
			{ 	
				inUnlockables = false;
				levelSelectMode = 1;
			}
			
			//Options Button
			guiBeginButton("OptionsButton",3);
			guiText("Options",-1);
			if(guiEndButton() == 4) 
			{ 	
				inUnlockables = false;
				inOptions = true;
			}
			
			//Unlockables Button
			guiBeginButton("UnlockableButton",3);
			guiText("Unlockables",-1);
			if(guiEndButton() == 4) 
			{ 	
				inUnlockables = true;
			}
			
			//Quit Button
			guiBeginButton("QuitButton",3);
			guiText("Quit",-1);
			if(guiEndButton() == 4) 
			{ 	
				::quitGame = true;
			}
			
			if(inUnlockables)
			{
				guiMoveRight();
				guiNewStrip(-1,-1,-1,-1,-1,-1);
				// Title
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
				guiText("Unlockables",10);
				
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
				
				fillColor(1.0,1.0,1.0,1.0);
				guiBeginButton("RaptorButton",3);
				guiText("Raptor", -1);
				if(guiEndButton() == 4) 
				{ 	
					::options.shipSelected = 0;
					store("FinityFlight","shipSelected", "0");
				}
				
				//Cotton Mouth Switch Button
				if(::options.unlockedCottonMouth)
				{
					fillColor(1.0,1.0,1.0,1.0);
					guiBeginButton("CottonMouthButton",3);
					guiText("CottonMouth", -1);
					if(guiEndButton() == 4) 
					{ 	
						::options.shipSelected = 1;
						store("FinityFlight","shipSelected", "1");
					}
				}
				else
				{
					fillColor(1.0,1.0,1.0,0.5);
					guiText("Locked",-1);
				}
				
				//Falcon Switch Button
				if(::options.unlockedFalcon)
				{
					fillColor(1.0,1.0,1.0,1.0);
					guiBeginButton("FalconButton",3);
					guiText("Falcon", -1);
					if(guiEndButton() == 4) 
					{ 	
						::options.shipSelected = 2;
						store("FinityFlight","shipSelected", "2");
					}
				}
				else
				{
					fillColor(1.0,1.0,1.0,0.5);
					guiText("Locked",-1);
				}
								
				//Yellow Jacket Switch Button
				if(::options.unlockedYellowJacket)
				{
					fillColor(1.0,1.0,1.0,1.0);
					guiBeginButton("YellowJacketButton",3);
					guiText("Yellow Jacket", -1);
					if(guiEndButton() == 4) 
					{ 	
						::options.shipSelected = 3;
						store("FinityFlight","shipSelected", "3");
					}
				}
				else
				{
					fillColor(1.0,1.0,1.0,0.5);
					guiText("Locked",-1);
				}
				
				
				fillColor(1.0,1.0,1.0,1.0);
				/*
				guiText("____",-1);
				guiText("",-1);
				guiText("Vulcan Unlocked",-1);
				if(::options.gunsUnlocked > 1)
				{
					guiText("Laser Unlocked",-1);
					if(::options.gunsUnlocked > 2)
					{
						guiText("Rockets Unlocked",-1);
					}
					else
					{
						fillColor(1.0,1.0,1.0,0.5);
						guiText("Locked",-1);
					}
				}
				else
				{
					fillColor(1.0,1.0,1.0,0.5);
					guiText("Locked",-1);
					guiText("Locked",-1);
				}
				fillColor(1.0,1.0,1.0,1.0);
				*/
				
				local size;
				if(::options.shipSelected == 0)
				{
					size = image(getArcadePrefix("FinityFlight")+"data/Raptor.png",1,1);
				}
				else if(::options.shipSelected == 1)
				{
					size = image(getArcadePrefix("FinityFlight")+"data/CottonMouth.png",1,1);
				}
				else if(::options.shipSelected == 2)
				{
					size = image(getArcadePrefix("FinityFlight")+"data/Falcon.png",1,1);
				}
				else if(::options.shipSelected == 3)
				{
					size = image(getArcadePrefix("FinityFlight")+"data/YellowJacket.png",1,1);
				}
				
				local maxX = ::screenSize[0]/2-20-menuSize[0]/2;
				local maxY = ::screenSize[1]/2-20-menuSize[1]/2;
				
				if(size[0] > maxX)
				{
					if(size[1] > maxY)
					{
						if(size[0] / maxX > size[1] / maxY)
						{
							size[1] *= maxX / size[0];
							size[0] *= maxX / size[0];
						}
						else
						{
							size[0] *= maxY / size[1];
							size[1] *= maxY / size[1];
						}
					}
					else
					{
						size[1] *= maxX / size[0];
						size[0] *= maxX / size[0];
					}
				}
				else if(size[1] > maxY)
				{
					size[0] *= maxY / size[1];
					size[1] *= maxY / size[1];
				}
				
				guiMoveDown();
				guiNewStrip(size[0] + 4,size[1] + 4,-1,-1,-1,-1);
				rect(::screenSize[0]/2+12.5+menuSize[0]/2, ::screenSize[1]/2+12+menuSize[1]/2 size[0], size[1]);
			}
		}
		else if(inOptions)
		{
			// Title
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
			guiText("Options",10);
			
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
			
			//Sound Button
			guiBeginButton("SoundButton",3);
			guiText("Sound Settings",-1);
			if(guiEndButton() == 4) 
			{ 	
				optionMode = 1;
			}
			
			//Video Button - Disabled
			//guiBeginButton("VideoButton",3);
			//guiText("Video Settings",-1);
			//if(guiEndButton() == 4) 
			//{ 	
			//	optionMode = 2;
			//}
			
			//Control Button
			guiBeginButton("ControlButton",3);
			guiText("Control Settings",-1);
			if(guiEndButton() == 4) 
			{ 	
				optionMode = 3;
			}
			
			//Back Button
			guiText("",-1);
			guiBeginButton("OptionsBackButton",3);
			guiText("Back",-1);
			if(guiEndButton() == 4) 
			{ 	
				inOptions = false;
				store("FinityFlight","soundVolume", " " + ::options.soundVolume);
				store("FinityFlight","musicVolume", " " + ::options.musicVolume);
			}
			if(optionMode == 1)
			{
				guiMoveRight();
				guiNewStrip(-1,-1,-1,-1,-1,-1);
				// Title
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
				guiText("Sound",10);
				
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
				
				guiText("SFX Volume - " + options.soundVolume + "%",3);
				
				//SFX Volume Up Button
				guiBeginButton("SFXVolumeUpButton",3);
				guiText("+5%",-1);
				if(guiEndButton() == 4) 
				{ 	
					//Turn the Volume Up
					::options.addSoundVolume(5);
					local tempVolume = ::options.soundVolume/100.0;
					soundVolume(tempVolume * tempVolume);
				}
				
				//SFX Volume Down Button
				guiBeginButton("SFXVolumeDownButton",3);
				guiText("-5%",-1);
				if(guiEndButton() == 4) 
				{ 	
					//Turn the Volume Down
					::options.addSoundVolume(-5);
					local tempVolume = ::options.soundVolume/100.0;
					soundVolume(tempVolume * tempVolume);
				}
				
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
				
				guiText("Music Volume - " + options.musicVolume + "%",3);
				
				//Music Volume Up Button
				guiBeginButton("MusicVolumeUpButton",3);
				guiText("+5%",-1);
				if(guiEndButton() == 4) 
				{ 	
					//Turn the Volume Up
					::options.addMusicVolume(5);
					local tempVolume = ::options.musicVolume/100.0;
					musicVolume(tempVolume * tempVolume);
				}
				
				//Music Volume Down Button
				guiBeginButton("MusicVolumeDownButton",3);
				guiText("-5%",5);
				if(guiEndButton() == 4) 
				{ 	
					//Turn the Volume Down
					::options.addMusicVolume(-5);
					local tempVolume = ::options.musicVolume/100.0;
					musicVolume(tempVolume * tempVolume);
				}
			}
			//else if(optionMode == 2)
			//{
			//	guiMoveRight();
			//	guiNewStrip(-1,-1,-1,-1,-1,-1);
			//	// Title
			//	font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
			//	guiText("Video",10);
			//	
			//	font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
			//	
			//	//Extra Effects Button
			//	guiBeginButton("ExtraEffectsButton",3);
			//	if(::options.extraEffects)
			//		guiText("Extra Effects: On",-1);
			//	else
			//		guiText("Extra Effects: Off",-1);
			//	if(guiEndButton() == 4) 
			//	{ 	
			//		//Turn AntiAliasing on and off.
			//		if(::options.extraEffects)
			//			::options.extraEffects = false;
			//		else
			//			::options.extraEffects = true;
			//	}
			//}
			else if(optionMode == 3)
			{
				guiMoveRight();
				guiNewStrip(-1,-1,-1,-1,-1,-1);
				// Title
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
				guiText("Controls",10);
				
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
				
				//Fire Button
				guiText("Fire",-1);
				guiBeginButton("FireButton",3);
				guiText(keyName(::options.fireButton),-1);
				if(guiEndButton() == 4) 
				{ 	
					//Set the fire button
					settingControl = 1;
				}
				
				//Weapon Switch Button
				guiText("Weapon Switch",-1);
				guiBeginButton("WeaponSwitchButton",3);
				guiText(keyName(::options.weaponSwitch),-1);
				if(guiEndButton() == 4) 
				{ 	
					//Set the weapon change button
					settingControl = 2;
				}
				
				//Alt Movement Button
				guiText("Alternate Movement",-1);
				guiBeginButton("AltMovementButton",3);
				guiText(keyName(::options.altMovement),-1);
				if(guiEndButton() == 4) 
				{ 	
					//Set the alternate movement button
					settingControl = 3;
				}
				
				local keyPressed = catchKey();
				
				if(settingControl && keyPressed && (keyPressed != 300) && (keyPressed != 301))
				{
					if(settingControl == 1)
					{
						store("FinityFlight","fireButton", keyName(keyPressed));
						::options.fireButton = keyPressed;
					}
					else if(settingControl == 2)
					{
						store("FinityFlight","weaponSwitch", keyName(keyPressed));
						::options.weaponSwitch = keyPressed;
					}
					else if(settingControl == 3)
					{
						store("FinityFlight","altMovement", keyName(keyPressed));
						::options.altMovement = keyPressed;
					}
					settingControl = 0;
				}
			}
		}
		else if(inHelp)
		{
			image(getArcadePrefix("FinityFlight")+"data/Help.png",1,1);
			fillColor(1,1,1,1);
			rect(0,0,::screenSize[0],::screenSize[1]);
			
			if(mouseButton(1))
			{
				mouseDown = true;
			} else {
				if(mouseDown==true) {
					::weaponFinishedWith = 0;
					srand(0);
					cursor(0);
					::gameplayMode = 1;
					::level.playing = true;
					::gameInSession = true;
					::level.controls.startRecording();
					music(getArcadePrefix("FinityFlight")+"data/one.ogg");
					inHelp = false;
				}
				mouseDown = false;
			}
			
			::mainMenuFadeInTimer = 0;
		}
		else if(levelSelectMode)
		{
			// Title
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
			guiText("Level Select",10);
			
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
			
			local currentLevel = levelSelectMode;
			local lastLevel = levelSelectMode + 4;
			if(lastLevel > ::highScoreBook.levelsOpened)
				lastLevel = ::highScoreBook.levelsOpened;
			
			//Previous Page Button
			if(levelSelectMode - 5 > 0)
			{
				guiBeginButton("PrevPageButton",3);
				guiText("<- Previous",-1);
				if(guiEndButton() == 4) 
				{
					levelSelectMode -= 5;
				}
			} else {
				guiText("",3);
			}
			
			while(currentLevel <= lastLevel)
			{
				//Level Button
				guiBeginButton("Level" + currentLevel + "Button",3);
				guiText("Level " + currentLevel,-1);
				if(guiEndButton() == 4) 
				{
					levelSelected = currentLevel;
				}
				currentLevel++;
			}
			
			while(currentLevel <= levelSelectMode + 4)
			{
				//Level Button
				//guiBeginButton("Level" + currentLevel + "Button",3);
				guiText(" ---------",3);
				//if(guiEndButton() == 4) 
				//{
				//}
				currentLevel++;
			}
			
			//Next Page Button
			if(levelSelectMode + 5 < ::totalLevels)
			{
				guiBeginButton("NextPageButton",3);
				guiText("Next ->",-1);
				if(guiEndButton() == 4) 
				{
					levelSelectMode += 5;
				}
			} else {
				guiText("",3);
			}
			
			//Back Button
			guiBeginButton("BackButton",3);
			guiText("Back",-1);
			if(guiEndButton() == 4) 
			{
				levelSelectMode = 0;
				levelSelected = 0;
			}
			
			if(levelSelected != 0)
			{
				guiMoveRight();
				guiNewStrip(-1,-1,-1,-1,-1,-1);
				// Title
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
				guiText("Level " + levelSelected,10);
				
				font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
				
				guiText("Highscores:",-1);
				
				local currentHighScore = 1;
				while(currentHighScore <= 5  && levelSelected)
				{
					//Highscore Button
					if(::highScoreBook.highScores[levelSelected-1][currentHighScore-1] == -1)
						guiText("(empty)",-1);
					else
					{
						guiBeginButton("HS" + currentHighScore + "Button",1);
						local percentOfTotal = (::highScoreBook.highScores[levelSelected-1][currentHighScore-1] * 100) / ::highScoreBook.targetScores[levelSelected-1];
						guiText(" " + percentOfTotal + "% - " + ::highScoreBook.highScores[levelSelected-1][currentHighScore-1],-1);
						if(guiEndButton() == 4)
						{
							::weaponFinishedWith = ::highScoreBook.startingWeapons[levelSelected-1][currentHighScore-1];
							::currentLevel = levelSelected;
							::rawdelete("level");
							::level <- getLevel(::currentLevel);				//THIS COULD BE BUGGY!
							srand(0);
							cursor(0);
							::gameplayMode = 1;
							::level.playing = true;
							::level.controls.clearReplay();
							::level.controls.loadReplay(::highScoreBook.replays[levelSelected-1][currentHighScore-1]);
							::level.controls.startReplaying();
							levelSelectMode = 0;
							levelSelected = 0;
							music(getArcadePrefix("FinityFlight")+"data/one.ogg");
						}
					}
					currentHighScore++;
				}
				
				//Play Level Button
				guiText("",-1);
				guiText("",-1);
				guiBeginButton("PlayLevelButton",3);
				guiText("Play Level",-1);
				if(guiEndButton() == 4)
				{
					::weaponFinishedWith = 0;
					::currentLevel = levelSelected;
					::rawdelete("level");
					::level <- getLevel(::currentLevel);				//THIS COULD BE BUGGY!
					srand(0);
					cursor(0);
					::gameplayMode = 1;
					::level.playing = true;
					::level.controls.clearReplay();
					::level.controls.startRecording();
					levelSelectMode = 0;
					levelSelected = 0;
					music(getArcadePrefix("FinityFlight")+"data/one.ogg");
					
				}
				
			}
		}
		
		guiOriginStrip();
	}

}
