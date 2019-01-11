class AIBase
{
	name = "";
	owner = null;
	
	funspaceTarget = null;
	
	constructor(name)
	{
		this.name = name;
		funspaceTarget = [0, 0];
	}
	
	function update(t)
	{	
		if(!(owner.mods[1].rawin("ship")))
			return false;
		local ship = owner.mods[1]["ship"];	
		
		headTowardFunTarget(ship);
		
		return true;
	}
	
	function draw(t)
	{
		return true;
	}
	
	function headTowardFunTarget(ship)
	{
		local funVel = ::level.funspace.vel;
		local globalTarget = ::level.funspace.funToGlobal(funspaceTarget);
		local vecToTarget = sub2(globalTarget, owner.pos); 
		local distanceToTarget = length2(vecToTarget);
		
		local projectedTarget = add2(globalTarget, scale2(funVel, 2.0));
		local targetRight = quarterCCW2(funVel);
		local leftRightComponent = component2(scale2(vecToTarget, -1), targetRight);
		projectedTarget = add2(projectedTarget, scale2(targetRight, leftRightComponent / -500));
	
		
		ship.turn(howMuchLeft2(owner.forward,owner.pos,projectedTarget) * 10);
		
		//--Determine thrust amount.--
		local howFarBehind = component2(funVel, vecToTarget);							//Are we in front or behind the target?
		local distanceMod = howFarBehind / 300;  //if howFarBehind < 0, we are in front. 
		//if (distanceMod < -1.0) distanceMod = -1.0; 
		//if (distanceMod > 1.0) distanceMod = 1.0;
		
		local mySpeed = length2(owner.vel);														//Are we moving faster or slower than the target?
		local targetSpeed = length2(funVel);
		local speedDiff = targetSpeed - mySpeed;
		local speedMod = speedDiff / 100;
		if(speedMod > 0.02) speedMod = 0.02;
		//if (speedMod < -1.0) speedMod = -1.0; 
		//if (speedMod > 1.0) speedMod = 1.0;
		
		local disNul = distanceToTarget / 100;
		ship.thrust(ship.thrustAmount + ((distanceMod * disNul) + (speedMod)));
	}
	
	function lookTowardFunTarget(ship)
	{
		local funVel = ::level.funspace.vel;
		local globalTarget = ::level.funspace.funToGlobal(funspaceTarget);
		//local projectedTarget = add2(globalTarget, scale2(funVel, 2.0));
		
		local turnAmount = howMuchLeft2(owner.forward,owner.pos,globalTarget) * 100;
		ship.turn(turnAmount);
		ship.thrust(0);
	}
	
}