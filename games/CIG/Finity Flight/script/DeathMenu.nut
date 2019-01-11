class DeathMenu
{
	menuSize = null;
	backgroundAlpha = 0.0;
	alphaFadeRate = 0.5;
	menuAppearanceTimer = 2.5;
	
	constructor()
	{
		menuSize = [300, 100];
	}
	
	function updateAndDraw(t)
	{
		guiButtonUpBorder(1,1,1,0,0);
		guiButtonOverBorder(1,1,1,1,1);
		guiButtonDownBorder(1,1,1,0.3,1);
			
		image("", 0, 0);
		fillColor(1.0,1.0,1.0,backgroundAlpha);
		rect(0, 0, ::screenSize[0], ::screenSize[1]);
		
		backgroundAlpha += alphaFadeRate * t;
		if (backgroundAlpha > 1.0)
			backgroundAlpha = 1.0;
		
		menuAppearanceTimer -= t;
		
		if (menuAppearanceTimer <= 0)
		{
			fillColor(1.0, 1.0, 1.0, 1.0);
			guiStripFill(0.0,0.0,0.0,0.5);
			guiNewStrip(menuSize[0],menuSize[1],::screenSize[0]/2-menuSize[0]/2,::screenSize[1]/2-menuSize[1]/2,7,7);
			// Title
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
			guiText("Continue?",10);
			
			//Continue Button
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
			guiBeginButton("ContinueButton",3);
			guiText("Play Again",-1);
			if(guiEndButton() == 4) 
			{ 	
				::rawdelete("level");
				::level <- getLevel(::currentLevel);	//THIS COULD BE BUGGY!
				cursor(0);
				::gameplayMode = 1;
				::level.playing = true;
				this.reset();
				::level.controls.startRecording();
				music(getArcadePrefix("FinityFlight")+"data/one.ogg");
			}
				
			//Replay Button
			guiBeginButton("ReplayButton",3);
			guiText("View Replay",-1);
			if(guiEndButton() == 4) 
			{ 	
				::freakingReplay <- ::level.controls.saveReplay();
				::rawdelete("level");
				::level <- getLevel(::currentLevel);				//THIS COULD BE BUGGY!
				srand(0);
				cursor(0);
				::gameplayMode = 1;
				::level.playing = true;
				::level.controls.clearReplay();
				::level.controls.loadReplay(::freakingReplay);
				::level.controls.startReplaying();
				music(getArcadePrefix("FinityFlight")+"data/one.ogg");
			}
			
			//Main Menu Button
			guiBeginButton("QuitToMainButton",3);
			guiText("Main Menu",-1);
			if(guiEndButton() == 4) 
			{ 	
				cursor(1);
				::gameplayMode = 0;
				::level.playing = false;
				::gameInSession = false;
				
				::rawdelete("level");
				::level <- getLevel(::currentLevel);	;				//THIS COULD BE BUGGY!
				music(getArcadePrefix("FinityFlight")+"data/two.ogg");
				
				this.reset();
			}
			
			
			guiOriginStrip();
		}
	}
	
	function reset()
	{
		backgroundAlpha = 0.0;
		menuAppearanceTimer = 2.5;
	}
}
