class AIJanus extends AIBase
{
	AIType = 0;
	
	positionRotationTime = 10.0;	//It should take this many seconds for the funspace target to rotate the player completely
	positionTimer = 0.0
	targetDistanceFromShip = 300;
	
	attackRadius = 650;
	timeBetweenAttackMin = 3.0;
	timeBetweenAttackMax = 5.0;
	attackTimer = 3.0;
	

	constructor(name, type)
	{
		this.name=name;
		AIType = type;
		
		//Pick a random place to start.
		local tempVec = [0, -1];
		tempVec = rotateDegrees2(tempVec, randBetween(0, 359));
		tempVec = scale2(tempVec, targetDistanceFromShip);
		funspaceTarget = tempVec;
	}
	
	function update(t)
	{
		if(!(owner.mods[1].rawin("ship")))
			return false;
		local ship = owner.mods[1]["ship"];	
		
		changeShipPositionRoutine(t);
		attackRoutine(t);
		headTowardFunTarget(ship);
		
		return true;
	}
	
	function draw(t)
	{

	}
	
	function attackRoutine(t)
	{
		local vecToTarget = sub2(::level.funspace.pos, owner.pos);
		
		owner.mods[3]["gun0"].r = -getDegrees2(vecToTarget) + 180;
		
		attackTimer -= t;
		if (attackTimer <= 1.0 && attackTimer > 0)
		{
			
		}
		if (attackTimer <= 0)
		{		
			attackTimer = randBetween(timeBetweenAttackMin, timeBetweenAttackMax);
			fireAtPlayer(t);
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
	
	function changeShipPositionRoutine(t)
	{
			local tempGetRadians = getRadians2(funspaceTarget)+ degreesToRadians(10.0) * t;
			
			local cosine = cos(tempGetRadians);
			local sine = sin(tempGetRadians);
			local tempRadians = [sine,cosine];
			
			local tempLength = length2(funspaceTarget);
			funspaceTarget = scale2(tempRadians,tempLength);
	}
	
	
}