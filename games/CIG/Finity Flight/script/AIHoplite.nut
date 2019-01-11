class AIHoplite extends AIBase
{
	leftFunspace = [200,-200];
	rightFunspace = [-200,-200];
	switchLeft = false;
	switchLength = 4;
	switchTimer = 0;
	
	subtype = null;
	
	playerDirection = null;
	
	constructor(name,subtype)
	{
		this.subtype = subtype;
		base.constructor(name);
		playerDirection = [0, 0];
	}
	
	function update(t)
	{
		local result = base.update(t);
		
		// movement
		switchTimer -= t;
		if(switchTimer <= 0)
		{
			switchTimer = switchLength;
			switchLeft = !switchLeft;
			if(switchLeft)
				funspaceTarget = leftFunspace;
			else
				funspaceTarget = rightFunspace;
			
			funspaceTarget = [randBetween(leftFunspace[0], rightFunspace[0]), randBetween(leftFunspace[1], rightFunspace[1])]
		}
		
		
		
		// Point shield toward player
		local player = null;
		if("player" in ::level.friends.dynes)
			player = ::level.friends.dynes["player"];
		
		local shield = null;
		if("shield" in owner.mods[4])
			shield = owner.mods[4]["shield"];
			
		playerDirection = normalize2(sub2(owner.pos, player.pos));
		
		if(player != null && shield != null)
		{
			shield.customAngle = true;
			shield.currentAngle = playerDirection;
		}
		
		local ship = null;
		if("ship" in owner.mods[1])
			ship = owner.mods[1]["ship"];
		
		if(ship != null)
		{
			ship.isHoplite = true;
			ship.hopliteFacing = -getDegrees2(playerDirection) - owner.r;
		}
		
		return result;
	}
	
	function draw(t)
	{
		return true;
	}
}
