class AIRegulus extends AIBase	
{
	AIType = 0;

	positionMode = 0;
	timeBetweenPositionChange = 4.0;
	positionTimer = 0.0;

	firingRadius = 600;
	timeBetweenFireMin = 3.0;
	timeBetweenFireMax = 5.0;
	fireTimer = 3.0;
	chargeUpTime = 1.0;
	chargingStarted = false;
	firingAhead = true;
	
	positionArray = null;
	isType2AheadOfPlayer = 0;	//Only used by AIType 2
	
	constructor(name, type)
	{
		this.name=name;
		AIType = type;
		positionArray = [[-300, 0], [-100, 0], [0, 0], [100, 0], [300, 0]];
		
		funspaceTarget = [0,randBetween(-200, -400)];
		if (AIType == 1)
		{
			funspaceTarget[1] = randBetween(200, 400);
		}
		else if (AIType == 2 && randBetween(0,1))
			funspaceTarget[1] = randBetween(200, 400);
	}
	
	
	function update(t)
	{
		if(!(owner.mods[1].rawin("ship")))
			return false;
		local ship = owner.mods[1]["ship"];	
		
		changeShipPositionRoutine(t);
		if (AIType != -1)
		{
			firingRoutine(t);
		}
			
		headTowardFunTarget(ship);
		
		return true;
	}
	
	function draw(t)
	{
		local ship = owner.mods[1]["ship"]; 
		local pushY = -30;
		if (firingAhead == false)
			pushY = 30;
		if (chargingStarted)
		{
			//modifyWindow(x,y,width,height,scale,rotation,masking)
			modifyWindow(0, pushY, -1, -1, 1.0, 0.0, false);
			local scale =  (fireTimer / chargeUpTime) * 3;
			local size = image(getArcadePrefix("FinityFlight")+"data/BlasterShot.png", 1, 1);
			size = scale2(size, scale);
			fillColor(1.0,0.2,0.2,1);
			modifyBrush()
			additiveBlending(true);
			for (local i = 0; i < 2; i++)
			rect(-size[0]/2,-size[1]/2,size[0],size[1]); 
			revertBrush(); 
			revertWindow();
		}
	}
	
	function firingRoutine(t)
	{
		fireTimer -= t;
		if (fireTimer <= chargeUpTime && chargingStarted == false)
		{
			local isAhead = pickFiringCone();
		
			if (isAhead == -1 && (AIType == 0 || AIType == 2) )
			{
				firingAhead = false;
				chargingStarted = true;
			}
			else if (isAhead == 1 && (AIType == 1 || AIType == 2) ) 
			{
				firingAhead = true;
				chargingStarted = true;
			}
			else //If the ship isn't in the right place, don't begin firing.
			{
				fireTimer = randBetween(timeBetweenFireMin, timeBetweenFireMax);
			}
		}
		if (fireTimer <= 0)
		{
			fireTimer = randBetween(timeBetweenFireMin, timeBetweenFireMax);
			chargingStarted = false;
					
			if(!(owner.mods[3].rawin("gun0")) || !(owner.mods[3].rawin("gun1")))	//Make sure we *have* guns.
				return false;
			
			//Fire guns.
			if (AIType == 0 && firingAhead  == false)
			{
				owner.mods[3]["gun1"].fire();
			}
			if (AIType == 1 && firingAhead  == true)
			{
				owner.mods[3]["gun0"].fire();
			}
			if (AIType == 2)
			{
				if (firingAhead == false)
					owner.mods[3]["gun1"].fire();
				if (firingAhead == true)
					owner.mods[3]["gun0"].fire();
			}
		
		}
	
	}
	
	function pickFiringCone()		//Finds out if the ship is in the front or back firing cone, or in neither.
	{
		//Find out if the ship (technically, funspace) is in front or behind us.
		local vecToFunspace = sub2(::level.funspace.pos, owner.pos);
		local forwardVec = owner.forward;
		
		local whichFiringCone = 0;
		local dotProduct = dot2(forwardVec, vecToFunspace);
		
		if (dotProduct > 0.6)
			whichFiringCone = 1;
		if (dotProduct < -0.6)
			whichFiringCone = -1;
			
		//Are we close enough to fire?
		if (length2(vecToFunspace) > firingRadius)
			whichFiringCone = 0;
			
		return whichFiringCone;
	}
	
	function changeShipPositionRoutine(t)
	{
		//Change Ship position routine.
		positionTimer -= t;
		if (positionTimer <= 0)
		{
			local tempNum = randBetween(0, 3);
			while (tempNum == positionMode)
			{
				tempNum = randBetween(0, 3);
			}
			positionMode = tempNum;
			
			local newX = 0;
			if (positionMode == 0)	//Currently only modifying the X variable of FunSpace target.
			{
				newX = randBetween(positionArray[0][0], positionArray[1][0]);
			}
			if (positionMode == 1)
			{
				newX = randBetween(positionArray[1][0], positionArray[3][0]);
			}
			if (positionMode == 2)
			{
				newX = randBetween(positionArray[3][0], positionArray[4][0]);
			}
			if (positionMode == 3)
			{
				newX = randBetween(-25, 25);
			}
			funspaceTarget = [newX,funspaceTarget[1]];
			
			positionTimer = timeBetweenPositionChange;
		}		
		
		if (AIType == 2)			//Type2 Reguluses determine front and back position dynamically.
		{
			local vecToPlayer = sub2(::level.funspace.pos, this.owner.pos);
			local dotProduct = dot2(owner.forward, vecToPlayer);
			if (dotProduct <= 0.0)		//Ahead of player
			{
				if (isType2AheadOfPlayer != 1)
				{
					funspaceTarget[1] = randBetween(-200, -400);
					isType2AheadOfPlayer = 1;
				}
			}
			else								//Behind player
			{
				if (isType2AheadOfPlayer != -1)
				{
					funspaceTarget[1] = randBetween(200, 400);
					isType2AheadOfPlayer = -1;
				}
			}
		}
		
	}
	

}