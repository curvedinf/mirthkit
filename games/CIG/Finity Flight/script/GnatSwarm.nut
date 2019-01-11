class GnatSwarm		//This "hivemind" interfaces with a group of Gnats to create a flocking/swarming behavior
{
	name = "";

	pos = null;
	vel = null;
	posStickiness = 0.07;
	velStickiness = 0.07;

	funspaceTarget = null;
	funspaceTargetVel = null;
	funspaceTargetAcc = 0.2;			//This might be more appropriately called "targetVelSpeed" - it has no direction.
	funspaceTargetMaxSpeed = 2.5;
	nextTargetLocation = null;
	
	gnats = null;
	activeGnats = 0;
	minimumGnats = 2;
	
	xPositionArray = null;
	
	lastDamageDirection = null;
	
	constructor(name, swarmSize, pos)
	{
		this.name = name;
		
		this.pos = pos;
		this.vel = [0, 0];
		
		xPositionArray = [-80, -40, 40, 80];
		
		activeGnats = swarmSize;
		gnats = [];
		for(local i = 0; i < swarmSize; i++)
		{
			local yLoc = randBetween(-75, 75);
			local gnatInfo = {localPos = [0,yLoc], positionMode = randBetween(0, 2), timeBeforePosChange = 0};
			gnats.push(gnatInfo);
		}
		
		funspaceTarget = [randBetween(-400, 400), randBetween(-400, 400)];
		funspaceTargetVel = [0,0];
		nextTargetLocation = [randBetween(-400, 400), randBetween(-400, 400)];
		
		lastDamageDirection = [0,-1];

	}
	
	function update(t)
	{
		//Hivemind behavior
		this.pos[0] += vel[0] * t;
		this.pos[1] += vel[1] * t;
	
		local targetPos = ::level.funspace.funToGlobal_noRot(funspaceTarget);
		local targetVel = ::level.funspace.vel;
		
		//Important:  The below method of interpolation only works consistently with a steady framerate.
		this.pos[0] = ((targetPos[0] - this.pos[0]) * posStickiness) + this.pos[0];
		this.pos[1] = ((targetPos[1] - this.pos[1]) * posStickiness) + this.pos[1];
		this.vel[0] = ((targetVel[0] - this.vel[0]) * velStickiness) + this.vel[0];
		this.vel[1] = ((targetVel[1] - this.vel[1]) * velStickiness) + this.vel[1];
		
		//Move the Hivemind's target around
		funspaceTarget = add2(funspaceTarget, funspaceTargetVel);
		
		local vecTowardNewTarget = sub2(nextTargetLocation, funspaceTarget);
		if (length2(vecTowardNewTarget) < 50.0)
			nextTargetLocation = [randBetween(-400, 400), randBetween(-400, 400)];
		vecTowardNewTarget = scale2(normalize2(vecTowardNewTarget), funspaceTargetAcc);
		funspaceTargetVel = add2(funspaceTargetVel, vecTowardNewTarget);
		if (length2(funspaceTargetVel) > funspaceTargetMaxSpeed)
			funspaceTargetVel = (scale2(normalize2(funspaceTargetVel), funspaceTargetMaxSpeed));
		
		
		
		if (activeGnats == 0)
			return false;
	
		//Gnat behavior
		for (local i = 0; i < gnats.len(); i++)
		{
			gnats[i].timeBeforePosChange -= t;
			if (gnats[i].timeBeforePosChange <= 0)
			{
				gnats[i].timeBeforePosChange = randBetween(5, 10) / 10.0;
				
				local tempNum = randBetween(0, 2);
				while (tempNum == gnats[i].positionMode)
				{
					tempNum = randBetween(0, 2);
				}
				gnats[i].positionMode = tempNum;
				
				if (gnats[i].positionMode == 0)
				{
					gnats[i].localPos[0] = randBetween(xPositionArray[0], xPositionArray[1]);
				}
				if (gnats[i].positionMode == 1)
				{
					gnats[i].localPos[0] = randBetween(xPositionArray[1], xPositionArray[2]);
				}
				if (gnats[i].positionMode == 2)
				{
					gnats[i].localPos[0] = randBetween(xPositionArray[2], xPositionArray[3]);
				}
			}
			
			
		}
		
		return true;
	}
	
	function draw(t)
	{
		//local size = image(getArcadePrefix("FinityFlight")+"data/crosshair.png",1,1);
		//fillColor(1.0,1.0,1.0,0.3);  
		//rect(-size[0]/2,-size[1]/2,size[0],size[1]);
	}
	
	function getSwarmInfo(swarmNumber)
	{
		local isDead = false;
		if (activeGnats < minimumGnats)
			isDead = true;
		local gnatPos = rotateDegrees2(gnats[swarmNumber].localPos, -getDegrees2(::level.funspace.vel));
		gnatPos = add2(sub2(this.pos, ::level.funspace.pos), gnatPos);
		local targetspace = sub2(this.pos, ::level.funspace.pos);
		
		return {funPos = gnatPos, isSwarmDead = isDead};
	}
	
}
