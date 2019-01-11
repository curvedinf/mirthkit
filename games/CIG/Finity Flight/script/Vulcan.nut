primaryVulcan <- null;

class Vulcan
{
	name="";
	owner=null;
	x=0;
	y=0;
	r=0;
	shotnum=0;
		
	weaponActive = true;
	
	shotSequenceNumber = 0;
	lastSequenceNumber = 0;
	shotSequencePlacement = null;
	flashSequence = 1;
	flashWait = 0;
	flashAdd = false;
	flashPosTimer = 0.0;
	bulletFlash = true;
	
	fired = false;
	
	cooldown = 0;
	secondaryCooldown = 0;
	refire = 0.06;

	damage = 5;
	collisionRadius = 32;
	projectileSpeed = 1500;
	projectileLifeSpan = 1;
	

	constructor(name,x,y,r)
	{
		this.name = name;
		this.x = x;
		this.y = y;
		this.r = r;
		
		shotSequencePlacement = [[0,0],[-12,0],[12,0]]; 
		
	}

	function update(t)
	{
	
		if(::primaryVulcan == this)
		{
			::primaryVulcan = null;
		}
		cooldown -= t;
		secondaryCooldown -= t;
		if(cooldown<0)
			cooldown = 0;
		if(secondaryCooldown < 0)
			secondaryCooldown = 0;
		
			
	
		return true;
	}

	function draw(t)
	{
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
			local xPlacement = 10;
			flashPosTimer -= t;
			if (flashPosTimer <= 0)
			{
				if(rand() % 2 == 0) 
					xPlacement = -10;
				flashPosTimer = 1/60.0;
			}	
			rect(-size[0]*1.2/2+xPlacement,-size[1]/2-112,size[0]*1.2,size[1]*1.5);
		}
	}

	function fire()
	{
		if(cooldown<=0 && secondaryCooldown<=0 && weaponActive)
		{
			local shotPos = rotateDegrees2(shotSequencePlacement[shotSequenceNumber], r + owner.r);
			local pos = add2(owner.pos, rotateDegrees2([this.x, this.y], owner.r ));
			pos = add2(pos, shotPos);
			
			local vel = add2(owner.vel, scale2(setDegrees2(owner.r+r), 1500));
			
			local nextSeq = rand() % 3;
			for(;shotSequenceNumber == nextSeq;)
				nextSeq = rand() % 3;
			
			lastSequenceNumber = shotSequenceNumber;
			shotSequenceNumber = nextSeq;
			
			local shot = Dyne(owner.name+name+shotnum, pos[0], pos[1], owner.r+r, 1, collisionRadius);
			shot.addMod(Shot("shot", damage, getArcadePrefix("FinityFlight")+"data/VulcanShot1.png", getArcadePrefix("FinityFlight")+"data/VulcanShot2.png", 1, projectileLifeSpan, ::level.enemies), 1);
			if(bulletFlash) 
			{
				shot.mods[1]["shot"].imgSwap = !shot.mods[1]["shot"].imgSwap; //This is just some number above what it should take to switch.
				bulletFlash = !bulletFlash;
			}
			else
				bulletFlash = !bulletFlash;
			shot.push(vel);
			
			::level.friendsShots.addDyne(shot);
			
			if(primaryVulcan == null)
			{
				primaryVulcan = this;
				sound(getArcadePrefix("FinityFlight")+"data/vulcan.wav",0,0)
			}
			
			shotnum += 1;
			
			cooldown = refire;
			
			fired = true;
		}
	}
	
	function secondaryFire()
	{
		if (weaponActive && owner.mods[0]["pilot"].secondaryWeaponRecharge <= 0.0)
		{
			owner.addMod(VulcanDrone(name+"d1", -100, 50, -10), 3);
			owner.addMod(VulcanDrone(name+"d2", -66, 0, -6), 3);
			owner.addMod(VulcanDrone(name+"d3", -33, -50, -3), 3);
			owner.addMod(VulcanDrone(name+"d4", 33, -50, 3), 3);
			owner.addMod(VulcanDrone(name+"d5", 66, 0, 6), 3);
			owner.addMod(VulcanDrone(name+"d6", 100, 50, 10), 3);		
			
			secondaryCooldown = 0.5;
			owner.mods[0]["pilot"].secondaryWeaponRecharge = 16.0;
		}
	}
}
