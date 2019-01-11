class HumanPilot
{
	name="";
	owner=null;
	
	primaryWeaponBurst=-1;
	timeSinceLastMouse1Down = 4.0;		//Just some number bigger than 0.4;
	doubleClickTime = 0.35;						//Time limit before we are no longer "double clicking"
	mouse1DownLastFrame = false;
	mouse2DownLastFrame = false;
	maxTurretDegrees = 23;
	
	boosting = false;
	boostTimer = 0.0;
	
	boostEnergy = 100;
	boostStartEnergy = 100;
	boostInitialCost = 10;
	boostCostPerSecond = 20;
	boostRechargePerSecond = 10;
	
	speedKickTimer = 0.0;
	timeSinceMouse3 = 0.3;
	boostTurnMax = 5000;
	
	currentWeaponActive = 0;
	
	screenMouseShadow = null;
	lastScreenMouse = null;
	
	secondaryWeaponRecharge = 0.0;
	
	constructor(name)
	{
		this.name = name;
		primaryWeaponBurst = -1;
		screenMouseShadow = sub2(::mousePos,scale2(::screenSize,0.5));
		lastScreenMouse = [0,0];
	}
	
	function update(t)
	{
		if(!(owner.mods[1].rawin("ship")) || !::level.camera.mods[1].rawin("cameraMod"))
			return false;
		
		local ship = owner.mods[1]["ship"];
		local camera = ::level.camera.mods[1]["cameraMod"];
		
		secondaryWeaponRecharge -= t;
		
		local screenMouse = sub2(::level.controls.getMousePosition(),scale2(::screenSize,0.5));
		screenMouseShadow[0] += (screenMouse[0]-screenMouseShadow[0])/10;
		screenMouseShadow[1] += (screenMouse[1]-screenMouseShadow[1])/10;
		local camPosition = scale2(owner.vel,-0.25);
		if (this.boosting)
			camPosition = [0,0];
		local centeredMouse = sub2(screenMouse,camPosition);
		local globalMouse = add2(screenMouse, camera.owner.pos);
		local thrustAmount = 0;
			
		
		// REGULAR MOVEMENT ROUTINE
		local turnAmount = howMuchLeft2(owner.forward,[0,0],centeredMouse);
		ship.turn(turnAmount*3);
	
		//Find the length of centeredMouse projected onto the ship's forward vector
		local forwardComponent = component2(centeredMouse, owner.forward);
		thrustAmount = forwardComponent / (::screenSize[1]/2);
		if (speedKickTimer > 0)
			thrustAmount = 1.0;
		if(thrustAmount>1) 
			thrustAmount=1;
		
		thrustAmount *= thrustAmount; //= 1/((1/thrustAmount)*(1/thrustAmount));
		
		//Limit minimum thrust based on whether the player is trying to go forward.
		/*
		if(turnAmount < -0.7 || turnAmount > 0.7)
			if(thrustAmount>0.2)
				thrustAmount = 0.2;
		else
			if(thrustAmount<0.2)
				thrustAmount = 0.2;
		*/
		
		if(thrustAmount < 0.2)
			thrustAmount = 0.2;							
		
		timeSinceMouse3 += t;
		
		if(::level.controls.isButtonDown(3) && boostEnergy > 0 && speedKickTimer <= -1.00)
		{
			if (!boosting && boostEnergy > boostInitialCost)	//Other conditions, such as boost power should be checked here
			{
				boostStartEnergy = boostEnergy;
				boostEnergy -= boostInitialCost;
				
				boosting = true;
				boostTimer = 0.25;
				::level.slowMo = 0.35;
				::level.camera.mods[1]["cameraMod"].mode = 1;
				::level.camera.mods[1]["cameraMod"].stayAheadOfPlayer = false;
				ship.rotFriction = 100.0;
				ship.turnMax = ship.turnMax * 30 / ::level.slowMo;
				//Things that happen at the start of the boost occur here.
			}
		}
		else //if (boostTimer <= 0)
		{
			if(boosting)
			{
				boosting = false;
				::level.slowMo = 1.0;
				::level.camera.mods[1]["cameraMod"].mode = 0;
				::level.camera.mods[1]["cameraMod"].stayAheadOfPlayer = true;
				::level.camera.mods[1]["cameraMod"].interpolateTo = true;
				ship.turnMax = 1800;
				ship.rotFriction = 6.2;
				speedKickTimer = 0.25;
				sound(getArcadePrefix("FinityFlight")+"data/boost.wav",0,0);
				//owner.vel = [0,0];
				//Things that happen at the end of the boost occur here.
			}
		}
		
		if (boosting && boostEnergy > 0)
		{
			boostTimer -= t;
			if (boostTimer < 0)
				boostTimer = 0;
			thrustAmount = 0;
			ship.slide();
			
			// Boost energy
			
			boostEnergy -= boostCostPerSecond * t;
		}
		else
		{
			speedKickTimer -= t;
			if (speedKickTimer > 0)
			{
				ship.thrustMax = 6000;
				ship.thrustAmount = 1.0;
			}
			else
			{
				ship.thrustMax = 1000;
			}
			
			boostEnergy += boostRechargePerSecond * t;
			if(boostEnergy>100)
				boostEnergy = 100;
		}
		
		ship.thrust(thrustAmount);
		
		// FIRING ROUTINE
		
		if(primaryWeaponBurst!=-1)
		{
			primaryWeaponBurst -= t;
			if(primaryWeaponBurst<0)
				primaryWeaponBurst=0;
		}
		
		timeSinceLastMouse1Down += 1.0/60.0; 	//Rather than t, we use 1/60 so that slo-mo doesn't cause accidental secondary firing
		
		local fireSecondary = false;
		
		if(::level.controls.isButtonDown(1))
		{
			if (!mouse1DownLastFrame && timeSinceLastMouse1Down < doubleClickTime)
			{
				fireSecondary = true;
			}
			if(primaryWeaponBurst==-1)
				primaryWeaponBurst = doubleClickTime;
			if(!mouse1DownLastFrame)
				timeSinceLastMouse1Down = 0.0;
			mouse1DownLastFrame = true;
		} 
		else if(primaryWeaponBurst==0) 
		{
			primaryWeaponBurst = -1;
			mouse1DownLastFrame = false;
		}
		else
		{
			mouse1DownLastFrame = false;
		}
		
		if(primaryWeaponBurst!=-1) 
		{
			//Find the angle the gun should fire at.
			local aimDegrees = 0;
			if(boosting)
			{
				
			}
			else
			{
				aimDegrees =  degreesBetween2(owner.forward, centeredMouse);
				local shipRight = quarterCW2(owner.forward);
				
				if (aimDegrees > 1000)
					aimDegrees = 0;			
				if (aimDegrees > maxTurretDegrees)
					aimDegrees = maxTurretDegrees;
				if (dot2(centeredMouse, shipRight) > 0)
					aimDegrees *= -1;
			}
			
			foreach(gun in owner.mods[3])
			{
				gun.r = aimDegrees;
				gun.fire();
				if (fireSecondary)
				{
					gun.secondaryFire();
				}
			}
			
		}
		
		// WEAPON SWITCH ROUTINE
		
		//local mWheelUp = mouseButton(4);
		//local mWheelDown = mouseButton(5);
		if (::level.controls.isButtonDown(2) || ::level.controls.isButtonDown(4))
		//key(keyCode("TAB")))
		{
			if (!mouse2DownLastFrame)
			{
				currentWeaponActive += 1;
				if (currentWeaponActive > 2 || currentWeaponActive > ::options.gunsUnlocked - 1)
					currentWeaponActive = 0;
				
				if (owner.mods[3].rawin("gun0")) owner.mods[3]["gun0"].weaponActive = false;
				if (owner.mods[3].rawin("gun1")) owner.mods[3]["gun1"].weaponActive = false;
				if (owner.mods[3].rawin("gun2")) owner.mods[3]["gun2"].weaponActive = false;
				
				if (owner.mods[3].rawin("gun" + currentWeaponActive)) owner.mods[3]["gun" + currentWeaponActive].weaponActive = true;
			}
			mouse2DownLastFrame = true;
		}
		else
			mouse2DownLastFrame = false;
		
		
		// BOOKKEEPING
		
		lastScreenMouse = screenMouseShadow;
		
		if(key(keyCode("LEFTBRACKET")))
			::level.controls.startRecording();
		if(key(keyCode("RIGHTBRACKET")))
			::level.controls.startReplaying();
		if(key(keyCode("BACKSLASH")))
			::freakingReplay <- ::level.controls.saveReplay();
		if(key(keyCode("BACKSPACE"))) {
			::level.controls.clearReplay();
			::level.controls.loadReplay(::freakingReplay);
		}
		
		return true;
	}
	
	function draw(t)
	{
		if (::level.playing == false)
			return;
		
		if(speedKickTimer>0)
		{
			local flareSize = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
			modifyWindow(0,100,flareSize[0],flareSize[1],20,-owner.r,false);
			additiveBlending(true);
			fillColor(1,0.9,0.7,speedKickTimer/0.25);
			rect(0,0,flareSize[0],flareSize[1]);
			revertWindow();
		}
			
		local centeredMouse = sub2(::level.controls.getMousePosition(),scale2(::screenSize,0.5));
		if (!this.boosting)
			centeredMouse = sub2(centeredMouse,scale2(owner.vel,-0.25));
		
		if(!boosting)
		{
			//If the game is in "help screen mode, don't display the arrow"
			if (!::level.helpScreenOn)
			{
				modifyWindow(0,0,0,0,1,-owner.r,false);
				additiveBlending(true);
		
				local mouseLength = length2(centeredMouse);
		
				//Draw a Bezier curve approximating player path
				local pointA = [0,0];
				local pointB = scale2(normalize2(owner.forward), mouseLength*0.5);
				if (this.boosting)
					pointB = [0,0];
				local pointC = centeredMouse;
				local pointD = centeredMouse;
		
				local previousPoint = [0, 0];
				modifyBrush();
				lineColor(0,0,1,1,14);
		
				local detailBias = 0.1;
				for (local i = detailBias; i < 1; i += detailBias)
				{
					local AB = pointPercentAlongLine(pointA, pointB, i);
					local BC = pointPercentAlongLine(pointB, pointC, i);
					local CD = pointPercentAlongLine(pointC, pointD, i);
					local one = pointPercentAlongLine(AB, BC, i);
					local two = pointPercentAlongLine(BC, CD, i);
					local final = pointPercentAlongLine(one, two, i);
			
					line(previousPoint[0], previousPoint[1], final[0], final[1]);
					previousPoint = final;
				}
				revertBrush();

				local lastSegment = sub2(centeredMouse,previousPoint);
				local reticleRot = -getDegrees2(lastSegment);
		
				modifyWindow(centeredMouse[0],centeredMouse[1],32,32,1.5,reticleRot,0,false);
				fillColor(1,1,1,1);
				image(getArcadePrefix("FinityFlight")+"data/reticle.png",1,1);
				rect(0,0,32,32);
				revertWindow();

				revertWindow();
			}
		} else {
			local trackSize = image(getArcadePrefix("FinityFlight")+"data/track.png",1,1);
			trackSize = scale2(trackSize,0.6);
			additiveBlending(true);
			fillColor(1,1,1,1);
			rect(-trackSize[0]/2,-trackSize[1],trackSize[0],trackSize[1]);
			fillColor(1,1,1,0);
			lineColor(1,0,0,1,2);
			modifyWindow(0,0,0,0,1,-owner.r,false);
			rect(centeredMouse[0]-30,centeredMouse[1]-30,60,60);
			revertWindow();
		}
	}

	function setGun(gunIndex)
	{
		currentWeaponActive = gunIndex;
		if (owner.mods[3].rawin("gun0")) owner.mods[3]["gun0"].weaponActive = false;
		if (owner.mods[3].rawin("gun1")) owner.mods[3]["gun1"].weaponActive = false;
		if (owner.mods[3].rawin("gun2")) owner.mods[3]["gun2"].weaponActive = false;
		
		if (owner.mods[3].rawin("gun" + currentWeaponActive)) owner.mods[3]["gun" + currentWeaponActive].weaponActive = true;
	}
}
