class ShieldSpark
{
	name="";
	owner=null;
	color=null;
	scale=1;
	friction=0.9;
	
	shieldEnergyGiven = 1.0;
	magnetDistance = 150.0;
	isMagnetizing = false;
	
	lifeSpan = 5.0;
	life = 0.0;

	flashTime = 2.0;			//How long the spark "flashes" before disappearing.
	flashTimer = 0.06;
	imageIsOff = false;
	
	function constructor(name)
	{
		this.name = name;
		color = [0.3, 0.3, 1.0, 1.0];
		
		life = lifeSpan;
	}
	
	function update(t)
	{
		if (!isMagnetizing)
			life -= t;
		if(life<=0)
		{
			owner.remove = true;
			return true;
		}
		
		local player = ::level.player;
		local vecToPlayer = sub2(player.pos, owner.pos);
		local distanceToPlayer = length2(vecToPlayer);
		
		
		if (!isMagnetizing)
		{
			owner.vel[0] -= owner.vel[0]*t*friction;
			owner.vel[1] -= owner.vel[1]*t*friction;
			//owner.rv -= owner.rv*t*0.9;
		}
		else
		{
			this.owner.pos[0] = ((player.pos[0] - this.owner.pos[0]) * 0.06) + this.owner.pos[0];
			this.owner.pos[1] = ((player.pos[1] - this.owner.pos[1]) * 0.06) + this.owner.pos[1];
			this.owner.vel[0] = ((player.vel[0] - this.owner.vel[0]) * 0.05) + this.owner.vel[0];
			this.owner.vel[1] = ((player.vel[1] - this.owner.vel[1]) * 0.05) + this.owner.vel[1];
		}
			
			
		if (distanceToPlayer <= owner.radius)
		{
			//Spark Collection Code
			if(player.mods[4].rawin("shield"))
			{
				local shield = player.mods[4]["shield"];
				shield.health += shieldEnergyGiven;
				if (shield.health > shield.maxHealth)
					shield.health = shield.maxHealth;
				shield.healthFlashTimer = 0.03;
			}
				
			owner.remove = true;
			return true;
		}	
		if (distanceToPlayer <= magnetDistance)
		{
			isMagnetizing = true;
		}
		
		return true;
	}
	
	function draw(t)
	{
		if (life <= flashTime)
		{
			flashTimer -= t;
			if (flashTimer <= 0)
			{
				imageIsOff = !imageIsOff;
				flashTimer = 0.06;
			}
		}
		
		if (!imageIsOff)
		{
			
			additiveBlending(true);
			local size = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
			fillColor(color[0],color[1],color[2],color[3]);
			rect(-size[0]/4,-size[1]/4,size[0]/2,size[1]/2);
			
			modifyWindow(0,0,0,0,scale,owner.r + 90,false);
			size = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
			rect(-size[0]/4,-size[1]/4,size[0]/2,size[1]/2);
			revertWindow();
		}
	}
	
}
