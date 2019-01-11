class AINaiad extends AIBase
{
	AIType = 0;

	positionMode = 0;

	attackRadius = 650;
	timeBetweenAttackMin = 3.0;
	timeBetweenAttackMax = 5.0;
	attackTimer = 3.0;
	
	timeBetweenShots = 0.6;
	shotTimer = 0.0;
	timeSpentShooting = 2.0;
	shootingTimer = 0.0;
	hasFiringAngle = false;
	
	chargeUpAlpha = 0.0;
	
	positionArray = null;
	
	constructor(name, type)
	{
		this.name=name;
		AIType = type;
		positionArray = [	[-400, 300], [-200, 150], 
								[-400, 150], [-200, -150], 
								[-400, -150], [-200, -300],
								[200, 300], [400, 150],
								[200, 150], [400, -150],
								[200, -150], [400,-300]	];
								
		local posInfo = pickNextPosition(-1);
		positionMode = posInfo.nextPosMode;
		funspaceTarget = posInfo.nextPos;
	}
	
	
	function update(t)
	{
		if(!(owner.mods[1].rawin("ship")))
			return false;
		local ship = owner.mods[1]["ship"];	
					
		if(shootingTimer > 0 && shootingTimer <= t)
		{
			owner.mods[3]["gun0"].color[1] = 1.0;
			owner.mods[3]["gun0"].color[2] = 1.0;
		}
		
		attackRoutine(t);
		
		local vecToTarget = sub2(::level.funspace.pos, owner.pos);
		
		owner.mods[3]["gun0"].r = -getDegrees2(vecToTarget) + 180;
					

		shootingTimer -= t;
		if (shootingTimer > 0)		//Are we firing shots?
		{
			shotTimer -= t;
			if (shotTimer <= 0)		//Is it time to fire a shot right now?
			{
				fireAtPlayer(t);
				shotTimer = timeBetweenShots;
			}
		}

		headTowardFunTarget(ship);
		
		return true;
	}

	
	
	function attackRoutine(t)
	{
		attackTimer -= t;
		if (attackTimer <= 0.5 && attackTimer > 0)
		{
			local colorVariable = attackTimer;
			if (colorVariable < 0)
				colorVariable = 0;
			colorVariable = (colorVariable * 2) + 0.4;
			owner.mods[3]["gun0"].color[1] = colorVariable;
			owner.mods[3]["gun0"].color[2] = colorVariable;
		}
		if (attackTimer <= 0)
		{		
			attackTimer = randBetween(timeBetweenAttackMin, timeBetweenAttackMax);
			chargeUpAlpha = 0.0;
			
			shootingTimer = timeSpentShooting;
			shotTimer = timeBetweenShots;
			
			//Pick a new position
			local newPosInfo = pickNextPosition(positionMode);
			positionMode = newPosInfo.nextPosMode;
			funspaceTarget = newPosInfo.nextPos;
		}		
	}
	
	function fireAtPlayer(t)
	{		
		local vecToTarget = sub2(::level.funspace.pos, owner.pos);
		
		//Are we close enough to fire?
		if (length2(vecToTarget) > attackRadius)
			return false;
			
		owner.mods[3]["gun0"].fire();
	}
	
	
	function pickNextPosition(currentPositionMode)
	{
		local nextPositionArray = null;
		if (currentPositionMode == -1)
			nextPositionArray = [0, 2, 3, 5];
		else if (currentPositionMode == 0)
			nextPositionArray = [2, 3];
		else if (currentPositionMode == 1)
			nextPositionArray = [0, 1];
		else if (currentPositionMode == 2)
			nextPositionArray = [0, 5];
		else if (currentPositionMode == 3)
			nextPositionArray = [0, 5];
		else if (currentPositionMode == 4)
			nextPositionArray = [3, 5];
		else if (currentPositionMode == 5)
			nextPositionArray = [2, 3];
			
		local nextPositionMode = nextPositionArray[randBetween(0, nextPositionArray.len()-1)];
		local nextPosition = null;
		if (nextPositionMode == 0)
			nextPosition = [randBetween(positionArray[0][0], positionArray[1][0]), randBetween(positionArray[0][1], positionArray[1][1])];
		if (nextPositionMode == 1)
			nextPosition = [randBetween(positionArray[2][0], positionArray[3][0]), randBetween(positionArray[2][1], positionArray[3][1])];
		if (nextPositionMode == 2)
			nextPosition = [randBetween(positionArray[4][0], positionArray[5][0]), randBetween(positionArray[4][1], positionArray[5][1])];
		if (nextPositionMode == 3)
			nextPosition = [randBetween(positionArray[6][0], positionArray[7][0]), randBetween(positionArray[6][1], positionArray[7][1])];
		if (nextPositionMode == 4)
			nextPosition = [randBetween(positionArray[8][0], positionArray[9][0]), randBetween(positionArray[8][1], positionArray[9][1])];
		if (nextPositionMode == 5)
			nextPosition = [randBetween(positionArray[10][0], positionArray[11][0]), randBetween(positionArray[10][1], positionArray[11][1])];
		
		return {nextPosMode = nextPositionMode, nextPos = nextPosition};
	}	

}
