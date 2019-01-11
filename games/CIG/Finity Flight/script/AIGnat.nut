class AIGnat
{
	name = "";
	owner = null;
	
	funspaceTarget = null;
	
	swarm = null;
	swarmNumber = 0;
	
	constructor(name, swarm, swarmNum)
	{
		this.name = name;
		funspaceTarget = [0, 0];
		
		this.swarm = swarm;
		swarmNumber = swarmNum;
	}
	
	function update(t)
	{	
		if(!(owner.mods[1].rawin("ship")))
			return false;
		local ship = owner.mods[1]["ship"];	
		
		local swarmInfo = swarm.getSwarmInfo(swarmNumber);
		
		funspaceTarget = swarmInfo.funPos;
		headTowardFunTarget(ship);
		
		if (swarmInfo.isSwarmDead == true)
		{
			owner.mods[1]["ship"].health = 0;
			owner.mods[1]["ship"].lastDamageDirection = swarm.lastDamageDirection;
		}
			
		//owner.pos = swarmInfo.funPos;
		
		return true;
	}
	
	function draw(t)
	{
		return true;
	}
	
	function gnatKilled()
	{
		this.swarm.activeGnats -= 1;
	}
	
	function headTowardFunTarget(ship)
	{
		local funVel = swarm.vel;
		local globalTarget = ::level.funspace.funToGlobal_noRot(funspaceTarget);		
		local vecToTarget = sub2(globalTarget, owner.pos); 
		local distanceToTarget = length2(vecToTarget);
		
		local 	projScalar = 2.0;
	
		local projectedTarget = add2(globalTarget, scale2(funVel, projScalar));
		local targetRight = quarterCCW2(funVel);
		local leftRightComponent = component2(scale2(vecToTarget, -1), targetRight);
		projectedTarget = add2(projectedTarget, scale2(targetRight, leftRightComponent / -200));
	
		//--Determine turn amount.--
		ship.turn(howMuchLeft2(owner.forward,owner.pos,projectedTarget) * 10);
		
		//--Determine thrust amount.--
		//Are we in front or behind the target?
		local howFarBehind = component2(funVel, vecToTarget);
		local distanceMod = (howFarBehind * 1) / 200;  //if howFarBehind < 0, we are in front. 
		//if (distanceMod < -1.0) distanceMod = -1.0; 
		//if (distanceMod > 1.0) distanceMod = 1.0;
		
		//Are we moving faster or slower than the target?
		local mySpeed = length2(owner.vel);
		local targetSpeed = length2(funVel);
		local speedDiff = targetSpeed - mySpeed;
		local speedMod = speedDiff / 100;
		//if (speedMod < -1.0) speedMod = -1.0; 
		//if (speedMod > 1.0) speedMod = 1.0;
		
		local disNul = distanceToTarget / 100;
		//	if (disNul > 1.0) disNul = 1.0;
		ship.thrust(ship.thrustAmount + ((distanceMod * disNul) + (speedMod)));
	}
	
}