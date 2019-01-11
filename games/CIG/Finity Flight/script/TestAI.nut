class TestAI
{
	name="";
	owner=null;
	
	attackCooldown=0;
	
	funspaceTarget=null;
	
	constructor(name)
	{
		this.name = name;
		attackCooldown = -0;
		
		funspaceTarget = [200, 200];
	}
	
	function update(t)
	{
	
		local ship = owner.mods[1]["ship"];		
		if(!(owner.mods[1].rawin("ship")))
			return false;
		
		headTowardFunTarget(ship);

		//
		//FIRING ROUTINE
		//
		attackCooldown -= t;
		if (attackCooldown <= 0)
		{
			foreach(gun in owner.mods[3])
			{
				gun.fire();
			}
			attackCooldown = 2.0;
		}
		return true;	
	}
	
	function draw(t)
	{
		return true;
	}
	
	function headTowardFunTarget(ship)
	{
		//Sample Moving routine.
		local funVel = ::level.funspace.vel;
		local globalTarget = ::level.funspace.funToGlobal(funspaceTarget);
		local projectedTarget = add2(globalTarget, scale2(funVel, 2.0));
		local vecToTarget = sub2(globalTarget, owner.pos); 
		local distanceToTarget = length2(vecToTarget);
		
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
