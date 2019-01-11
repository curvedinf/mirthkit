class AIMercury extends AIBase
{
	AIType = 0;
	
	targetDistanceFromShip = 300;

	firingRadius = 600;
	timeBetweenFire = 1.5;
	fireTimer = 0.0;
	
	tempTarget = null;
	chargeSize = 0.0;
	
	setSlideVariables = false;
	slideFriction = 0.0;
	slideRotation = 0.0;
	
	constructor(name, type)
	{
		this.name=name;
		AIType = type;		
	}
	
	function update(t)
	{
		if(!(owner.mods[1].rawin("ship")))
			return false;
		local ship = owner.mods[1]["ship"];
		
		if(!setSlideVariables)
		{
				slideFriction = ship.rotFriction * 3.0;
				slideRotation = ship.turnMax * 5.0;
				setSlideVariables = true;
		}
		
		chargeSize = 0.0;
		//changeShipPositionRoutine(t);
		//fireRoutine(t);
		
		fireTimer += t;
		local localVector = ::level.funspace.globalToFun(owner.pos);
		if(length2(localVector) < 400 || fireTimer > 1.5)
		{
			if(fireTimer > 1.5)
			{
				ship.rotFriction = slideFriction;
				ship.turnMax = slideRotation;
				if(fireTimer > 2.5)
				{
					if(fireTimer > 3.0)
					{
						if(fireTimer > 3.45)
						{
							ship.rotFriction = slideFriction / 3.0;
							ship.turnMax = slideRotation / 5.0;
							chargeSize = 0.0;
							fireTimer = -2.0;
						}
						else
							chargeSize = (3.5 - fireTimer) * 25;
						owner.mods[3]["gun0"].fire();
					}
					else
						chargeSize = 5 + (fireTimer - 2.5) * 20;
					owner.rv = 0;
				}
				else
				{
					chargeSize = (fireTimer - 1.5) * 5;
					funspaceTarget = [0,0];
					lookTowardFunTarget(ship);
				}
				owner.mods[1]["ship"].slide();
				return true;
			}
		}
		else if(fireTimer > 0)
			fireTimer = 0.0;
		
		changeShipPositionRoutine(t);
		headTowardFunTarget(ship);
		
		return true;
	}
	
	function draw(t)
	{
		local ship = owner.mods[1]["ship"]; 
		local size = image(getArcadePrefix("FinityFlight")+"data/shockwave.png", 1, 1);
		size = scale2([50,50], chargeSize);
		fillColor(0.6,1,0.3,1);
		additiveBlending(true);
		//for (local i = 0; i < 2; i++)
		rect(-size[0]/2,-size[1]/2,size[0],size[1]);
	}
	
	function fireRoutine(t)
	{
	}
	
	function changeShipPositionRoutine(t)
	{
		local localVector = ::level.funspace.globalToFun(owner.pos);
		localVector = scale2(localVector, (300.0 / length2(localVector)));
		funspaceTarget = localVector;
	}
	
	
}
