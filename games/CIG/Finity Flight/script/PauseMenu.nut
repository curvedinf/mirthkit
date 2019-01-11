class PauseMenu
{
	menuSize = null;
	f1Down = false;
	visible = true;
	
	constructor()
	{
		menuSize = [200,100];
	}
	
	function updateAndDraw(t)
	{
		
		if(key(keyCode("F1")))
		{
			f1Down = true;
		} else {
			if(f1Down) {
				visible = !visible;
			}
			f1Down = false;
		}
		
		if(visible)
		{
			guiButtonUpBorder(1,1,1,0,0);
			guiButtonOverBorder(1,1,1,1,1);
			guiButtonDownBorder(1,1,1,0.3,1);
			
			//Darken the background.
			fillColor(0.0,0.0,0.0,0.5);
			guiStripFill(0.0,0.0,0.0,0.5);
			image("", 0, 0);
			rect(0, 0, ::screenSize[0], ::screenSize[1]);
		
			fillColor(1.0, 1.0, 1.0, 1.0);
			guiNewStrip(menuSize[0],menuSize[1],::screenSize[0]/2-menuSize[0]/2,::screenSize[1]/2-menuSize[1]/2,7,7);
			// Title
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",20);
			guiText("Paused",10);
		
			//Resume Button
			font(getArcadePrefix("FinityFlight")+"data/venusris.ttf",10);
			guiBeginButton("ResumeButton",3);
			guiText("Resume Game",-1);
			if(guiEndButton() == 4) 
			{ 	
				cursor(0);
				::gameplayMode = 1;
				::level.playing = true;
				musicVolume((::options.musicVolume/100.0));
			}
		
			//Main Menu Button
			guiBeginButton("MainMenuButton",3);
			guiText("Main Menu",-1);
			if(guiEndButton() == 4) 
			{ 	
				cursor(1);
				::gameplayMode = 0;
				::level.playing = false;
				musicVolume((::options.musicVolume/100.0));
				music(getArcadePrefix("FinityFlight")+"data/two.ogg");
			}
		
			//Quit Button
			guiBeginButton("QuitFromPauseButton",3);
			guiText("Quit",-1);
			if(guiEndButton() == 4) 
			{ 	
				::quitGame = true;
			}
		
			guiOriginStrip();
		}
	}
	
	function pauseButtonClicked()
	{
		if (gameplayMode == 1)
		{
			::level.playing = false;
			::gameplayMode = 2;
			cursor(1);
			musicVolume(0);
		}
		else if (::gameplayMode == 2)
		{
			::level.playing = true;
			::gameplayMode = 1;
			cursor(0);
			musicVolume((::options.musicVolume/100.0));
		}
	}

}
