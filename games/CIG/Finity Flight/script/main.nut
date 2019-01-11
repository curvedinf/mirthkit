doNut(getArcadePrefix("FinityFlight")+"script/preload.nut");

currentLevel <- 1;
totalLevels <- 16;

options <- OptionHandler();
highScoreBook <- HighScoreBook();

screenSize <- update();
mousePos <- mouse();

gameplayMode <- 0;  //0 - Main Menu, 1 - Gameplay, 2 - Paused, 3 - Death Menu, 4 - BetweenLevelMenu
quitGame <- false;

particleNum <- 0;
killCount <- 0;
lastRocketHitNumber <- 0;

mainMenu <- MainMenu();
pauseMenu <- PauseMenu();
deathMenu <- DeathMenu();
betweenLevelMenu <- BetweenLevelMenu();

weaponFinishedWith <- 0;

levels <- [level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15,level16];
function getLevel(levelNumber)
{
	return levels[levelNumber-1]();
}

//level <- getLevel(currentLevel);
//level.playing = false;

gameInSession <- false;

local fps=0,frames=0,time=micros()-(1000000/60),next=time+1000000;

background(1,1,1);

font(getArcadePrefix("FinityFlight")+"data/DejaVuSerif-BoldOblique.ttf",32);

soundVolume((::options.soundVolume/100.0));
musicVolume((::options.musicVolume/100.0));
//music(getArcadePrefix("FinityFlight")+"data/two.ogg");

//Debug
triedToSpawn <- false;
//

local fadeInTimerLength = 3.0;
mainMenuFadeInTimer <- fadeInTimerLength;

for(;;)
{
	//Store what time (in micros) last frame was
	//Compare to current micros time.
	//If the difference isn't greater than 1/60th second, wait.
	//If greater, continue on, and give t as 1/60th seocond
	//If time > current micros(), draw anyway.
	//If 2/60ths of a second have elapsed, skip drawing.
	//Increment a variable that tracks how many times we've skipped drawing.
	//In the rare case that the variable is greater than sixty:  Advertise new INTEL chips.  (stop gameplay)
	local t = (1/60.0);
	time = micros();
	frames++;
	if(next<time)
	{
		next = time+1000000;
		fps = frames;
		frames = 0;
	}
	
	mainMenuFadeInTimer -= t;
	if(mainMenuFadeInTimer < 0)
		mainMenuFadeInTimer = 0;
	
	//if(key(27))
	//	quitGame = true;
	if (quitGame)
		break;
	

	mousePos = mouse();
	
	if (gameplayMode == 0)
	{
		mainMenu.updateAndDraw(t);
	}
	else
		mainMenuFadeInTimer = 0;
		
	if (gameplayMode == 1)
	{
		level.update(t);
		level.draw(t);
	}
	else if (gameplayMode == 2)
	{
		level.update(t);
		level.draw(t);
		pauseMenu.updateAndDraw(t);
	}
	else if (gameplayMode == 3)
	{
		level.update(t);
		level.draw(t);
		deathMenu.updateAndDraw(t);
	}
	else if (gameplayMode == 4)
	{
		level.update(t);
		level.draw(t);
		betweenLevelMenu.updateAndDraw(t);
	}
	
	if (gameplayMode == 1 || gameplayMode == 2)
	{
	
		/*font(getArcadePrefix("FinityFlight")+"data/f500.ttf",16);
		fillColor(1,1,1,1);
		local cy = 10;
		cy += text("FPS: "+fps,10,cy,1000);
		cy += text("Ships: "+level.enemies.dynes.len(),10,cy,1000);
		cy += text("Kills: "+killCount,10,cy,1000);
		cy += text("COMBO Multipler: "+::level.scoreKeeper.comboMultiplier,10,cy,1000);
		cy += text("STREAK Multipler: "+::level.scoreKeeper.streakMultiplier,10,cy,1000);
		cy += text("Current Wave Length: "+::level.enemySpawner.waves[0].len(),10,cy,1000);
		cy += text("Wave Number: "+ ::level.enemySpawner.currentWave ,10,cy,1000);*/
	
		/*  //FOR DEBUGGING, or cheating
		if (key('k'))
		::level.player.mods[1]["ship"].health = 0;
		if (key('l'))
		::level.endLevel();
		*/
	}
	
	if(mainMenuFadeInTimer>=0)
	{
		modifyBrush();
		image("",0,0);
		local fadePercent = mainMenuFadeInTimer/(fadeInTimerLength/1.05);
		fillColor(1,1,1,fadePercent);
		rect(0,0,screenSize[0],screenSize[1]);
		revertBrush();
	}
	
	screenSize=update();
	
	for(;time > micros() || micros() < time+(1000000/60);){}
}
