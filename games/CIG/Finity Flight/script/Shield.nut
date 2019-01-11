class Shield
{
	name="";
	owner=null;
	health=1;
	maxHealth=1;
	radius=0;
	thickness=0;
	customAngle=false;
	currentAngle=null;
	
	damageFlashTimer = 0.0;
	drawDamage = 0;
	healthFlashTimer = 0.0;
	drawHealth = 0;
	
	color = null;
	
	boosting=false;
	
	type = 0;
	
	constructor(name, maxHealth, thickness, radius, startPercent)
	{
		if(maxHealth == 0)
			maxHealth = 1;
		this.name = name;
		this.health = maxHealth;
		this.maxHealth = maxHealth * (1/startPercent);
		this.radius = radius;
		this.thickness = thickness;
		currentAngle = [0, -1];
		color = [1.0, 1.0, 1.0, 1.0];
	}
	
	function update(t)
	{
		//Check to see if it should be deleted
		if(health <= 0)
		{
			return false;
		}
		//Set the current shield direction
		if(!customAngle)
		{
			currentAngle = owner.forward;
		}
		
		if(damageFlashTimer>0)
		{
			damageFlashTimer -= t;
			drawDamage = 2;
		}
		if(healthFlashTimer>0)
		{
			healthFlashTimer -= t;
			drawHealth = 2;
		}
		
		local pilot = owner.mods[0]["pilot"];
		if("boosting" in pilot)
			boosting = pilot.boosting;
		else
			boosting = false;
		
		return true;
	}
	
	function damage(amount, damageType)
	{
		if (owner.name == "player")
		{
			::level.scoreKeeper.playerHit();
		}
		local damageModifier = 1.0;
		if(type && damageType)
		{
		}
		damageFlashTimer = 0.03;
		if(amount * damageModifier>health)
		{
			local leftover = amount-health/damageModifier;
			health = 0;
			return leftover;
		}
		else
		{
			health -= amount * damageModifier;
			return 0;
		}
	}
	
	function draw(t)
	{
		local currentAngleDegrees = 180 - getDegrees2(currentAngle) - owner.r;
		
		local offsetAngle = ((maxHealth - (0.0+health)) / maxHealth) * 180;
		local drawAngle = offsetAngle + currentAngleDegrees;
		local stopAngle = 360 - offsetAngle + currentAngleDegrees;
		local currentVertex = [0,0];
		local vert1 = [0, (radius - thickness)];
		local vert2 = [0, (radius + thickness)];
		vert1 = rotateDegrees2(vert1, drawAngle);
		vert2 = rotateDegrees2(vert2, drawAngle);
		drawAngle += 10;
		local vert3;
		image(getArcadePrefix("FinityFlight")+"data/shield.png",1,1);
		if(boosting || drawHealth > 0)
		{
			fillColor(0.1,1,0.1,1);
		}
		else if (drawDamage > 0 && owner.name == "player")
		{
			fillColor(1.0,0.1,0.1,1);
		}
		else
			fillColor(color[0],color[1],color[2],color[3]);
		additiveBlending(true);
		beginTriangles();
		local keepLooping = true;
		for(;keepLooping; drawAngle += 10)
		{
			if(drawAngle >= stopAngle)
			{
				drawAngle = stopAngle;
				keepLooping = false;
			}
			vert3 = [0, (radius - thickness)];
			vert3 = rotateDegrees2(vert3, drawAngle);
			textureCoord(0,0);
			vertex(vert1[0], vert1[1]);
			textureCoord(0,1);
			vertex(vert2[0], vert2[1]);
			textureCoord(0,0);
			vertex(vert3[0], vert3[1]);
			vert1 = vert3;
			vert3 = [0, (radius + thickness)];
			vert3 = rotateDegrees2(vert3, drawAngle);
			textureCoord(0,0);
			vertex(vert1[0], vert1[1]);
			textureCoord(0,1);
			vertex(vert2[0], vert2[1]);
			textureCoord(0,1);
			vertex(vert3[0], vert3[1]);
			vert2 = copy2(vert3);
		}
		endTriangles();
		
		if(drawDamage>0)
		{
			drawDamage -= 1;
			drawHealth = 0;
			draw(t);
		}
		if (drawHealth>0)
		{
			drawHealth -= 1;
			draw(t)
		}
	}
}
