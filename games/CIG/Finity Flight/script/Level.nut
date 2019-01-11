class Level
{
	friends = null;
	friendsShots = null;
	enemies = null;
	enemyShots = null;
	
	player = null;
	
	camera = null;
	funspace = null;
	enemySpawner = null;
	scoreKeeper = null;
	hud = null;
	
	gnatSwarms = null;
	
	bottomParticles = null;
	topParticles = null;
	streamerDrawer = null;
	
	playing = true;
	playTime = 0.0;
	helpScreenTime = 0.0;
	
	slowMo = 1.0;
	previouslySlowMoed = false;
	slowMoFlashTimer = 0;
	slowMoFlashTimerLength = 0.2;
	
	pauseKey = keyCode("ESCAPE");
	pauseKeyDownLastFrame = false;
	
	helpFunction = null;
	helpScreenOn = false;
	helpExitButtonDownLastFrame = false;
	endFunction = null;
	
	isLevelOver = false;
	endLevelDelay = 3.5;
	endLevelTimer = 0;
	
	controls = null;
	
	levelNumber = 0;
	
	levelMessage = null;
	messagePos = null;
	messageTweenMultiplier = 4.0;
	messagePauseTime = 0.0;
	messageFlashTime = 0.3;
	messageLeavingTimer = 3.0;
	
	weaponStartedWith = 0;
	
	scoreRank = 5;
	finalScore = 0;
	
	backgroundColor = null;	//Note - this is only a 3-length array and DOES NOT INCLUDE ALPHA.  Alpha is handled in drawBackground();
	
	constructor()
	{
		srand(0);
		
		friends = DyneLayer();
		friendsShots = DyneLayer();
		enemies = DyneLayer();
		enemyShots = DyneLayer();
		
		bottomParticles = DyneLayer();
		topParticles = DyneLayer();
		streamerDrawer = StreamerDrawer();
		
		createPlayer();
		
		camera = createCamera();
		funspace = FunSpace(player);
		enemySpawner = EnemySpawner();
		scoreKeeper = ScoreKeeper();
		hud = HeadUpDisplay();
		
		gnatSwarms = {};
		
		controls = ControlHandler();
		
		endLevelTimer = endLevelDelay;
		
		backgroundColor = [0.8, 0.8, 0.8];
		levelNumber = ::currentLevel;
		
		weaponStartedWith = ::weaponFinishedWith;
		player.mods[0]["pilot"].setGun(::weaponFinishedWith);
		
		messagePos = [-500, 0];
	}
	
	function update(t)
	{
		if (key(pauseKey))
		{
			if (pauseKeyDownLastFrame == false)
			{
				if(levelNumber == ::totalLevels)
				{ 	
					cursor(1);
					::gameplayMode = 0;
					::level.playing = false;
					musicVolume((::options.musicVolume/100.0));
					music(getArcadePrefix("FinityFlight")+"data/two.ogg");
					return;
				}
				::pauseMenu.pauseButtonClicked();
			}
			pauseKeyDownLastFrame = true;
		}
		else
			pauseKeyDownLastFrame = false;
		
		if (!playing || helpScreenOn)
			return true;
		
		playTime += t;
		
		if (isLevelOver == true)
		{
			endLevelTimer -= t;
			if (endLevelTimer <= 0.0)
			{
				endLevel(false);
			}
		}
	
		controls.update();
		
		local levelTime =  t * slowMo;
		
		friends.update(levelTime)
		friendsShots.update(levelTime);
		enemies.update(levelTime);
		enemyShots.update(levelTime);
		
		camera.update(t);
		funspace.update(levelTime);
		enemySpawner.update(t);
		scoreKeeper.update(t);
		
		foreach(swarm in this.gnatSwarms)
		{
			if (!swarm.update(levelTime))
			{
				delete this.gnatSwarms[swarm.name];
				enemySpawner.swarmKilled();
			}
		}
		
		bottomParticles.update(levelTime);
		topParticles.update(levelTime);
		
		//From ship.nut damage:
		if(damagedThisFrame) 
		{
			//sound(getArcadePrefix("FinityFlight")+"data/hit.wav",0,0.8);
			damagedThisFrame = false;
		}
	
		return true;
	}
	
	function draw(t)
	{	
		local levelTime = t * slowMo; //Use this time for things you want updated with zero time when the game is paused.  NEW USE - also use for drawing slower when paused,if need be.
		if (!playing)
			levelTime = 0.0;
		
		local cameraOffset = this.camera.mods[1]["cameraMod"].getOffset();
		
		modifyWindow(screenSize[0]/2,screenSize[1]/2,0,0,screenSize[1]/768.0.0,0,false);
		drawBackground(scale2(cameraOffset,1.5),1/5.0,getArcadePrefix("FinityFlight")+"data/ground.png",1);
		drawBackground(scale2(cameraOffset,2),1/3.0,getArcadePrefix("FinityFlight")+"data/clouds.png",1);
		revertWindow();
		
		if(slowMo!=1.0)
		{
			modifyBrush();
			image("",0,0);
			fillColor(0,0,0,0.1);
			rect(0,0,::screenSize[0],::screenSize[1]);
			revertBrush();
		}
		
		modifyWindow(screenSize[0]/2,screenSize[1]/2,0,0,screenSize[1]/768.0.0,0,false);
		modifyWindow(cameraOffset[0],cameraOffset[1],0,0,1,0,false);
		
		bottomParticles.draw(levelTime);
		enemies.draw(levelTime);
		enemyShots.draw(levelTime);
		friendsShots.draw(levelTime);
		friends.draw(levelTime);
		streamerDrawer.draw();
		topParticles.draw(levelTime);
		
		local messageTime = t;
		if (!playing)
			messageTime = 0;
	
		
		/*		//Only need to draw swarms for debugging purposes
		foreach(swarm in this.gnatSwarms)
		{
			modifyWindow(swarm.pos[0], swarm.pos[1], 0, 0, 1, 0, false);
			swarm.draw(t);
			revertWindow();
		}
		*/
		
		scoreKeeper.draw(levelTime);
		
		revertWindow();
		
		additiveBlending(true);
		local overAlpha = length2(player.vel)/800.0;
		local overCamOff = scale2(cameraOffset,2);
		drawBackground(overCamOff,2,getArcadePrefix("FinityFlight")+"data/overclouds.png",overAlpha);
		local velDirection = scale2(normalize2(player.vel),2);
		overCamOff = add2(overCamOff,velDirection);
		drawBackground(overCamOff,2,getArcadePrefix("FinityFlight")+"data/overclouds.png",overAlpha);
		overCamOff = add2(overCamOff,velDirection);
		drawBackground(overCamOff,2,getArcadePrefix("FinityFlight")+"data/overclouds.png",overAlpha);
		additiveBlending(false);
		
		revertWindow();
		
		
		if(slowMo!=1.0)
		{
			if(previouslySlowMoed)
			{
				modifyBrush();
				image("",0,0);
				fillColor(1,1,1,slowMoFlashTimer/slowMoFlashTimerLength);
				rect(0,0,::screenSize[0],::screenSize[1]);
				revertBrush();
				slowMoFlashTimer -= t;
			} else {
				slowMoFlashTimer = slowMoFlashTimerLength;
			}
			previouslySlowMoed = true;
		} else {
			previouslySlowMoed = false;
		}
		
		if (helpScreenOn)
			hud.draw(0);
		else if(::gameplayMode == 1) // || (::gameplayMode == 4 && ::betweenLevelMenu.menuAppearanceTimer > 0))
			hud.draw(t);
		else if(::gameplayMode == 2)
			hud.draw(levelTime);
			
		if (!helpScreenOn)	
			displayLevelMessage(messageTime);
		
		if (helpScreenOn)
		{
			helpScreenTime += t;
			helpFunction(t);
		}
		
			
	}
	
	
	function createPlayer()
	{
		this.player = Dyne("player",0,0,0,1,32);
		
		local playerSkin = null;
		
	
		
		if (::options.shipSelected == 0)
			playerSkin = getArcadePrefix("FinityFlight")+"data/Raptor.png";
		else if (::options.shipSelected == 1)
			playerSkin = getArcadePrefix("FinityFlight")+"data/CottonMouth.png";
		else if (::options.shipSelected == 2)
			playerSkin = getArcadePrefix("FinityFlight")+"data/Falcon.png";
		else if (::options.shipSelected == 3)
			playerSkin = getArcadePrefix("FinityFlight")+"data/YellowJacket.png";
		
		
		player.addMod(Ship("ship",10,playerSkin,0.5,1000,1.3,1800,6.2),1);
		player.mods[1]["ship"].typeID = "Player";
		
		player.addMod(HumanPilot("pilot"),0);
		
		player.addMod(Shield("shield", 200, 40, 40,1),4);
		player.mods[4]["shield"].color = [0.2, 0.2, 1.0, 1.0];
		
		if (::currentLevel >= 5)
			::options.gunsUnlocked = 3;
		
		local vulcan = Vulcan("gun0",0,30,0);  vulcan.weaponActive = true;
		player.addMod(vulcan,3);
		
		if (::options.gunsUnlocked >= 2)
		{
			local laser = LaserCannon("gun1",0,10,0); laser.weaponActive = false;
			player.addMod(laser,3);
		}
		
		if (::options.gunsUnlocked >= 3)
		{
			local rocket = RocketLauncher("gun2",0,10,0); rocket.weaponActive = false;
			player.addMod(rocket,3);
		}
		
	
		
		if (::options.shipSelected == 0) {
			player.addMod(Thruster("thruster0",8,25,0.5,0.1,1),2);
			player.addMod(Thruster("thruster1",-8,25,0.5,0.1,1),2);
			player.addMod(Streamer("streamer0",8,-25,5,20),2);
			player.addMod(Streamer("streamer1",-8,-25,5,20),2);
			player.addMod(Streamer("streamer2",28,-20,1,4),2);
			player.addMod(Streamer("streamer3",-28,-20,1,4),2);
			player.mods[2]["streamer0"].countdownLength = 0.05;
			player.mods[2]["streamer1"].countdownLength = 0.05;
			player.mods[2]["streamer2"].countdownLength = 0.05;
			player.mods[2]["streamer3"].countdownLength = 0.05;
		} else if (::options.shipSelected == 1) {
			player.addMod(Thruster("thruster0",8,46,0.5,0.1,1),2);
			player.addMod(Thruster("thruster1",-8,46,0.5,0.1,1),2);
			player.addMod(Streamer("streamer0",8,-46,5,20),2);
			player.addMod(Streamer("streamer1",-8,-46,5,20),2);
			player.addMod(Streamer("streamer2",30,-12,1,4),2);
			player.addMod(Streamer("streamer3",-30,-12,1,4),2);
			player.mods[2]["streamer0"].countdownLength = 0.05;
			player.mods[2]["streamer1"].countdownLength = 0.05;
			player.mods[2]["streamer2"].countdownLength = 0.05;
			player.mods[2]["streamer3"].countdownLength = 0.05;
		} else if (::options.shipSelected == 2) {
			player.addMod(Thruster("thruster0",10,28,0.5,0.7,1),2);
			player.addMod(Thruster("thruster1",-10,28,0.5,0.7,1),2);
			player.addMod(Streamer("streamer0",10,-28,5,20),2);
			player.addMod(Streamer("streamer1",-10,-28,5,20),2);
			player.addMod(Streamer("streamer2",28,-20,1,4),2);
			player.addMod(Streamer("streamer3",-28,-20,1,4),2);
			player.mods[2]["streamer0"].countdownLength = 0.05;
			player.mods[2]["streamer1"].countdownLength = 0.05;
			player.mods[2]["streamer2"].countdownLength = 0.05;
			player.mods[2]["streamer3"].countdownLength = 0.05;
		} else if (::options.shipSelected == 3) {
			player.addMod(Thruster("thruster0",0,12,0.5,0.1,1),2);
			player.addMod(Streamer("streamer0",0,-12,5,20),2);
			player.addMod(Streamer("streamer1",6,-8,1,4),2);
			player.addMod(Streamer("streamer2",-6,-8,1,4),2);
			player.mods[2]["streamer0"].countdownLength = 0.05;
			player.mods[2]["streamer1"].countdownLength = 0.05;
			player.mods[2]["streamer2"].countdownLength = 0.05;
		}
		
		this.friends.addDyne(player);
	}
	
	function createCamera()
	{
		local tempCam = Dyne("cameraDyne",0,0,1,1,1);
		tempCam.addMod(Camera("cameraMod"), 1);
		
		return tempCam;
	}
	
	function drawBackground(cameraOffset,scale,imagePath,alpha)
	{
		local size = image(imagePath,3,3);
		
		local cx = cameraOffset[0]*scale;
		local cy = cameraOffset[1]*scale;
		local rx = -2-floor(cx / size[0]);
		local ry = -2-floor(cy / size[1]);
		
		modifyWindow(cx,cy,0,0,1,0,false);
		modifyBrush();
		fillColor(backgroundColor[0],backgroundColor[0],backgroundColor[0],alpha);
		rect((rx*size[0]),(ry*size[1]),size[0]*3,size[1]*3);
		revertBrush();
		revertWindow();
	}
	
	function killPlayer()
	{
		local playerShip = player.mods[1]["ship"];
		
		camera.mods[1]["cameraMod"].mode = 3;
		
		playerShip.img = "";
		playerShip.thrustAmount = 0.2;
		playerShip.turnAmount = 0.5;
		
		delete player.mods[0]["pilot"];
		if("shield" in player.mods[4])
			delete player.mods[4]["shield"];
		player.mods[2] = {};
		player.mods[3] = {};
		
		::gameplayMode = 3;
		cursor(1);		
	}
	
	function enemyKilled(enemyPos, enemyVel, scoreAmount, typeID)
	{
			scoreKeeper.addScore(enemyPos, enemyVel, scoreAmount, typeID);
			
			
			if (typeID != "Gnat")		//Don't behave the same for destroyed gnats.
			{
				scoreKeeper.addKill();
				enemySpawner.enemyKilled();
			}
	
			::killCount += 1;
	}
	
	function endLevel()
	{
		//Play a sound here eventually.
		if(::level.controls.recording)
			::highScoreBook.levelIsComplete();
		::gameplayMode = 4;
		::betweenLevelMenu = BetweenLevelMenu();
		if (this.endFunction != null)
			::betweenLevelMenu.levelEndFunction = this.endFunction;
		if (::currentLevel < ::totalLevels)
			::currentLevel += 1;
		::weaponFinishedWith = player.mods[0]["pilot"].currentWeaponActive;
		player.tangible = false;
		finalScore = scoreKeeper.score;
		scoreKeeper.scoreEnabled = false;
	}
	
	function displayLevelMessage(t)
	{
		if (levelMessage == null || messageLeavingTimer > 7.0)
			return true;
			
		local color = 1.0 - (playTime * 3);
		if (color < 0.4)
			color = 0.4;
		local flashColor = [color, color, 1.0, color + 0.6];
		
		messageLeavingTimer -= t;
		if (messageLeavingTimer > 0)
		{
			messagePos[0] += (((screenSize[0]/2) - messagePos[0]) * messageTweenMultiplier * t);
		}
		else
		{
			messagePos[0] += (((screenSize[0] + 500) - messagePos[0]) * messageTweenMultiplier * t);
			flashColor[0] -= messageLeavingTimer * 3;
			flashColor[1] = flashColor[0];
			flashColor[3] += (0.3 + messageLeavingTimer*3);
		}
		
		
		//Center the message on the position.
		font(::getArcadePrefix("FinityFlight")+"data/venusris.ttf",35);
		image("", 0, 0);
		fillColor(0.0,0.0,0.0,0.0)//Fake render
		local textInfo = cursorText(levelMessage, 0, 0, 400, 0, 0);
		
		//Real render
		fillColor(flashColor[0], flashColor[1], flashColor[2], flashColor[3]);
		cursorText(levelMessage, messagePos[0] - (textInfo[0] / 2), ::screenSize[1]/2 - textInfo[2], 400, 0, 0);
		rect(0, ::screenSize[1]/2 + textInfo[2] - 45, ::screenSize[0], 5);
	}
}
