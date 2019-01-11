class VulcanDrone
{
	name="";
	owner=null;
	
	scale = 1.5;
	
	lifeSpan = 5.0;
	attackRadius = 50.0;
	
	playerRelativeTarget = null;  
	
	chaserSet = 0;
	velocityChaser = null;
	velocityDifference = null;
	waverPosition = 0.0;
	
	// below from Vulcan...
	cooldown = 0;
	refire = 0.18;
	x=0;
	y=0;
	r=0;
	shotnum=0;
	
	fired = false;
	damage = 1;
	collisionRadius = 32;
	projectileSpeed = 1500;
	projectileLifeSpan = 1;
	flashSequence = 1;
	flashWait = 0;
	flashAdd = false;
	fixedRot = 0;
	
	positionTimer = 0.0;
	beginningPositionTimer = 0.1;
	
	constructor(name, playerRelativeX, playerRelativeY, rot)
	{
		this.name=name;
		x = 0;
		y = 0;
		playerRelativeTarget = [playerRelativeX, playerRelativeY];
		velocityChaser = [0.0, 0.0];
		velocityDifference = [0.0, 0.0];
		waverPosition = (rand()%100)/100.0;
		fixedRot= rot;
		positionTimer = beginningPositionTimer;
	}
	
	function update(t)
	{
		local ship = owner.mods[1]["ship"];		
		if(!(owner.mods[1].rawin("ship")))
			return false;
		
		positionTimer -= t;
		if (positionTimer < 0)
			positionTimer = 0;
		
		local killMe = false;
		lifeSpan -= t;
		if (lifeSpan <= 0)
			killMe = true;
			
		waverPosition += t;
		if(waverPosition >= 1.0)
			waverPosition -= 1.0;
			
		if(chaserSet)
		{
			velocityDifference = sub2(owner.vel, velocityChaser);
			//velocityDifference = scale2(velocityDifference, 0.5);
			velocityDifference[0] *= 0.2;
			velocityDifference[1] *= 0.8;
			velocityChaser = add2(velocityChaser, velocityDifference);
			velocityDifference = rotateDegrees2(velocityDifference, owner.r);
		}
		else
		{
			velocityChaser = owner.vel;
			chaserSet = 1;
		}
		
		x=playerRelativeTarget[0] - velocityDifference[0] + (sin(waverPosition * 6.28318531) * ((length2(velocityDifference) / 6) + 0.5));
		y=playerRelativeTarget[1] + velocityDifference[1];
		
		x *= (1-(positionTimer / beginningPositionTimer));
		y *= (1-(positionTimer / beginningPositionTimer));
		
		
		if(::primaryVulcan == this)
			::primaryVulcan = null;
		cooldown -= t;
		if(cooldown<0)
			cooldown = 0;
		
		return !killMe;
	}
	
	function draw(t)
	{
		local size = image(getArcadePrefix("FinityFlight")+"data/GunDrone.png",1,1);
		modifyWindow(x, y, size[0], size[1], scale, this.r, false);
		fillColor(1.0, 0.9, 0.9, 1.0);
		rect(0,0,size[0],size[1]);
		revertWindow();
		
		if(fired)
		{
			flashWait = 1/60.0;
		}
		
		if(flashWait!=-1)
		{
			flashWait -= t;
			if(flashWait < 0)
			{
				flashWait = -1;
				flashSequence += 1;
				if(flashSequence>3) flashSequence = 1;
				flashAdd = !flashAdd;
			}
			
			fired = false;
			local size = image(getArcadePrefix("FinityFlight")+"data/VulcanFlash"+flashSequence+".png",1,1);
			additiveBlending(flashAdd);
			fillColor(1,1,1,1);
			size = scale2(size,2);
			
			rect(-size[0]*1.2/2+x,-size[1]/2-112+y,size[0]*1.2,size[1]*1.5);
		}
	}
	
	function fire()
	{
		this.r = fixedRot;
		if(cooldown<=0)
		{
			local shotPos = rotateDegrees2([0,0], r + owner.r);
			local pos = add2(owner.pos, rotateDegrees2([this.x, -this.y], owner.r ));
			pos = add2(pos, shotPos);
			
			local vel = add2(owner.vel, scale2(setDegrees2(owner.r+r), 1500));
			
			
			local shot = Dyne(owner.name+name+shotnum, pos[0], pos[1], owner.r+r, 1, collisionRadius);
			
			shot.addMod(Shot("shot", 5, getArcadePrefix("FinityFlight")+"data/VulcanShot1.png", getArcadePrefix("FinityFlight")+"data/VulcanShot2.png", 1, projectileLifeSpan, ::level.enemies), 1);
			shot.push(vel);
			
			::level.friendsShots.addDyne(shot);
			
			if(primaryVulcan == null)
			{
				//primaryVulcan = this;
				//sound(getArcadePrefix("FinityFlight")+"data/vulcan.wav",0,0)
			}
			
			shotnum += 1;
			
			cooldown = refire;
			
			fired = true;
		}
	}
	
	function secondaryFire()
	{
	}
}
